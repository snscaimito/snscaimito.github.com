# frozen_string_literal: true

require "minitest/autorun"
require "jekyll"
require "jekyll-redirect-from"
require "nokogiri"
require "tmpdir"

class TopicsTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)
  TOPICS = {
    "Company Law in Europe" => { "languages" => %w[de en es], "chapters" => 12, "summary_paragraphs" => 3 },
    "Bread and Games" => { "languages" => %w[de en es], "chapters" => 9, "summary_paragraphs" => 4 },
    "The Little Oracle" => { "languages" => %w[en], "chapters" => 5, "summary_paragraphs" => 3 }
  }.freeze
  HOME_TOPIC_URLS = %w[
    /topics/who-can-afford-to-take-a-risk/
    /topics/bread-and-games/
    /topics/the-little-oracle/
  ].freeze

  def setup
    @site = Jekyll::Site.new(Jekyll.configuration("source" => ROOT, "quiet" => true))
    @site.read
  end

  def render(document)
    Nokogiri::HTML(Jekyll::Renderer.new(@site, document).run)
  end

  def test_topics_preserve_translations_chapters_and_links_without_a_page_date
    topics = @site.collections.fetch("topics").docs
    assert_equal TOPICS.keys.sort, topics.map { |doc| doc.data.fetch("x_series") }.uniq.sort
    TOPICS.each do |series, expected|
      assert_equal expected.fetch("languages"), topics.select { |doc| doc.data["x_series"] == series }.map { |doc| doc.data.fetch("lang") }.sort
    end
    topics.each do |topic|
      expected = TOPICS.fetch(topic.data.fetch("x_series"))
      html = render(topic)
      assert_equal expected.fetch("chapters"), html.css(".topic > h2").size
      assert_empty html.css(".topic-contents")
      assert_equal expected.fetch("summary_paragraphs"), html.css(".topic-summary > p").size
      assert_operator html.at_css(".topic-summary").line, :<, html.at_css(".topic > h2").line
      if topic.data["x_series"] == "Company Law in Europe"
        chapter_prefix = { "en" => "chapter", "de" => "kapitel", "es" => "capítulo" }.fetch(topic.data.fetch("lang"))
        assert_equal topic.data.fetch("x_chapters").reverse.map { |chapter| "#{chapter_prefix}-#{chapter.fetch('part')}" },
          html.css(".topic > h2").map { |heading| heading["id"] }
      end
      html.css(".topic > h2").each do |heading|
        refute_match(/\A(?:Chapter|Kapitel|Capítulo) \d+\z/, heading.text)
      end
      references = html.css(".topic-x-reference > a")
      publications = topic.data.fetch("x_chapters").reverse
      assert_equal publications.map { |chapter| "https://x.com/snscaimito/status/#{chapter.fetch('x_post_id')}" },
        references.map { |link| link["href"] }
      html.css(".topic > h2").zip(publications).each do |heading, publication|
        following = heading.xpath("following-sibling::*")
        reference_index = following.index { |element| element["class"] == "topic-x-reference" }
        next_heading_index = following.index { |element| element.name == "h2" }
        refute_nil reference_index
        assert_equal 0, reference_index
        assert_operator reference_index, :<, next_heading_index if next_heading_index
        link = heading.next_element.at_css("a")
        assert link.at_css('svg[aria-hidden="true"] path')
        assert_includes link["aria-label"], "X"
        assert_equal publication.fetch("published_at"), link.at_css("time")["datetime"]
        assert_equal Time.iso8601(publication.fetch("published_at")).strftime("%d %b %Y"), link.at_css("time").text
      end
      assert_empty html.css(".twitter-tweet, .post-x-inset")
      assert_equal expected.fetch("languages").size - 1, html.css("a.post-language-switcher-button").size
      assert_empty html.css(".postfooter")
      assert_equal publications.size, html.css("time").size
      front_matter = YAML.safe_load(File.read(topic.path).match(/\A---\s*\n(.*?)\n---/m)[1], permitted_classes: [Date, Time])
      refute front_matter.key?("date")
      topic.data.values_at("translation_en_url", "translation_de_url", "translation_es_url").compact.each do |url|
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
    assert_equal 3, html.css(".home-topics .home-card").size
    assert_equal HOME_TOPIC_URLS, html.css(".home-topics .home-card-link").map { |link| link["href"] }
    assert_equal "Who Can Afford to Take a Risk?", html.at_css(".home-topics .home-card-title").text
    assert_equal ["12 installments", "9 installments", "5 installments"], html.css(".home-topics .home-card-meta").map { |meta| meta.text.strip }
    assert_equal 3, html.css(".home-topics .home-card-image").size
    assert_empty html.css(".home-topics time")
    assert_empty HOME_TOPIC_URLS & html.css(".home-latest .home-card-link").map { |link| link["href"] }
    save_preview("/", html.to_html)
  end

  def test_homepage_displays_multiple_topics_using_the_same_cards
    collection = @site.collections.fetch("topics")
    topic = Jekyll::Document.new(File.join(ROOT, "_topics", "another-topic.markdown"), site: @site, collection: collection)
    topic.data.merge!(collection.docs.find { |doc| doc.data["lang"] == "en" }.data)
    topic.data.merge!("title" => "Another topic", "order" => 4, "slug" => "another-topic")
    collection.docs << topic

    homepage = @site.pages.find { |page| page.name == "index.html" && page.dir == "/" }
    html = render(homepage)
    assert_equal ["Who Can Afford to Take a Risk?", "Bread and Games—But What Are We For?", "The Little Oracle", "Another topic"], html.css(".home-topics .home-card-title").map(&:text)
    assert_equal 4, html.css(".home-topics .home-card-image").size
    assert_empty html.css(".home-topic-link")
  end

  def test_old_language_urls_redirect_to_their_topic
    JekyllRedirectFrom::Generator.new.generate(@site)
    @site.collections.fetch("topics").docs.each do |topic|
      refute_empty topic.data.fetch("redirect_from")
      topic.data.fetch("redirect_from").each do |old_url|
        redirect = @site.pages.find { |page| page.url == old_url }
        refute_nil redirect
        assert_equal "#{@site.config.fetch('url')}#{topic.url}", redirect.data.fetch("redirect").fetch("to")
        save_preview(old_url, redirect.output)
      end
    end
  end

  def test_topic_landing_lists_published_english_topics_and_links_from_navigation
    landing = @site.pages.find { |page| page.path == "topics/index.html" }
    assert_equal "/topics/", landing.url
    html = render(landing)
    assert_equal HOME_TOPIC_URLS, html.css(".topic-articles__topic").map { |link| link["href"] }
    assert_equal ["12 installments", "9 installments", "5 installments"], html.css(".topic-articles__meta").map { |meta| meta.text.strip }
    assert_equal 3, html.css(".topic-articles__image").size
    assert_equal 3, html.css(".topic-articles__description").size
    assert_empty html.css("time")
    save_preview(landing.url, html.to_html)

    %w[l/index.html index.html category/fiction.html].each do |path|
      page = @site.pages.find { |candidate| candidate.path == path }
      assert render(page).at_css('a[href="/topics/"]'), "#{path} must link to the topic landing"
      save_preview(page.url, render(page).to_html) if path == "l/index.html"
    end
  end

  def test_topic_landing_accepts_later_topics_and_hides_unfinished_topics
    landing = @site.pages.find { |page| page.path == "topics/index.html" }
    collection = @site.collections.fetch("topics")
    [["future-topic", true], ["unfinished-topic", false]].each do |slug, published|
      topic = Jekyll::Document.new(File.join(ROOT, "_topics", "#{slug}.markdown"), site: @site, collection: collection)
      topic.data.merge!(collection.docs.find { |doc| doc.data["lang"] == "en" }.data)
      topic.data.merge!("title" => slug, "order" => 4, "slug" => slug, "published" => published)
      collection.docs << topic
    end
    expanded = render(landing)
    assert_equal HOME_TOPIC_URLS + ["/topics/future-topic/"], expanded.css(".topic-articles__topic").map { |link| link["href"] }
    refute_includes expanded.text, "unfinished-topic"
  end

  def test_converted_topics_are_absent_from_fiction_and_blog_feeds
    fiction = @site.pages.find { |page| page.path == "category/fiction.html" }
    links = render(fiction).css(".fiction-articles__story").map { |link| link["href"] }
    refute links.any? { |url| url.include?("bread-and-games") || url.include?("the-little-oracle") }
    refute @site.posts.docs.any? { |post| post.path.include?("bread-and-games") || post.path.include?("the-little-oracle") }
    save_preview("/category/fiction.html", render(fiction).to_html)
  end

  def test_bread_introduction_and_future_vision_are_preserved_once
    topic = @site.collections.fetch("topics").docs.find { |doc| doc.url == "/topics/bread-and-games/" }
    html = render(topic)
    assert_equal 1, html.css(".topic-summary").size
    assert_includes html.at_css(".topic-summary").text, "What do you do?"
    assert_equal 1, html.css(".future-vision").size
    assert_includes html.at_css(".future-vision").text, "What waits for us when work is gone?"
  end

  def test_oracle_sections_follow_the_published_installment_boundaries
    topic = @site.collections.fetch("topics").docs.find { |doc| doc.url == "/topics/the-little-oracle/" }
    html = render(topic)
    assert_equal ["The Weave", "A God in the Hand", "Advice Becomes Ritual", "The State Learns to Bless", "Prayer with a Return Channel"].reverse,
      html.css(".topic > h2").map(&:text)
    openings = [
      "Thirty years from now, nobody called it artificial intelligence anymore.",
      "They were no larger than a plum",
      "A woman deciding whether to forgive her brother",
      "There were official rituals too",
      "The weave was too useful to reject and too vast to love."
    ]
    html.css(".topic > h2").zip(openings.reverse).each do |heading, opening|
      assert heading.next_element.next_element.text.start_with?(opening)
    end
    assert_equal %w[2085816166904152071 2086565555922784714 2088294087522714057 2092053145127989517 2093837149942497300],
      topic.data.fetch("x_chapters").map { |chapter| chapter.fetch("x_post_id") }
  end

  def test_a_new_confirmed_installment_appears_first_with_its_own_publication
    topic = @site.collections.fetch("topics").docs.find { |doc| doc.url == "/topics/the-little-oracle/" }
    previous_publications = topic.data.fetch("x_chapters").dup
    publication = { "part" => 6, "x_post_id" => "new-confirmed-post", "published_at" => "2026-10-09T12:00:00Z" }
    topic.content += "\n\n## A New Morning\n\nThe oracle glowed beside the window.\n"
    topic.data["x_chapters"] = previous_publications + [publication]

    html = render(topic)
    first_heading = html.at_css(".topic > h2")
    assert_equal "A New Morning", first_heading.text
    assert_equal "https://x.com/snscaimito/status/new-confirmed-post", first_heading.next_element.at_css("a")["href"]
    assert_equal "09 Oct 2026", first_heading.next_element.at_css("time").text
    assert_equal "The oracle glowed beside the window.", first_heading.next_element.next_element.text
    assert_equal previous_publications.reverse.map { |chapter| "https://x.com/snscaimito/status/#{chapter.fetch('x_post_id')}" },
      html.css(".topic-x-reference > a").drop(1).map { |link| link["href"] }
    assert_equal 1, html.css(".topic-summary").size
  end

  def save_preview(url, html)
    return unless ENV["TOPICS_PREVIEW_DIR"]

    destination = File.join(ENV.fetch("TOPICS_PREVIEW_DIR"), url.delete_prefix("/"))
    destination = File.join(destination, "index.html") if url.end_with?("/")
    FileUtils.mkdir_p(File.dirname(destination))
    File.write(destination, html)
  end
end
