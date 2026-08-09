#!/usr/bin/env ruby
# frozen_string_literal: true

# A manual, single-account X publisher. Uses only the Ruby standard library.

require "base64"
require "digest"
require "fileutils"
require "json"
require "net/http"
require "optparse"
require "securerandom"
require "socket"
require "time"
require "uri"

$stdout.sync = true

API = "https://api.x.com"
AUTHORIZE_URL = "https://x.com/i/oauth2/authorize"
CALLBACK = "http://127.0.0.1:8765/callback"
TOOLS = File.expand_path(__dir__)
REPOSITORY = File.dirname(TOOLS)
ENV_FILE = File.join(TOOLS, ".env")
STATE = File.join(TOOLS, ".x-publisher")
TOKEN_FILE = File.join(STATE, "token.json")
PUBLICATIONS_FILE = File.join(STATE, "publications.jsonl")
HISTORICAL_PUBLICATIONS_FILE = File.join(STATE, "historical-publications.jsonl")
SCOPES = %w[tweet.read tweet.write users.read media.write offline.access].freeze
IMAGE_TYPES = {
  ".jpg" => "image/jpeg", ".jpeg" => "image/jpeg", ".png" => "image/png",
  ".gif" => "image/gif", ".webp" => "image/webp"
}.freeze

def fail(message)
  warn "Error: #{message}"
  exit 1
end

