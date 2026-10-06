#!/usr/bin/env ruby
# frozen_string_literal: true

require "date"
require "json"
require "pathname"
require "set"
require "yaml"

# Runs without building Jekyll. CI also checks the generated artifact before upload.
class PublicationCheck
  INTERNAL_PATHS = %w[_planning _tools AGENTS.md design.md Gemfile Gemfile.lock serve.sh elements.md].freeze

  def initialize(root, today: Date.today)
    @root = File.expand_path(root)
    @today = today
    @config = yaml(File.read(File.join(@root, "_config.yml")))
  end

  def errors(output = nil)
    problems = []
    %w[future show_drafts unpublished].each do |flag|
      problems << "#{flag} must remain false" if @config.fetch(flag, false) != false
    end
    INTERNAL_PATHS.each do |path|
      problems << "Exclude internal file or directory: #{path}" unless excluded?(path)
    end

    hidden_urls = Set.new
    private_images = Set.new
    public_images = Set.new
    public_sources = []
    Dir.glob(File.join(@root, "_posts", "**", "*")).each do |path|
      next unless File.file?(path)
      next unless %w[.markdown .md .html .textile].include?(File.extname(path))

      text = File.read(path)
      metadata = front_matter(text)
      next unless metadata

      relative = Pathname.new(path).relative_path_from(Pathname.new(@root)).to_s
      problems << "#{relative}: replace draft: true with published: false" if metadata["draft"] == true
      filename = File.basename(path)
      date = Date.parse((metadata["date"] || filename[0, 10]).to_s)
      if metadata["published"] == false || metadata["draft"] == true || date > @today
        slug = metadata["slug"] || filename.sub(/\A\d{4}-\d{2}-\d{2}-/, "").sub(/\.[^.]+\z/, "")
        url = (metadata["permalink"] || @config.fetch("permalink")).gsub(":year", date.strftime("%Y"))
          .gsub(":month", date.strftime("%m")).gsub(":day", date.strftime("%d"))
          .gsub(":title", slug).gsub(":slug", slug)
        hidden_urls << url
        private_images.merge(image_paths(text))
      else
        public_sources << [relative, text]
        public_images.merge(image_paths(text))
      end
    end

    # Site pages and the public X index may legitimately share a draft's illustration.
    Dir.glob(File.join(@root, "**", "*")).each do |path|
      next unless File.file?(path)

      relative = Pathname.new(path).relative_path_from(Pathname.new(@root)).to_s
      next if relative.start_with?("_posts/", "_site/") || excluded?(relative)
      next unless relative == "_data/x_publications.json" ||
        (!relative.start_with?("_") && %w[.html .markdown .md .xml].include?(File.extname(path)))

      text = File.read(path)
      next if front_matter(text)&.fetch("published", true) == false

      public_sources << [relative, text]
      public_images.merge(image_paths(text))
    end

    hidden_images = private_images - public_images
    public_images.each do |path|
      problems << "Published content references excluded illustration: #{path}" if excluded?(path.delete_prefix("/"))
    end
    hidden_images.each do |path|
      problems << "Exclude unpublished illustration: #{path}" unless excluded?(path.delete_prefix("/"))
    end
    public_sources.each do |path, text|
      hidden_urls.each do |url|
        problems << "#{path} links to unpublished post: #{url}" if text.include?(url)
      end
    end

    if output
      directory = File.expand_path(output, @root)
      return problems + ["Missing publication artifact: #{directory}"] unless File.directory?(directory)

      forbidden = hidden_urls.map { |url| "#{url.delete_prefix('/')}#{url.end_with?('/') ? 'index.html' : ''}" } +
        hidden_images.map { |path| path.delete_prefix("/") }
      Dir.glob(File.join(directory, "**", "*"), File::FNM_DOTMATCH).each do |path|
        next unless File.file?(path)

        relative = Pathname.new(path).relative_path_from(Pathname.new(directory)).to_s
        if forbidden.include?(relative) || excluded?(relative)
          problems << "Unfinished or internal file in publication artifact: #{relative}"
        end
        next unless %w[.html .xml .json].include?(File.extname(path))

        text = File.read(path)
        (hidden_urls.to_a + hidden_images.to_a).each do |url|
          problems << "#{relative} references unpublished content: #{url}" if text.include?(url)
        end
      end
    end
    problems.uniq
  end

  private

  def yaml(text)
    YAML.safe_load(text, permitted_classes: [Date, Time], aliases: true)
  end

  def front_matter(text)
    match = text.match(/\A---\s*\n(.*?)\n---\s*\n/m)
    match && (yaml(match[1]) || {})
  end

  def image_paths(text)
    text.scan(%r{/img/[^\s"'<>\[\](){}]+}).to_set
  end

  def excluded?(path)
    matches = lambda do |pattern|
      pattern = pattern.delete_suffix("/")
      path == pattern || path.start_with?("#{pattern}/") || File.fnmatch?(pattern, path, File::FNM_PATHNAME)
    end
    Array(@config["exclude"]).any?(&matches) && !Array(@config["include"]).any?(&matches)
  end
end

if $PROGRAM_NAME == __FILE__
  problems = PublicationCheck.new(File.expand_path("..", __dir__)).errors(ARGV.first)
  if problems.empty?
    puts "Publication safety check passed#{ARGV.first ? ' for the generated artifact' : ''}."
  else
    warn problems.join("\n")
    exit 1
  end
end
