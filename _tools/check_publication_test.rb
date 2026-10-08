# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require "fileutils"
require_relative "check_publication"

class PublicationCheckTest < Minitest::Test
  def setup
    @root = Dir.mktmpdir
    @config = {
      "permalink" => "/:year/:month/:day/:title.html",
      "future" => false, "show_drafts" => false, "unpublished" => false,
      "exclude" => PublicationCheck::INTERNAL_PATHS + ["img/unfinished"]
    }
    write("_config.yml", @config.to_yaml)
  end

  def teardown
    FileUtils.remove_entry(@root)
  end

  def write(path, text)
    destination = File.join(@root, path)
    FileUtils.mkdir_p(File.dirname(destination))
    File.write(destination, text)
  end

  def post(name, metadata, content = "")
    write("_posts/2026/2026-10-01-#{name}.markdown", "#{{ 'layout' => 'post' }.merge(metadata).to_yaml}---\n#{content}")
  end

  def check(output = nil)
    PublicationCheck.new(@root, today: Date.new(2026, 10, 6)).errors(output)
  end

  def test_unpublished_post_and_excluded_illustrations_are_allowed
    post("unfinished", { "published" => false }, '<img src="/img/unfinished/scene.png">')
    write("img/unfinished/scene.png", "image")

    assert_empty check
  end

  def test_legacy_binary_images_in_posts_are_not_parsed_as_posts
    write("_posts/img/photo.jpg", "\xFF\xD8\xFF".b)

    assert_empty check
  end

  def test_unpublished_images_need_their_own_exclusion
    post("unfinished", { "published" => false }, '<img src="/img/leaking/scene.png">')

    assert_includes check, "Exclude unpublished illustration: /img/leaking/scene.png"
  end

  def test_publishing_a_finished_story_requires_releasing_its_images
    post("finished", {}, '<img src="/img/unfinished/scene.png">')

    assert_includes check, "Published content references excluded illustration: /img/unfinished/scene.png"
  end

  def test_images_shared_with_published_content_remain_public
    image = '<img src="/img/shared/scene.png">'
    post("unfinished", { "published" => false }, image)
    post("finished", {}, image)

    assert_empty check
  end

  def test_shared_published_x_images_remain_public
    post("unfinished", { "published" => false }, '<img src="/img/shared/scene.png">')
    write("_data/x_publications.json", JSON.generate({ "images" => ["/img/shared/scene.png"] }))

    assert_empty check
  end

  def test_ineffective_draft_flag_blocks_publication
    post("unfinished", { "draft" => true })

    assert check.any? { |error| error.include?("replace draft: true with published: false") }
  end

  def test_future_post_images_are_protected_before_the_date_arrives
    write("_posts/2026/2026-12-01-future.markdown", "---\nlayout: post\n---\n<img src=\"/img/future/scene.png\">")

    assert_includes check, "Exclude unpublished illustration: /img/future/scene.png"
  end

  def test_production_cannot_enable_unpublished_posts_or_override_exclusions
    @config["unpublished"] = true
    @config["include"] = ["_planning"]
    write("_config.yml", @config.to_yaml)

    assert_includes check, "unpublished must remain false"
    assert_includes check, "Exclude internal file or directory: _planning"
  end

  def test_public_pages_cannot_link_to_an_unpublished_story
    post("unfinished", { "published" => false })
    write("index.html", "---\n---\n<a href=\"/2026/10/01/unfinished.html\">Story</a>")

    assert_includes check, "index.html links to unpublished post: /2026/10/01/unfinished.html"
  end

  def test_artifact_rejects_draft_pages_images_internal_files_and_feed_references
    post("unfinished", { "published" => false }, '<img src="/img/unfinished/scene.png">')
    write("_site/2026/10/01/unfinished.html", "Unfinished story")
    write("_site/img/unfinished/unused-scene.png", "image")
    write("_site/AGENTS.md", "Internal instructions")
    write("_site/rss.xml", "<link>/2026/10/01/unfinished.html</link>")

    errors = check("_site")
    assert_includes errors, "Unfinished or internal file in publication artifact: 2026/10/01/unfinished.html"
    assert_includes errors, "Unfinished or internal file in publication artifact: img/unfinished/unused-scene.png"
    assert_includes errors, "Unfinished or internal file in publication artifact: AGENTS.md"
    assert_includes errors, "rss.xml references unpublished content: /2026/10/01/unfinished.html"
  end

  def test_clean_artifact_passes_and_missing_artifact_fails
    post("finished", {})
    write("_site/index.html", "Published stories")
    write("_site/2026/10/01/finished.html", "Finished story")

    assert_empty check("_site")
    assert check("missing").any? { |error| error.start_with?("Missing publication artifact:") }
  end

  def topic(name, metadata, content = "")
    @config["collections"] = { "topics" => { "output" => true, "permalink" => "/topics/:name/" } }
    write("_config.yml", @config.to_yaml)
    write("_topics/#{name}.markdown", "#{metadata.to_yaml}---\n#{content}")
  end

  def test_unpublished_topic_images_and_links_are_protected
    topic("unfinished", { "published" => false }, '<img src="/img/leaking/topic.png">')
    write("index.html", "---\n---\n<a href=\"/topics/unfinished/\">Topic</a>")
    write("_site/topics/unfinished/index.html", "Unfinished topic")

    errors = check("_site")
    assert_includes errors, "Exclude unpublished illustration: /img/leaking/topic.png"
    assert_includes errors, "index.html links to unpublished post: /topics/unfinished/"
    assert_includes errors, "Unfinished or internal file in publication artifact: topics/unfinished/index.html"
  end

  def test_published_topic_can_share_an_unpublished_posts_image
    image = '<img src="/img/shared/scene.png">'
    post("unfinished", { "published" => false }, image)
    topic("finished", { "layout" => "topic" }, image)

    assert_empty check
  end

  def test_published_topic_cannot_reference_excluded_images
    topic("finished", { "layout" => "topic" }, '<img src="/img/unfinished/scene.png">')

    assert_includes check, "Published content references excluded illustration: /img/unfinished/scene.png"
  end

  def test_unpublished_topic_redirects_do_not_publish
    topic("unfinished", { "published" => false, "redirect_from" => ["/old-topic.html"] })
    write("_site/old-topic.html", "Redirect")

    assert_includes check("_site"), "Unfinished or internal file in publication artifact: old-topic.html"
  end
end
