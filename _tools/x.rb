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
PRIVATE_DRAFTS = File.join(TOOLS, "private-drafts")
CADENCE_INTERVAL_HOURS = 24
SCOPES = %w[tweet.read tweet.write users.read media.write offline.access].freeze
IMAGE_TYPES = {
  ".jpg" => "image/jpeg", ".jpeg" => "image/jpeg", ".png" => "image/png",
  ".gif" => "image/gif", ".webp" => "image/webp"
}.freeze
ARTICLE_BLOCK_TYPES = %w[
  unstyled header-one header-two header-three unordered-list-item ordered-list-item blockquote atomic
].freeze

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
  validate_story_package(card, card_path)
  card["text"] = publication_text(card)
  image_type(card_image_path(card))
  [card_path, card]
rescue JSON::ParserError => error
  fail "Publication card #{card_path} is not valid JSON: #{error.message}"
end

def validate_story_package(card, card_path)
  return unless card["status"] == "draft" && card["series"].is_a?(String) && !card["series"].strip.empty?

  footer = card["footer"]
  hashtags = footer.is_a?(String) ? footer.scan(/#[A-Za-z0-9_]+/) : []
  series_key = card.fetch("series").gsub(/[^A-Za-z0-9]/, "").downcase
  hashtag_key = hashtags.one? ? hashtags.first.delete_prefix("#").delete("_").downcase : nil
  unless footer.is_a?(String) && !footer.strip.empty? && hashtag_key == series_key
    fail "Draft story card #{card_path} needs one separate hashtag footer identifying #{card.fetch("series")}."
  end
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

def publication_record_time(record)
  Time.iso8601(record.fetch("published_at"))
rescue ArgumentError, KeyError
  fail "Publication record has an invalid published_at timestamp: #{record.inspect}"
end

def quote_target_for(card)
  series = card["series"]
  return nil unless series.is_a?(String) && !series.strip.empty?

  part = card["part"]
  fail "Story card #{card.fetch("id")} needs a positive integer part." unless part.is_a?(Integer) && part.positive?
  return nil if part == 1

  previous = publication_records.select do |record|
    record["series"] == series && record["part"] == part - 1
  end.max_by { |record| publication_record_time(record) }
  fail "Story card #{card.fetch("id")} cannot quote #{series} part #{part - 1}: no recorded predecessor." unless previous

  quoted_post_id = previous["x_post_id"]
  unless quoted_post_id.is_a?(String) && !quoted_post_id.empty?
    fail "Story card #{card.fetch("id")} cannot quote #{series} part #{part - 1}: its recorded predecessor has no X post ID."
  end

  {
    "x_post_id" => quoted_post_id,
    "x_post_url" => previous["x_post_url"],
    "series" => series,
    "part" => part - 1
  }
end

def next_publication_cards
  cards = Dir.glob(File.join(PRIVATE_DRAFTS, "*.json")).sort.filter_map do |path|
    card = JSON.parse(File.read(path))
    next unless card["status"] == "draft"
    next unless card["series"].is_a?(String) && !card["series"].strip.empty?
    next unless card["part"].is_a?(Integer) && card["part"].positive?

    { "path" => path, "id" => card.fetch("id"), "series" => card.fetch("series"), "part" => card.fetch("part") }
  rescue JSON::ParserError => error
    fail "Publication card #{path} is not valid JSON: #{error.message}"
  end

  cards.group_by { |card| card.fetch("series") }.transform_values do |series_cards|
    series_cards.min_by { |card| card.fetch("part") }
  end
end

def matching_series_name(requested, available)
  normalized = requested.to_s.strip.downcase
  exact = available.find { |name| name.downcase == normalized }
  return exact if exact

  matches = available.select { |name| name.downcase.include?(normalized) }
  return matches.first if matches.length == 1

  if matches.length > 1
    fail "Series name is ambiguous: #{requested}. Matches: #{matches.sort.join(", ")}"
  end
  fail "No publishable next card for #{requested}. Available: #{available.sort.join(", ")}"
end

def cadence_snapshot(requested_series = nil, now: Time.now)
  candidates = next_publication_cards
  fail "No draft story cards are available." if candidates.empty?

  records = publication_records.select do |record|
    record["series"].is_a?(String) && !record["series"].strip.empty?
  end
  publications_by_series = records.group_by { |record| record.fetch("series") }
  latest = records.max_by { |record| publication_record_time(record) }
  due_at = latest ? publication_record_time(latest) + (CADENCE_INTERVAL_HOURS * 60 * 60) : now

  candidate = if requested_series
                series = matching_series_name(requested_series, candidates.keys)
                candidates.fetch(series)
              else
                started = candidates.values.select { |card| publications_by_series.key?(card.fetch("series")) }
                if started.empty?
                  candidates.values.min_by { |card| [card.fetch("series").downcase, card.fetch("part")] }
                else
                  started.min_by do |card|
                    series_records = publications_by_series.fetch(card.fetch("series"))
                    publication_record_time(series_records.max_by { |record| publication_record_time(record) })
                  end
                end
              end

  {
    "candidate" => candidate,
    "candidates" => candidates,
    "publications_by_series" => publications_by_series,
    "latest" => latest,
    "due_at" => due_at,
    "due" => now >= due_at,
    "now" => now
  }
end

def format_local_time(time)
  time.getlocal.iso8601
end

def format_wait(seconds)
  minutes = (seconds.abs / 60.0).ceil
  hours, remaining_minutes = minutes.divmod(60)
  return "#{remaining_minutes}m" if hours.zero?
  return "#{hours}h" if remaining_minutes.zero?

  "#{hours}h #{remaining_minutes}m"
end

def parse_cadence_options(argv, banner, allow_override: false)
  options = { override_cadence: false }
  parser = OptionParser.new do |opts|
    opts.banner = banner
    opts.on("--series NAME", "Choose a specific series") { |value| options[:series] = value }
    if allow_override
      opts.on("--override-cadence", "Publish before the #{CADENCE_INTERVAL_HOURS}-hour window after an explicit decision") do
        options[:override_cadence] = true
      end
    end
  end
  parser.parse!(argv)
  fail "Unexpected argument: #{argv.first}" unless argv.empty?
  options
end

def cadence(argv)
  options = parse_cadence_options(argv, "Usage: ruby _tools/x.rb cadence [--series NAME]")
  snapshot = cadence_snapshot(options[:series])
  latest = snapshot.fetch("latest")
  candidate = snapshot.fetch("candidate")

  puts "Manual cadence: one story installment every #{CADENCE_INTERVAL_HOURS} hours"
  if latest
    puts "Last published: #{format_local_time(publication_record_time(latest))} — #{latest.fetch("series")}#{latest["part"] ? " part #{latest["part"]}" : ""}"
  else
    puts "Last published: none"
  end
  if snapshot.fetch("due")
    puts "Status: due now (window opened #{format_wait(snapshot.fetch("now") - snapshot.fetch("due_at"))} ago)"
  else
    puts "Status: not due for #{format_wait(snapshot.fetch("due_at") - snapshot.fetch("now"))}"
  end
  puts "Next window: #{format_local_time(snapshot.fetch("due_at"))}"
  puts "Recommended: #{candidate.fetch("series")} — part #{candidate.fetch("part")} (#{candidate.fetch("id")})"
  puts "Card: #{candidate.fetch("path")}"
  puts "\nNext by series:"
  snapshot.fetch("candidates").keys.sort.each do |series|
    card = snapshot.fetch("candidates").fetch(series)
    series_records = snapshot.fetch("publications_by_series")[series]
    state = if series_records
              last = series_records.max_by { |record| publication_record_time(record) }
              "started; last published #{format_local_time(publication_record_time(last))}"
            else
              "not started"
            end
    puts "- #{series}: part #{card.fetch("part")} (#{state})"
  end
end

def preview_next(argv)
  options = parse_cadence_options(argv, "Usage: ruby _tools/x.rb preview-next [--series NAME]")
  snapshot = cadence_snapshot(options[:series])
  candidate = snapshot.fetch("candidate")
  timing = snapshot.fetch("due") ? "due now" : "next window #{format_local_time(snapshot.fetch("due_at"))}"
  puts "Cadence: #{timing}"
  puts "Selected: #{candidate.fetch("series")} — part #{candidate.fetch("part")}\n\n"
  preview(["--file", candidate.fetch("path")])
end

def post_next(argv)
  options = parse_cadence_options(
    argv,
    "Usage: ruby _tools/x.rb post-next [--series NAME] [--override-cadence]",
    allow_override: true
  )
  snapshot = cadence_snapshot(options[:series])
  candidate = snapshot.fetch("candidate")
  unless snapshot.fetch("due") || options.fetch(:override_cadence)
    fail "Cadence is not due until #{format_local_time(snapshot.fetch("due_at"))}. Use --override-cadence only after an explicit decision to publish early."
  end

  if options.fetch(:override_cadence) && !snapshot.fetch("due")
    puts "Cadence override: publishing before #{format_local_time(snapshot.fetch("due_at"))}."
  end
  puts "Selected: #{candidate.fetch("series")} — part #{candidate.fetch("part")} (#{candidate.fetch("id")})"
  post(["--file", candidate.fetch("path")])
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

def record_publication(id, text, image_path, card_path: nil, card: nil, quote_target: nil)
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
    "quote_tweet_id" => quote_target && quote_target.fetch("x_post_id"),
    "quote_tweet_url" => quote_target && quote_target["x_post_url"],
    "quote_series" => quote_target && quote_target.fetch("series"),
    "quote_part" => quote_target && quote_target.fetch("part"),
    "has_url" => text.match?(%r{https?://})
  }.compact
  append_publication(record)

  return url unless card

  card["status"] = "published"
  card["published_at"] = record.fetch("published_at")
  card["x_post_id"] = id
  card["x_post_url"] = url
  if quote_target
    card["quote_tweet_id"] = quote_target.fetch("x_post_id")
    card["quote_tweet_url"] = quote_target["x_post_url"]
  end
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

def article_source_path(path, label)
  expanded_path = File.expand_path(path)
  fail "#{label} not found: #{expanded_path}" unless File.file?(expanded_path)

  expanded_path
end

def article_block(text, type)
  { "text" => text, "type" => type }
end

def markdown_article_content_state(markdown, source_path)
  markdown = markdown.sub(/\A---\r?\n.*?\r?\n---\s*(?:\r?\n)?/m, "")
  blocks = []
  entities = []
  embedded_images = []
  paragraph = []
  flush_paragraph = lambda do
    next if paragraph.empty?

    text = paragraph.join("\n").strip
    blocks << article_block(text, "unstyled") unless text.empty?
    paragraph.clear
  end

  markdown.each_line do |line|
    line = line.chomp
    if line.strip.empty?
      flush_paragraph.call
      next
    end

    image_match = line.match(/\A!\[([^\]]*)\]\(([^)]+)\)\s*\z/)
    if image_match
      flush_paragraph.call
      caption = image_match[1]
      image_path = File.expand_path(image_match[2], File.dirname(source_path))
      image_type(image_path)
      entity_index = entities.length
      marker = "__LOCAL_ARTICLE_IMAGE_#{entity_index}__"
      entity_data = {
        "media_items" => [{ "media_category" => "tweet_image", "media_id" => marker }]
      }
      entity_data["caption"] = caption unless caption.empty?
      entities << {
        "key" => entity_index.to_s,
        "value" => { "type" => "image", "mutability" => "immutable", "data" => entity_data }
      }
      blocks << {
        "text" => " ",
        "type" => "atomic",
        "entity_ranges" => [{ "key" => entity_index, "offset" => 0, "length" => 1 }]
      }
      embedded_images << { "entity_index" => entity_index, "path" => image_path, "caption" => caption }
    elsif (match = line.match(/\A(\#{1,3})\s+(.+)\z/))
      flush_paragraph.call
      blocks << article_block(match[2], "header-#{%w[one two three][match[1].length - 1]}")
    elsif (match = line.match(/\A\s*[-*+]\s+(.+)\z/))
      flush_paragraph.call
      blocks << article_block(match[1], "unordered-list-item")
    elsif (match = line.match(/\A\s*\d+\.\s+(.+)\z/))
      flush_paragraph.call
      blocks << article_block(match[1], "ordered-list-item")
    elsif (match = line.match(/\A>\s?(.+)\z/))
      flush_paragraph.call
      blocks << article_block(match[1], "blockquote")
    else
      paragraph << line
    end
  end
  flush_paragraph.call
  fail "Markdown source has no publishable text." if blocks.empty?

  [{ "blocks" => blocks, "entities" => entities }, embedded_images]
end

def validate_article_content_state(content_state)
  unless content_state.is_a?(Hash) && content_state["blocks"].is_a?(Array) && content_state["entities"].is_a?(Array)
    fail "Article content state must be a JSON object with blocks and entities arrays."
  end
  fail "Article content state has no blocks." if content_state.fetch("blocks").empty?

  content_state.fetch("blocks").each_with_index do |block, index|
    unless block.is_a?(Hash) && block["text"].is_a?(String) && ARTICLE_BLOCK_TYPES.include?(block["type"])
      fail "Article content-state block #{index + 1} needs text and a supported DraftJS type."
    end
  end
end

def load_article_content_state(markdown_path: nil, content_state_path: nil)
  if markdown_path
    path = article_source_path(markdown_path, "Markdown source")
    content_state, embedded_images = markdown_article_content_state(File.read(path), path)
    source = { "format" => "markdown", "path" => path }
  else
    path = article_source_path(content_state_path, "Content-state JSON")
    content_state = JSON.parse(File.read(path))
    embedded_images = []
    source = { "format" => "content_state", "path" => path }
  end
  validate_article_content_state(content_state)
  [content_state, source, embedded_images]
rescue JSON::ParserError => error
  fail "Content-state JSON is not valid JSON: #{error.message}"
end

def upload_embedded_article_images(content_state, embedded_images, token)
  embedded_images.each do |image|
    media_id = upload_image(image.fetch("path"), token)
    entity = content_state.fetch("entities").fetch(image.fetch("entity_index"))
    entity.fetch("value").fetch("data").fetch("media_items").first["media_id"] = media_id
  end
end

def article(argv)
  options = { dry_run: false, draft_only: false }
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: ruby _tools/x.rb article --title TITLE (--markdown FILE.md | --content-state FILE.json) [--cover IMAGE] [--draft-only] [--dry-run]"
    opts.on("--title TITLE", "Article title") { |value| options[:title] = value }
    opts.on("--markdown FILE", "Markdown source; converts headings, lists, quotes, and paragraphs to DraftJS blocks") { |value| options[:markdown] = value }
    opts.on("--content-state FILE", "Complete DraftJS content-state JSON") { |value| options[:content_state] = value }
    opts.on("--cover FILE", "Optional JPG, PNG, GIF, or WebP cover image") { |value| options[:cover] = value }
    opts.on("--draft-only", "Create and retain an X Article draft without publishing it") { options[:draft_only] = true }
    opts.on("--dry-run", "Show the Article request without calling X") { options[:dry_run] = true }
  end
  parser.parse!(argv)
  fail "Unexpected argument: #{argv.first}" unless argv.empty?
  fail "--title is required." unless options[:title].is_a?(String) && !options[:title].strip.empty?
  fail "Provide exactly one of --markdown or --content-state." unless [options[:markdown], options[:content_state]].compact.one?

  content_state, source, embedded_images = load_article_content_state(markdown_path: options[:markdown], content_state_path: options[:content_state])
  cover_path = File.expand_path(options[:cover]) if options[:cover]
  image_type(cover_path) if cover_path

  if options[:dry_run]
    puts JSON.pretty_generate(
      "title" => options[:title],
      "content_state" => content_state,
      "source" => source,
      "cover_image" => cover_path,
      "embedded_images" => embedded_images,
      "action" => options[:draft_only] ? "create draft" : "create draft, then publish"
    )
    return
  end

  token = access_token
  upload_embedded_article_images(content_state, embedded_images, token)
  request_body = { "title" => options[:title], "content_state" => content_state }
  if cover_path
    request_body["cover_media"] = {
      "media_category" => "tweet_image",
      "media_id" => upload_image(cover_path, token)
    }
  end
  draft = x_request(:post, "/2/articles/draft", token: token, body: JSON.generate(request_body), content_type: "application/json")
  article_id = draft.dig("data", "id") or fail "X returned no Article ID."
  if options[:draft_only]
    puts "Article draft created: #{article_id}"
    return
  end

  published = x_request(:post, "/2/articles/#{article_id}/publish", token: token)
  post_id = published.dig("data", "post_id") or fail "X returned no announcement post ID for Article #{article_id}."
  post_url = "https://x.com/i/web/status/#{post_id}"
  append_publication(
    "published_at" => Time.now.utc.iso8601,
    "publication_type" => "article",
    "article_id" => article_id,
    "article_title" => options[:title],
    "article_source" => source,
    "article_content_state" => content_state,
    "x_post_id" => post_id,
    "x_post_url" => post_url,
    "text" => options[:title],
    "cover_image" => cover_path
  )
  puts "Article published and recorded: #{post_url}"
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
    quote_target = quote_target_for(card)
  else
    card_path = nil
    card = nil
    text = [options[:text], options[:link]].compact.join(" ").strip
    image_path = options[:image]
    fail "Provide --file, --text, --link, or --image." if text.empty? && !image_path
    image_type(image_path) if image_path
    quote_target = nil
  end

  if options[:dry_run]
    puts JSON.pretty_generate(
      "card_id" => card && card.fetch("id"),
      "text" => text,
      "image" => image_path,
      "quote_tweet_id" => quote_target && quote_target.fetch("x_post_id"),
      "quote_tweet_url" => quote_target && quote_target["x_post_url"]
    )
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
  body["quote_tweet_id"] = quote_target.fetch("x_post_id") if quote_target
  response = x_request(:post, "/2/tweets", token: token, body: JSON.generate(body), content_type: "application/json")
  id = response.dig("data", "id") or fail "X returned no post ID."
  url = record_publication(id, text, image_path, card_path: card_path, card: card, quote_target: quote_target)
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
  quote_target = quote_target_for(card)
  if quote_target
    puts "Quote post: #{quote_target.fetch("series")} part #{quote_target.fetch("part")} — #{quote_target["x_post_url"] || quote_target.fetch("x_post_id")}"
  else
    puts "Quote post: none (series opener)"
  end
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
    if record["publication_type"] == "article"
      puts "Article: #{record.fetch("article_title")} (#{record.fetch("article_id")})"
      puts "cover #{record["cover_image"]}" if record["cover_image"]
    else
      puts record.fetch("text")
    end
    puts "image #{record["image"]}" if record["image"]
    puts "quotes #{record["quote_tweet_url"] || record["quote_tweet_id"]}" if record["quote_tweet_id"]
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
      ruby _tools/x.rb article --title "Title" (--markdown FILE.md | --content-state FILE.json) [--cover IMAGE] [--draft-only] [--dry-run]
      ruby _tools/x.rb preview --file CARD.json
      ruby _tools/x.rb cadence [--series NAME]
      ruby _tools/x.rb preview-next [--series NAME]
      ruby _tools/x.rb post-next [--series NAME] [--override-cadence]
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
when "article" then article(ARGV)
when "preview" then preview(ARGV)
when "cadence" then cadence(ARGV)
when "preview-next" then preview_next(ARGV)
when "post-next" then post_next(ARGV)
when "history" then history(ARGV)
when "me" then me
when "posts" then posts(ARGV)
else usage
end
