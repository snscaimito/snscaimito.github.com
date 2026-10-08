# frozen_string_literal: true

require "minitest/autorun"
require "jekyll"
require "jekyll-redirect-from"
require "nokogiri"
require "tmpdir"

class TopicsTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)

  def setup
    @site = Jekyll::Site.new(Jekyll.configuration("source" => ROOT, "quiet" => true))
    @site.read
  end

  def render(document)
    Nokogiri::HTML(Jekyll::Renderer.new(@site, document).run)
  end

  def test_topics_preserve_translations_chapters_and_links_without_a_page_date
    topics = @site.collections.fetch("topics").docs
    assert_equal %w[de en es], topics.map { |doc| doc.data.fetch("lang") }.sort
    topics.each do |topic|
      html = render(topic)
      assert_equal 11, html.css(".topic > h2").size
      assert_equal 11, html.css(".topic-chapter").size
      assert_equal 11, html.css(".topic-chapter-x").size
      html.css(".topic-chapter > a:first-child").each do |link|
        assert html.at_css("[id='#{link['href'].delete_prefix('#')}']"), "Missing chapter target #{link['href']}"
      end
      assert_equal 2, html.css("a.post-language-switcher-button").size
      assert_empty html.css(".postfooter")
      front_matter = YAML.safe_load(File.read(topic.path).match(/\A---\s*\n(.*?)\n---/m)[1], permitted_classes: [Date, Time])
      refute front_matter.key?("date")
      refute_includes html.at_css(".topic").text, "25 Sep 2026"
      topic.data.values_at("translation_en_url", "translation_de_url", "translation_es_url").each do |url|
        assert topics.any? { |candidate| candidate.url == url }
      end
      assert_empty @site.posts.docs.select { |post| post.data["x_series"] == topic.data["x_series"] }
      save_preview(topic.url, html.to_html)
    end
  end

  def test_homepage_band_order_and_topic_card
    homepage = @site.pages.find { |page| page.name == "index.html" && page.dir == "/" }
    html = render(homepage)
    assert_equal %w[home-books-title home-topics-title home-latest-title],
      html.css(".home-band > .home-band-title").map { |heading| heading["id"] }
    assert_equal %w[home-books home-topics home-latest home-about home-explore],
      html.css("body > section").map { |section| section["class"].split.first }
    %w[home-books home-topics home-latest].each do |band|
      assert html.at_css(".#{band} > .home-card-list")
    end
    assert_equal 4, html.css(".home-books .home-card").size
    assert_equal 4, html.css(".home-latest .home-card").size
    assert_equal 1, html.css(".home-topics .home-card").size
    assert_equal "/topics/company-law-in-europe/", html.at_css(".home-topics .home-card-link")["href"]
    assert_includes html.at_css(".home-topics .home-card-meta").text, "11 installments"
    refute html.css(".home-latest .home-card").any? { |card| card.text.include?("Company Law in Europe") }
    save_preview("/", html.to_html)
  end

  def test_homepage_displays_multiple_topics_using_the_same_cards
    collection = @site.collections.fetch("topics")
    topic = Jekyll::Document.new(File.join(ROOT, "_topics", "another-topic.markdown"), site: @site, collection: collection)
    topic.data.merge!(collection.docs.find { |doc| doc.data["lang"] == "en" }.data)
    topic.data.merge!("title" => "Another topic", "order" => 2, "slug" => "another-topic")
    collection.docs << topic

    homepage = @site.pages.find { |page| page.name == "index.html" && page.dir == "/" }
    html = render(homepage)
    assert_equal ["Company Law in Europe", "Another topic"], html.css(".home-topics .home-card-title").map(&:text)
    assert_equal 2, html.css(".home-topics .home-card-image").size
    assert_empty html.css(".home-topic-link")
  end

  def test_old_language_urls_redirect_to_their_topic
    JekyllRedirectFrom::Generator.new.generate(@site)
    @site.collections.fetch("topics").docs.each do |topic|
      old_url = topic.data.fetch("redirect_from").first
      redirect = @site.pages.find { |page| page.url == old_url }
      refute_nil redirect
      assert_equal "#{@site.config.fetch('url')}#{topic.url}", redirect.data.fetch("redirect").fetch("to")
      save_preview(old_url, redirect.output)
    end
  end

  def save_preview(url, html)
    return unless ENV["TOPICS_PREVIEW_DIR"]

    destination = File.join(ENV.fetch("TOPICS_PREVIEW_DIR"), url.delete_prefix("/"))
    destination = File.join(destination, "index.html") if url.end_with?("/")
    FileUtils.mkdir_p(File.dirname(destination))
    File.write(destination, html)
  end
end
