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
PUBLICATION_QUEUE = File.join(TOOLS, "publication-queue")
X_PUBLICATIONS_DATA_FILE = File.join(REPOSITORY, "_data", "x_publications.json")
# API experiments remain in the ledger, but do not belong in the public index.
PUBLICATION_PAGE_EXCLUDED_IDS = %w[2091469852938477835 2091470650380603548].freeze
SCOPES = %w[tweet.read tweet.write users.read media.write offline.access].freeze
IMAGE_TYPES = {
  ".jpg" => "image/jpeg", ".jpeg" => "image/jpeg", ".png" => "image/png",
  ".gif" => "image/gif", ".webp" => "image/webp"
}.freeze
MAX_POST_IMAGES = 4
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

def x_post_url(id, account: expected_account)
  handle = account.to_s.delete_prefix("@").strip
  fail "X account is required to build a post URL." if handle.empty?
  fail "X post ID is required to build a post URL." unless id.is_a?(String) && !id.empty?

  "https://x.com/#{handle}/status/#{id}"
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

def validate_image_paths(paths)
  fail "A post may include at most #{MAX_POST_IMAGES} images." unless (1..MAX_POST_IMAGES).cover?(paths.length)

  types = paths.map { |path| image_type(path) }
  fail "An animated GIF must be the only image attached to a post." if paths.length > 1 && types.include?("image/gif")
  paths
end

def load_publication_card(path)
  card_path = File.expand_path(path)
  fail "Publication card not found: #{card_path}" unless File.file?(card_path)

  card = JSON.parse(File.read(card_path))
  %w[id status].each do |field|
    fail "Publication card #{card_path} is missing #{field}." unless card[field].is_a?(String) && !card[field].strip.empty?
  end
  validate_story_package(card, card_path)
  validate_final_source_section(card)
  series_summary_text(card) if card["publication_type"] == "series_summary"
  validate_series_end(card) if card["series_end"] == true
  card["text"] = publication_text(card)
  image_paths = card_image_paths(card)
  validate_image_paths(image_paths) if image_paths.any?
  [card_path, card]
rescue JSON::ParserError => error
  fail "Publication card #{card_path} is not valid JSON: #{error.message}"
end

def validate_story_package(card, card_path)
  return unless card["status"] == "queued" && card["series"].is_a?(String) && !card["series"].strip.empty?

  footer = card["footer"]
  expected_footer = "#{card.fetch("series")} — a serialized story."
  unless footer == expected_footer && !footer.include?("#")
    fail "Queued story card #{card_path} needs the plain-language footer #{expected_footer.inspect} and no hashtags."
  end
end

def publication_text(card)
  return series_summary_text(card) if card["publication_type"] == "series_summary"

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
    strip_site_only_markup(body)
  end.join("\n\n")
end