def load_environment_value(name)
  fail "Missing #{ENV_FILE}. Add X_CLIENT_ID=..." unless File.file?(ENV_FILE)

  File.foreach(ENV_FILE) do |line|
    key, value = line.strip.split("=", 2)
    next unless key == name && value

    value = value.strip
    value = value[1..-2] if value.match?(/\A(['"]).*\1\z/)
    return value unless value.empty?
  end
  fail "#{name} is required in #{ENV_FILE}."
end

def load_client_id
  load_environment_value("X_CLIENT_ID")
end

def expected_account
  load_environment_value("X_ACCOUNT").delete_prefix("@").downcase
end

def authenticated_user(token)
  user = x_request(:get, "/2/users/me?user.fields=created_at,description,public_metrics", token: token).fetch("data")
  unless user.fetch("username").downcase == expected_account
    fail "The token belongs to @#{user["username"]}, but X_ACCOUNT is @#{expected_account}."
  end
  user
end

def save_token(token)
  FileUtils.mkdir_p(STATE, mode: 0o700)
  token["expires_at"] = Time.now.to_i + Integer(token.fetch("expires_in", 0)) - 60
  File.write(TOKEN_FILE, JSON.pretty_generate(token) + "\n", mode: "w", perm: 0o600)
  File.chmod(0o600, TOKEN_FILE)
end

def read_token
  fail "No authorization token. Run: ruby _tools/x.rb authorize" unless File.file?(TOKEN_FILE)

  JSON.parse(File.read(TOKEN_FILE))
end

def x_request(method, path, token: nil, body: nil, content_type: nil)
  uri = URI.join(API, path)
  request = Net::HTTP.const_get(method.to_s.capitalize).new(uri)
  request["Authorization"] = "Bearer #{token}" if token
  request["Content-Type"] = content_type if content_type
  request.body = body if body

  response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 15, read_timeout: 60) do |http|
    http.request(request)
  end
  return JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)

  fail "X returned #{response.code}: #{response.body}"
end

def token_request(fields)
  x_request(
    :post,
    "/2/oauth2/token",
    body: URI.encode_www_form(fields),
    content_type: "application/x-www-form-urlencoded"
  )
end

def access_token
  token = read_token
  if Integer(token.fetch("expires_at", 0)) <= Time.now.to_i
    refresh = token_request(
      "refresh_token" => token.fetch("refresh_token"),
      "grant_type" => "refresh_token",
      "client_id" => load_client_id
    )
    save_token(refresh)
    token = refresh
  end
  token.fetch("access_token")
rescue KeyError
  fail "The saved token is incomplete. Run: ruby _tools/x.rb authorize"
end

def authorize
  client_id = load_client_id
  verifier = SecureRandom.urlsafe_base64(64)
  challenge = Base64.urlsafe_encode64(Digest::SHA256.digest(verifier), padding: false)
  state = SecureRandom.urlsafe_base64(32)
  query = URI.encode_www_form(
    "response_type" => "code", "client_id" => client_id, "redirect_uri" => CALLBACK,
    "scope" => SCOPES.join(" "), "state" => state, "code_challenge" => challenge,
    "code_challenge_method" => "S256"
  )

  puts "Open this URL in your browser and approve access:\n\n#{AUTHORIZE_URL}?#{query}\n\nWaiting five minutes for #{CALLBACK}…"
  server = TCPServer.new("127.0.0.1", 8765)
  readable = IO.select([server], nil, nil, 300)
  fail "No authorization callback arrived." unless readable

  client = server.accept
  request_line = client.gets.to_s
  path = request_line.split[1].to_s
  params = URI.decode_www_form(URI.parse("http://127.0.0.1#{path}").query.to_s).to_h
  approved = URI.parse(path).path == "/callback" && params["state"] == state && params["code"]
  client.write "HTTP/1.1 #{approved ? "200 OK" : "400 Bad Request"}\r\nContent-Type: text/plain\r\n\r\n#{approved ? "Authorization received. Return to the terminal." : "Authorization failed. Return to the terminal."}"
  client.close
  server.close
  fail "Authorization was declined or did not match this request." unless approved

  token = token_request(
    "code" => params.fetch("code"), "grant_type" => "authorization_code", "client_id" => client_id,
    "redirect_uri" => CALLBACK, "code_verifier" => verifier
  )
  fail "X did not issue a refresh token." unless token["access_token"] && token["refresh_token"]

  save_token(token)
  puts "Authorized. The local token is stored at #{TOKEN_FILE}."
rescue Errno::EADDRINUSE
  fail "#{CALLBACK} is already in use. Stop the other local authorization command and try again."
ensure
  server&.close unless server&.closed?
end

def image_type(path)
  type = IMAGE_TYPES[File.extname(path).downcase]
  fail "Unsupported image type. Use JPG, PNG, GIF, or WebP." unless type
  fail "Image not found: #{path}" unless File.file?(path)
  fail "Images must be 5 MB or smaller." if File.size(path) > 5 * 1024 * 1024
  type
end

def load_publication_card(path)
  card_path = File.expand_path(path)
  fail "Publication card not found: #{card_path}" unless File.file?(card_path)

  card = JSON.parse(File.read(card_path))
  %w[id status image].each do |field|
    fail "Publication card #{card_path} is missing #{field}." unless card[field].is_a?(String) && !card[field].strip.empty?
  end
  card["text"] = publication_text(card)
  image_type(card_image_path(card))
  [card_path, card]
rescue JSON::ParserError => error
  fail "Publication card #{card_path} is not valid JSON: #{error.message}"
end

def publication_text(card)
  text = if card["text"].is_a?(String) && !card["text"].strip.empty?
           card.fetch("text")
         else
           source_section_text(card)
         end
  series = card["series"]
  text = text.sub(/\A#{Regexp.escape(series)}\s+—\s+[IVXLCDM]+\/\d+\n\n/, "") if series.is_a?(String) && !series.empty?
  footer = card["footer"]
  text = "#{text.rstrip}\n\n#{footer}" if footer.is_a?(String) && !footer.strip.empty?
  text
end

def source_section_text(card)
  source = card["source"]
  fail "Publication card #{card.fetch("id")} needs text or a source section." unless source.is_a?(Hash)
  source_file = source["file"]
  section_numbers = source["sections"] || [source["section"]]
  fail "Publication card #{card.fetch("id")} has an invalid source file." unless source_file.is_a?(String) && !source_file.empty?
  fail "Publication card #{card.fetch("id")} has invalid source sections." unless section_numbers.is_a?(Array) && section_numbers.all? { |number| number.is_a?(Integer) && number >= 0 }

  path = File.expand_path(source_file, REPOSITORY)
  fail "Source file is outside the repository." unless path.start_with?("#{REPOSITORY}/")
  fail "Source file not found: #{path}" unless File.file?(path)

  sections = File.read(path).split(/^## /)
  section_numbers.map do |number|
    body = sections[number]
    fail "Source section #{number} was not found in #{source_file}." unless body
    body = if number.zero?
             body.sub(/\A---\n.*?\n---\n/m, "")
           else
             body.sub(/\A[^\n]*\n/, "")
           end
    body.gsub(/<figure.*?<\/figure>\n*/m, "").strip
  end.join("\n\n")
end

def card_image_path(card)
  File.expand_path(card.fetch("image"), REPOSITORY)
end

def publication_records
  [HISTORICAL_PUBLICATIONS_FILE, PUBLICATIONS_FILE].flat_map do |path|
    next [] unless File.file?(path)

    File.foreach(path).filter_map do |line|
      next if line.strip.empty?

      JSON.parse(line)
    end
  end
rescue JSON::ParserError => error
  fail "A publication ledger is not valid JSON Lines: #{error.message}"
end

def publication_recorded_for_card?(card_id)
  publication_records.any? { |record| record["card_id"] == card_id }
end

def append_publication(record)
  FileUtils.mkdir_p(STATE, mode: 0o700)
  File.chmod(0o700, STATE)
  File.open(PUBLICATIONS_FILE, File::WRONLY | File::CREAT | File::APPEND, 0o600) do |file|
    file.write(JSON.generate(record) + "\n")
    file.flush
    file.fsync
  end
  File.chmod(0o600, PUBLICATIONS_FILE)
end

def save_publication_card(path, card)
  temporary_path = "#{path}.#{Process.pid}.tmp"
  File.write(temporary_path, JSON.pretty_generate(card) + "\n", mode: "w", perm: 0o600)
  File.chmod(0o600, temporary_path)
  File.rename(temporary_path, path)
ensure
  File.delete(temporary_path) if temporary_path && File.exist?(temporary_path)
end

def record_publication(id, text, image_path, card_path: nil, card: nil)
  url = "https://x.com/i/web/status/#{id}"
  record = {
    "published_at" => Time.now.utc.iso8601,
    "x_post_id" => id,
    "x_post_url" => url,
    "card_id" => card && card.fetch("id"),
    "series" => card && card["series"],
    "part" => card && card["part"],
    "card_file" => card_path,
    "text" => text,
    "image" => image_path,
    "has_url" => text.match?(%r{https?://})
  }.compact
  append_publication(record)

  return url unless card

  card["status"] = "published"
  card["published_at"] = record.fetch("published_at")
  card["x_post_id"] = id
  card["x_post_url"] = url
  save_publication_card(card_path, card)
  url
end

def wait_for_media(media_id, token, result)
  processing = result.dig("data", "processing_info")
  while processing && %w[pending in_progress].include?(processing["state"])
    sleep [Integer(processing.fetch("check_after_secs", 1)), 10].min
    result = x_request(:get, "/2/media/upload?#{URI.encode_www_form("command" => "STATUS", "media_id" => media_id)}", token: token)
    processing = result.dig("data", "processing_info")
  end
  fail "X could not process the image: #{processing.inspect}" if processing && processing["state"] == "failed"
end

def upload_image(path, token)
  type = image_type(path)
  initialize = x_request(
    :post, "/2/media/upload/initialize", token: token,
    body: JSON.generate("media_category" => "tweet_image", "media_type" => type, "total_bytes" => File.size(path)),
    content_type: "application/json"
  )
  media_id = initialize.dig("data", "id") or fail "X did not return a media ID."
  x_request(
    :post, "/2/media/upload/#{media_id}/append", token: token,
    body: JSON.generate("media" => Base64.strict_encode64(File.binread(path)), "segment_index" => 0),
    content_type: "application/json"
  )
  finalized = x_request(:post, "/2/media/upload/#{media_id}/finalize", token: token)
  wait_for_media(media_id, token, finalized)
  media_id
end

def post(argv)
  options = { dry_run: false }
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: ruby _tools/x.rb post (--file CARD.json | --text TEXT [--link URL] [--image FILE]) [--dry-run]"
    opts.on("--file FILE", "Prepared local publication-card JSON file") { |value| options[:file] = value }
    opts.on("--text TEXT", "Post text") { |value| options[:text] = value }
    opts.on("--link URL", "Optional link, appended to the text") { |value| options[:link] = value }
    opts.on("--image FILE", "Optional JPG, PNG, GIF, or WebP image") { |value| options[:image] = value }
    opts.on("--dry-run", "Show the content without calling X") { options[:dry_run] = true }
  end
  parser.parse!(argv)
  fail "Unexpected argument: #{argv.first}" unless argv.empty?

  if options[:file]
    fail "--file cannot be combined with --text, --link, or --image." if options[:text] || options[:link] || options[:image]
    card_path, card = load_publication_card(options[:file])
    text = card.fetch("text")
    image_path = card_image_path(card)
  else
    card_path = nil
    card = nil
    text = [options[:text], options[:link]].compact.join(" ").strip
    image_path = options[:image]
    fail "Provide --file, --text, --link, or --image." if text.empty? && !image_path
    image_type(image_path) if image_path
  end

  if options[:dry_run]
    puts JSON.pretty_generate("card_id" => card && card.fetch("id"), "text" => text, "image" => image_path)
    return
  end

  if card
    fail "Publication card #{card_path} is #{card.fetch("status")}, not draft." unless card.fetch("status") == "draft"
    fail "Publication card #{card.fetch("id")} is already recorded as published." if publication_recorded_for_card?(card.fetch("id"))
  end

  token = access_token
  body = {}
  body["text"] = text unless text.empty?
  body["media"] = { "media_ids" => [upload_image(image_path, token)] } if image_path
  response = x_request(:post, "/2/tweets", token: token, body: JSON.generate(body), content_type: "application/json")
  id = response.dig("data", "id") or fail "X returned no post ID."
  url = record_publication(id, text, image_path, card_path: card_path, card: card)
  puts "Published and recorded: #{url}"
end

def preview(argv)
  options = {}
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: ruby _tools/x.rb preview --file CARD.json"
    opts.on("--file FILE", "Local publication-card JSON file") { |value| options[:file] = value }
  end
  parser.parse!(argv)
  fail "Provide --file CARD.json." unless options[:file]
  fail "Unexpected argument: #{argv.first}" unless argv.empty?

  card_path, card = load_publication_card(options[:file])
  puts "Preview: #{card.fetch("id")}" 
  puts "Card: #{card_path}"
  puts "Status: #{card.fetch("status")}" 
  puts "Image: #{card_image_path(card)}" 
  puts "Characters: #{card.fetch("text").length}"
  puts "\n#{"-" * 72}\n\n#{card.fetch("text")}"
end

def history(argv)
  limit = 20
  OptionParser.new { |opts| opts.on("--limit COUNT", Integer, "1–100, default 20") { |value| limit = value } }.parse!(argv)
  fail "--limit must be between 1 and 100." unless (1..100).cover?(limit)
  fail "Unexpected argument: #{argv.first}" unless argv.empty?

  records = publication_records.sort_by { |record| record.fetch("published_at") }.last(limit).reverse
  if records.empty?
    puts "No locally recorded publications."
    return
  end

  records.each do |record|
    source = if record["card_id"]
               record["card_id"]
             elsif record["historical_import"]
               "#{record.fetch("series")} (historical)"
             else
               "manual"
             end
    puts "#{record.fetch("published_at")}  #{record.fetch("x_post_url")}  #{source}"
    puts record.fetch("text")
    puts "image #{record["image"]}" if record["image"]
    puts "historical import: #{record["archive_note"]}" if record["historical_import"]
    puts
  end
end

def me
  user = authenticated_user(access_token)
  puts "@#{user["username"]} (#{user["id"]})\n#{user["name"]}\n#{user["description"]}"
end

def posts(argv)
  limit = 10
  OptionParser.new { |opts| opts.on("--limit COUNT", Integer, "1–100, default 10") { |value| limit = value } }.parse!(argv)
  fail "--limit must be between 1 and 100." unless (1..100).cover?(limit)
  token = access_token
  user = authenticated_user(token)
  query = URI.encode_www_form("max_results" => [limit, 5].max, "tweet.fields" => "created_at,public_metrics")
  response = x_request(:get, "/2/users/#{user.fetch("id")}/tweets?#{query}", token: token)
  response.fetch("data", []).first(limit).each do |item|
    metrics = item.fetch("public_metrics", {})
    puts "#{item["created_at"]}  https://x.com/#{user["username"]}/status/#{item["id"]}"
    puts item["text"]
    puts "likes #{metrics["like_count"] || 0}  reposts #{metrics["retweet_count"] || 0}  replies #{metrics["reply_count"] || 0}\n\n"
  end
end

def usage
  warn <<~TEXT
    Usage:
      ruby _tools/x.rb authorize
      ruby _tools/x.rb post (--file CARD.json | --text "Text" [--link URL] [--image FILE]) [--dry-run]
      ruby _tools/x.rb preview --file CARD.json
      ruby _tools/x.rb history [--limit COUNT]
      ruby _tools/x.rb me
      ruby _tools/x.rb posts [--limit COUNT]
  TEXT
  exit 1
end

command = ARGV.shift
case command
when "authorize" then authorize
when "post" then post(ARGV)
when "preview" then preview(ARGV)
when "history" then history(ARGV)
when "me" then me
when "posts" then posts(ARGV)
else usage
end