def strip_site_only_markup(body)
  body
    .gsub(/<details\b[^>]*\bclass=["'][^"']*\bfuture-vision\b[^"']*["'][^>]*>.*?<\/details>\n*/m, "")
    .gsub(/<figure.*?<\/figure>\n*/m, "")
    .strip
end

def card_image_paths(card)
  fail "Publication card #{card.fetch("id")} cannot define both image and images." if card.key?("image") && card.key?("images")
  return [] unless card.key?("image") || card.key?("images")

  values = card.key?("images") ? card["images"] : [card["image"]]
  unless values.is_a?(Array) && values.all? { |value| value.is_a?(String) && !value.strip.empty? }
    fail "Publication card #{card.fetch("id")} has an invalid image or images array."
  end
  values.map { |value| File.expand_path(value, REPOSITORY) }
end

def card_image_path(card)
  card_image_paths(card).first
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

def publication_page_excerpt(record, max_length: 320)
  source = record["text"] || record["article_title"] || ""
  excerpt = source.gsub(/\s+/, " ").strip
  excerpt.length > max_length ? "#{excerpt[0, max_length].rstrip}…" : excerpt
end

def publication_page_image_urls(record, repository: REPOSITORY, mirror_directory: File.join(REPOSITORY, "img", "x-publications"))
  image_paths = record["images"] || Array(record["image"] || record["cover_image"])
  image_paths.each_with_index.filter_map do |path, index|
    next unless path.is_a?(String) && !path.empty?

    source = File.expand_path(path, repository)
    next unless File.file?(source)

    public_images = File.join(repository, "img")
    if source.start_with?("#{public_images}/")
      "/#{source.delete_prefix("#{repository}/")}"
    else
      FileUtils.mkdir_p(mirror_directory)
      extension = File.extname(source).downcase
      destination = File.join(mirror_directory, "#{record.fetch("x_post_id")}-#{index + 1}#{extension}")
      FileUtils.cp(source, destination) unless File.file?(destination) && FileUtils.compare_file(source, destination)
      "/img/x-publications/#{File.basename(destination)}"
    end
  end
end

def publication_page_data(records = publication_records, account: expected_account)
  records_by_id = {}
  records.each do |record|
    next if record["publication_type"] == "series_root_reply"

    post_id = record["x_post_id"]
    next unless post_id.is_a?(String) && !post_id.empty?
    next if PUBLICATION_PAGE_EXCLUDED_IDS.include?(post_id)

    records_by_id[post_id] = record
  end

  posts = records_by_id.values.sort_by { |record| [publication_record_time(record), record.fetch("x_post_id")] }
  grouped = posts.group_by do |record|
    series = record["series"]
    series.is_a?(String) && !series.strip.empty? ? series : "Standalone posts"
  end
  groups = grouped.keys.sort_by { |name| name == "Standalone posts" ? [1, name] : [0, name.downcase] }.map do |name|
    {
      "name" => name,
      "posts" => grouped.fetch(name).map do |record|
        {
          "id" => record.fetch("x_post_id"),
          "excerpt" => publication_page_excerpt(record),
          "url" => x_post_url(record.fetch("x_post_id"), account: account),
          "published_at" => record.fetch("published_at"),
          "kind" => record["publication_type"] || "post",
          "images" => publication_page_image_urls(record)
        }
      end
    }
  end

  {
    "updated_at" => posts.last && posts.last.fetch("published_at"),
    "groups" => groups
  }
end

def write_publication_page_data(records: publication_records, path: X_PUBLICATIONS_DATA_FILE, account: expected_account)
  FileUtils.mkdir_p(File.dirname(path))
  temporary_path = "#{path}.#{Process.pid}.tmp"
  File.write(temporary_path, JSON.pretty_generate(publication_page_data(records, account: account)) + "\n")
  File.rename(temporary_path, path)
ensure
  File.delete(temporary_path) if temporary_path && File.exist?(temporary_path)
end

def quote_target_for(card, records: publication_records, account: expected_account)
  series = card["series"]
  return nil unless series.is_a?(String) && !series.strip.empty?

  if records.any? { |record| record["series"] == series && record["publication_type"] == "series_summary" }
    fail "Story series #{series} is already closed by its summary post."
  end

  part = card["part"]
  fail "Story card #{card.fetch("id")} needs a positive integer part." unless part.is_a?(Integer) && part.positive?
  return nil if part == 1

  opener = records.select do |record|
    record["series"] == series && record["part"] == 1
  end.max_by { |record| publication_record_time(record) }
  fail "Story card #{card.fetch("id")} cannot quote #{series} part 1: no recorded series opener." unless opener

  quoted_post_id = opener["x_post_id"]
  unless quoted_post_id.is_a?(String) && !quoted_post_id.empty?
    fail "Story card #{card.fetch("id")} cannot quote #{series} part 1: its recorded series opener has no X post ID."
  end

  {
    "x_post_id" => quoted_post_id,
    "x_post_url" => x_post_url(quoted_post_id, account: account),
    "series" => series,
    "part" => 1
  }
end

def reply_target_for(card, records: publication_records, account: expected_account)
  reply_to_card_id = card["reply_to_card_id"]
  return nil unless reply_to_card_id.is_a?(String) && !reply_to_card_id.strip.empty?

  target = records.select do |record|
    record["card_id"] == reply_to_card_id
  end.max_by { |record| publication_record_time(record) }
  fail "Publication card #{card.fetch("id")} cannot reply to #{reply_to_card_id}: no recorded post for that card." unless target

  target_post_id = target["x_post_id"]
  unless target_post_id.is_a?(String) && !target_post_id.empty?
    fail "Publication card #{card.fetch("id")} cannot reply to #{reply_to_card_id}: its publication record has no X post ID."
  end

  {
    "x_post_id" => target_post_id,
    "x_post_url" => x_post_url(target_post_id, account: account),
    "card_id" => reply_to_card_id
  }
end

def reply_body(text, target)
  {
    "text" => text,
    "reply" => { "in_reply_to_tweet_id" => target.fetch("x_post_id") }
  }
end

def series_root_reply_text(card)
  part = card["part"]
  fail "Story card #{card.fetch("id")} needs a later installment for a series-root reply." unless part.is_a?(Integer) && part > 1

  text = "Part #{part}"
  fail "Series-root reply text must not contain a URL." if text.match?(%r{https?://})
  text
end

def series_root_reply_body(card, root_target, installment_id)
  fail "Series-root reply needs the part 1 target." unless root_target && root_target["part"] == 1
  fail "Series-root reply needs the new installment post ID." unless installment_id.is_a?(String) && !installment_id.empty?

  {
    "text" => series_root_reply_text(card),
    "reply" => { "in_reply_to_tweet_id" => root_target.fetch("x_post_id") },
    "quote_tweet_id" => installment_id
  }
end

def series_summary_text(card)
  return nil unless card["publication_type"] == "series_summary"

  unless card["series"].is_a?(String) && !card["series"].strip.empty? && card["part"].is_a?(Integer) && card["part"].positive?
    fail "Series summary card #{card.fetch("id")} needs a series and positive part number."
  end
  summary = card["text"]
  url = card["article_url"]
  fail "Series summary card #{card.fetch("id")} needs text." unless summary.is_a?(String) && !summary.strip.empty?
  fail "Series summary card #{card.fetch("id")} needs an article URL." unless url.is_a?(String)
  uri = URI.parse(url)
  unless uri.scheme == "https" && uri.host == "www.stephan-schwab.com" && uri.path.end_with?(".html") && !uri.query && !uri.fragment
    fail "Series summary card #{card.fetch("id")} needs a full article URL on www.stephan-schwab.com."
  end
  return summary if card["status"] == "published" && summary.include?("Read the full story: #{url}")

  fail "Series summary card #{card.fetch("id")} must keep the article URL outside its text." if summary.match?(%r{https?://})

  "#{summary.strip}\n\nRead the full story: #{url}\n\n#{card.fetch("footer")}"
rescue URI::InvalidURIError
  fail "Series summary card #{card.fetch("id")} has an invalid article URL."
end

def series_summary_card_for(card, queue: PUBLICATION_QUEUE)
  summary_id = card["series_summary_card_id"]
  fail "Final story card #{card.fetch("id")} needs a queued summary card ID." unless summary_id.is_a?(String) && !summary_id.strip.empty?

  path = File.join(queue, "#{summary_id}.json")
  fail "Final story card #{card.fetch("id")} has no summary card at #{path}." unless File.file?(path)

  summary = JSON.parse(File.read(path))
  unless summary["id"] == summary_id && summary["publication_type"] == "series_summary" &&
         summary["series"] == card["series"] && summary["part"] == card["part"] + 1 &&
         %w[queued published].include?(summary["status"])
    fail "Final story card #{card.fetch("id")} has an invalid summary card."
  end
  series_summary_text(summary)
  [path, summary]
end

def validate_final_source_section(card)
  return unless card["status"] == "queued" && card["series"].is_a?(String)

  source = card["source"]
  return unless source.is_a?(Hash) && source["file"].is_a?(String) && source["file"].start_with?("_posts/")

  path = File.expand_path(source.fetch("file"), REPOSITORY)
  return unless path.start_with?("#{REPOSITORY}/") && File.file?(path)

  sections = source["sections"] || [source["section"]]
  return unless sections.is_a?(Array)

  last_section = File.read(path).split(/^## /).length - 1
  if sections.include?(last_section) && card["series_end"] != true
    fail "Final story card #{card.fetch("id")} needs series_end and a queued summary card."
  end
end

def validate_series_end(card, records: publication_records, queue: PUBLICATION_QUEUE)
  return unless card["series_end"] == true

  later_record = records.any? do |record|
    record["series"] == card.fetch("series") && record["publication_type"] != "series_summary" &&
      record["part"].is_a?(Integer) && record["part"] > card.fetch("part")
  end
  later_card = Dir.glob(File.join(queue, "*.json")).any? do |path|
    candidate = JSON.parse(File.read(path))
    candidate["series"] == card.fetch("series") && candidate["publication_type"] != "series_summary" && candidate["part"].is_a?(Integer) &&
      candidate["part"] > card.fetch("part") && %w[queued published].include?(candidate["status"])
  end
  fail "Story card #{card.fetch("id")} is not the last part of its series." if later_record || later_card
  series_summary_card_for(card, queue: queue)
end

def series_summary_body(card, root_id)
  fail "Series summary needs the series opener post ID." unless root_id.is_a?(String) && !root_id.empty?

  {
    "text" => series_summary_text(card) || fail("Story card #{card.fetch("id")} is not a series summary."),
    "quote_tweet_id" => root_id
  }
end

def validate_series_summary_predecessor(card, records: publication_records, queue: PUBLICATION_QUEUE)
  return unless card["publication_type"] == "series_summary"

  final = Dir.glob(File.join(queue, "*.json")).filter_map do |path|
    candidate = JSON.parse(File.read(path))
    candidate if candidate["series_summary_card_id"] == card.fetch("id") && candidate["series_end"] == true
  end
  unless final.one? && final.first["part"] == card.fetch("part") - 1 &&
         (final.first["part"] == 1 || final.first["series_root_reply_status"] == "published") &&
         records.any? { |record| record["card_id"] == final.first["id"] && record["part"] == final.first["part"] }
    fail "Series summary #{card.fetch("id")} cannot publish before its final chapter."
  end
end

def next_publication_cards
  cards = Dir.glob(File.join(PUBLICATION_QUEUE, "*.json")).sort.filter_map do |path|
    card = JSON.parse(File.read(path))
    next unless card["status"] == "queued"
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

def cadence_snapshot(requested_series = nil)
  candidates = next_publication_cards
  fail "No queued story cards are available." if candidates.empty?

  records = publication_records.select do |record|
    record["series"].is_a?(String) && !record["series"].strip.empty?
  end
  publications_by_series = records.group_by { |record| record.fetch("series") }
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
    "publications_by_series" => publications_by_series
  }
end

def format_local_time(time)
  time.getlocal.iso8601
end

def parse_cadence_options(argv, banner)
  options = {}
  parser = OptionParser.new do |opts|
    opts.banner = banner
    opts.on("--series NAME", "Choose a specific series") { |value| options[:series] = value }
  end
  parser.parse!(argv)
  fail "Unexpected argument: #{argv.first}" unless argv.empty?
  options
end

def cadence(argv)
  options = parse_cadence_options(argv, "Usage: ruby _tools/x.rb cadence [--series NAME]")
  snapshot = cadence_snapshot(options[:series])
  records = publication_records.select do |record|
    record["series"].is_a?(String) && !record["series"].strip.empty?
  end
  latest = records.max_by { |record| publication_record_time(record) }
  candidate = snapshot.fetch("candidate")

  puts "Manual recommendation: next installment from the longest-waiting started series"
  if latest
    puts "Most recent publication: #{format_local_time(publication_record_time(latest))} — #{latest.fetch("series")}#{latest["part"] ? " part #{latest["part"]}" : ""}"
  else
    puts "Most recent publication: none"
  end
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
  puts "Selected: #{candidate.fetch("series")} — part #{candidate.fetch("part")}\n\n"
  preview(["--file", candidate.fetch("path")])
end

def post_next(argv)
  options = parse_cadence_options(
    argv,
    "Usage: ruby _tools/x.rb post-next [--series NAME]"
  )
  snapshot = cadence_snapshot(options[:series])
  candidate = snapshot.fetch("candidate")
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
  write_publication_page_data
end

def save_publication_card(path, card)
  temporary_path = "#{path}.#{Process.pid}.tmp"
  File.write(temporary_path, JSON.pretty_generate(card) + "\n", mode: "w", perm: 0o600)
  File.chmod(0o600, temporary_path)
  File.rename(temporary_path, path)
ensure
  File.delete(temporary_path) if temporary_path && File.exist?(temporary_path)
end

def record_publication(id, text, image_paths, card_path: nil, card: nil, quote_target: nil, reply_target: nil)
  url = x_post_url(id)
  image_paths = Array(image_paths)
  record = {
    "published_at" => Time.now.utc.iso8601,
    "x_post_id" => id,
    "x_post_url" => url,
    "card_id" => card && card.fetch("id"),
    "publication_type" => card && card["publication_type"],
    "series" => card && card["series"],
    "part" => card && card["part"],
    "card_file" => card_path,
    "text" => text,
    "image" => image_paths.first,
    "images" => image_paths,
    "quote_tweet_id" => quote_target && quote_target.fetch("x_post_id"),
    "quote_tweet_url" => quote_target && quote_target["x_post_url"],
    "quote_series" => quote_target && quote_target.fetch("series"),
    "quote_part" => quote_target && quote_target.fetch("part"),
    "reply_to_tweet_id" => reply_target && reply_target.fetch("x_post_id"),
    "reply_to_tweet_url" => reply_target && reply_target["x_post_url"],
    "reply_to_card_id" => reply_target && reply_target.fetch("card_id"),
    "series_root_reply_status" => quote_target && card["publication_type"] != "series_summary" ? "pending" : nil,
    "article_url" => card && card["article_url"],
    "has_url" => text.match?(%r{https?://})
  }.compact
  append_publication(record)

  return url unless card

  card["status"] = "published"
  card["published_at"] = record.fetch("published_at")
  card["x_post_id"] = id
  card["x_post_url"] = url
  if quote_target && card["publication_type"] != "series_summary"
    card["quote_tweet_id"] = quote_target.fetch("x_post_id")
    card["quote_tweet_url"] = quote_target["x_post_url"]
    card["series_root_post_id"] = quote_target.fetch("x_post_id")
    card["series_root_post_url"] = quote_target["x_post_url"]
    card["series_root_reply_status"] = "pending"
  end
  if reply_target
    card["reply_to_tweet_id"] = reply_target.fetch("x_post_id")
    card["reply_to_tweet_url"] = reply_target["x_post_url"]
  end
  save_publication_card(card_path, card)
  url
end

def publish_series_root_reply(card_path, card, root_target, installment_id, token)
  installment_url = x_post_url(installment_id)
  body = series_root_reply_body(card, root_target, installment_id)
  response = x_request(:post, "/2/tweets", token: token, body: JSON.generate(body), content_type: "application/json")
  reply_id = response.dig("data", "id") or fail "X returned no series-root reply post ID."
  reply_url = x_post_url(reply_id)
  published_at = Time.now.utc.iso8601

  append_publication(
    "published_at" => published_at,
    "publication_type" => "series_root_reply",
    "x_post_id" => reply_id,
    "x_post_url" => reply_url,
    "source_card_id" => card.fetch("id"),
    "series" => card.fetch("series"),
    "linked_part" => card.fetch("part"),
    "text" => body.fetch("text"),
    "reply_to_tweet_id" => root_target.fetch("x_post_id"),
    "reply_to_tweet_url" => root_target["x_post_url"],
    "quote_tweet_id" => installment_id,
    "quote_tweet_url" => installment_url,
    "has_url" => false
  )

  card["series_root_reply_status"] = "published"
  card["series_root_reply_published_at"] = published_at
  card["series_root_reply_post_id"] = reply_id
  card["series_root_reply_post_url"] = reply_url
  card["series_root_reply_text"] = body.fetch("text")
  save_publication_card(card_path, card)
  reply_url
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
  post_url = x_post_url(post_id)
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
  options = { dry_run: false, images: [] }
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: ruby _tools/x.rb post (--file CARD.json | --text TEXT [--link URL] [--image FILE ...]) [--dry-run]"
    opts.on("--file FILE", "Prepared local publication-card JSON file") { |value| options[:file] = value }
    opts.on("--text TEXT", "Post text") { |value| options[:text] = value }
    opts.on("--link URL", "Optional link, appended to the text") { |value| options[:link] = value }
    opts.on("--image FILE", "JPG, PNG, GIF, or WebP image; repeat for up to four photos") { |value| options[:images] << value }
    opts.on("--dry-run", "Show the content without calling X") { options[:dry_run] = true }
  end
  parser.parse!(argv)
  fail "Unexpected argument: #{argv.first}" unless argv.empty?

  if options[:file]
    fail "--file cannot be combined with --text, --link, or --image." if options[:text] || options[:link] || options[:images].any?
    card_path, card = load_publication_card(options[:file])
    text = card.fetch("text")
    image_paths = card_image_paths(card)
    quote_target = quote_target_for(card)
    reply_target = reply_target_for(card)
    fail "Publication card #{card.fetch("id")} cannot both quote and reply." if quote_target && reply_target
  else
    card_path = nil
    card = nil
    text = [options[:text], options[:link]].compact.join(" ").strip
    image_paths = options[:images]
    fail "Provide --file, --text, --link, or --image." if text.empty? && image_paths.empty?
    validate_image_paths(image_paths) if image_paths.any?
    quote_target = nil
    reply_target = nil
  end

  if options[:dry_run]
    installment_id = card && card["x_post_id"] || "<new installment post ID>"
    root_reply = quote_target && card["publication_type"] != "series_summary" ? series_root_reply_body(card, quote_target, installment_id) : nil
    root_id = quote_target && quote_target.fetch("x_post_id") || installment_id
    summary_card = card && card["series_end"] == true ? series_summary_card_for(card).last : nil
    summary_post = summary_card && series_summary_body(summary_card, root_id)
    puts JSON.pretty_generate(
      "card_id" => card && card.fetch("id"),
      "text" => text,
      "images" => image_paths,
      "quote_tweet_id" => quote_target && quote_target.fetch("x_post_id"),
      "quote_tweet_url" => quote_target && quote_target["x_post_url"],
      "reply_to_tweet_id" => reply_target && reply_target.fetch("x_post_id"),
      "reply_to_tweet_url" => reply_target && reply_target["x_post_url"],
      "reply_to_card_id" => reply_target && reply_target.fetch("card_id"),
      "series_root_reply" => root_reply && {
        "text" => root_reply.fetch("text"),
        "reply_to_tweet_id" => root_reply.dig("reply", "in_reply_to_tweet_id"),
        "quote_tweet_id" => root_reply.fetch("quote_tweet_id"),
        "contains_url" => root_reply.fetch("text").match?(%r{https?://})
      },
      "series_summary_post" => summary_post && {
        "text" => summary_post.fetch("text"),
        "quote_tweet_id" => summary_post.fetch("quote_tweet_id")
      }
    )
    return
  end

  if card
    if card.fetch("status") == "published" && card["series_root_reply_status"] == "pending"
      installment_id = card["x_post_id"]
      fail "Published card #{card.fetch("id")} has no installment post ID." unless installment_id.is_a?(String) && !installment_id.empty?

      token = access_token
      reply_url = publish_series_root_reply(card_path, card, quote_target, installment_id, token)
      puts "Series-root reply published and recorded: #{reply_url}"
      return
    end
    fail "Publication card #{card_path} is #{card.fetch("status")}, not queued." unless card.fetch("status") == "queued"
    fail "Publication card #{card.fetch("id")} is already recorded as published." if publication_recorded_for_card?(card.fetch("id"))
    validate_series_summary_predecessor(card)
  end

  token = access_token
  body = reply_target ? reply_body(text, reply_target) : {}
  body["text"] = text unless text.empty? || body.key?("text")
  body["media"] = { "media_ids" => image_paths.map { |path| upload_image(path, token) } } if image_paths.any?
  body["quote_tweet_id"] = quote_target.fetch("x_post_id") if quote_target
  response = x_request(:post, "/2/tweets", token: token, body: JSON.generate(body), content_type: "application/json")
  id = response.dig("data", "id") or fail "X returned no post ID."
  url = record_publication(
    id, text, image_paths, card_path: card_path, card: card,
    quote_target: quote_target, reply_target: reply_target
  )
  puts "Published and recorded: #{url}"
  if card && quote_target && card["publication_type"] != "series_summary"
    reply_url = publish_series_root_reply(card_path, card, quote_target, id, token)
    puts "Series-root reply published and recorded: #{reply_url}"
  end
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
  image_paths = card_image_paths(card)
  puts "Images (#{image_paths.length}):"
  image_paths.each { |path| puts "- #{path}" }
  quote_target = quote_target_for(card)
  reply_target = reply_target_for(card)
  fail "Publication card #{card.fetch("id")} cannot both quote and reply." if quote_target && reply_target
  if quote_target
    puts "Quote series opener: #{quote_target.fetch("series")} part 1 — #{quote_target["x_post_url"] || quote_target.fetch("x_post_id")}"
    if card["publication_type"] == "series_summary"
      puts "Series ending: summary quotes part 1 and links to the full article"
    else
      puts "Series-root reply: #{series_root_reply_text(card)}; replies to part 1 and natively quotes this installment (no URL text)"
    end
  elsif card["series"].is_a?(String) && !card["series"].strip.empty?
    puts "Quote post: none (series opener)"
  else
    puts "Quote post: none"
  end
  if reply_target
    puts "Reply to: #{reply_target["x_post_url"] || reply_target.fetch("x_post_id")} (card #{reply_target.fetch("card_id")})"
  else
    puts "Reply: none"
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
             elsif record["source_card_id"]
               "#{record.fetch("source_card_id")} navigation"
             elsif record["historical_import"]
               "#{record.fetch("series")} (historical)"
             else
               "manual"
             end
    puts "#{record.fetch("published_at")}  #{record.fetch("x_post_url")}  #{source}"
    if record["publication_type"] == "article"
      puts "Article: #{record.fetch("article_title")} (#{record.fetch("article_id")})"
      puts "cover #{record["cover_image"]}" if record["cover_image"]
    elsif record["publication_type"] == "series_root_reply"
      puts "#{record.fetch("series")} root reply for part #{record.fetch("linked_part")}: #{record.fetch("text")}"
    else
      puts record.fetch("text")
    end
    images = record["images"] || Array(record["image"])
    images.each { |path| puts "image #{path}" }
    puts "quotes #{record["quote_tweet_url"] || record["quote_tweet_id"]}" if record["quote_tweet_id"]
    puts "replies to #{record["reply_to_tweet_url"] || record["reply_to_tweet_id"]}" if record["reply_to_tweet_id"]
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
      ruby _tools/x.rb post (--file CARD.json | --text "Text" [--link URL] [--image FILE ...]) [--dry-run]
      ruby _tools/x.rb article --title "Title" (--markdown FILE.md | --content-state FILE.json) [--cover IMAGE] [--draft-only] [--dry-run]
      ruby _tools/x.rb preview --file CARD.json
      ruby _tools/x.rb cadence [--series NAME]
      ruby _tools/x.rb preview-next [--series NAME]
      ruby _tools/x.rb post-next [--series NAME]
      ruby _tools/x.rb history [--limit COUNT]
      ruby _tools/x.rb me
      ruby _tools/x.rb posts [--limit COUNT]
  TEXT
  exit 1
end

if __FILE__ == $PROGRAM_NAME
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
end
