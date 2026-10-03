# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require_relative "x"

class XPublisherTest < Minitest::Test
  def records
    [
      {
        "published_at" => "2026-08-01T10:00:00Z",
        "series" => "Free Air",
        "part" => 1,
        "x_post_id" => "1001",
        "x_post_url" => "https://x.com/i/web/status/1001",
        "text" => "The city woke under a quiet sky.\n\nNobody knew what would happen next."
      },
      {
        "published_at" => "2026-08-02T10:00:00Z",
        "series" => "Free Air",
        "part" => 2,
        "x_post_id" => "1002",
        "x_post_url" => "https://x.com/i/web/status/1002",
        "text" => "By noon the streets were full."
      }
    ]
  end

  def test_later_installments_quote_part_one
    card = { "id" => "free-air-03", "series" => "Free Air", "part" => 3 }

    target = quote_target_for(card, records: records, account: "snscaimito")

    assert_equal 1, target.fetch("part")
    assert_equal "1001", target.fetch("x_post_id")
    assert_equal "https://x.com/snscaimito/status/1001", target.fetch("x_post_url")
  end

  def test_series_root_reply_uses_native_references_without_a_url
    card = { "id" => "free-air-03", "series" => "Free Air", "part" => 3 }
    root = quote_target_for(card, records: records, account: "snscaimito")

    body = series_root_reply_body(card, root, "1003")

    assert_equal "Part 3", body.fetch("text")
    assert_equal({ "in_reply_to_tweet_id" => "1001" }, body.fetch("reply"))
    assert_equal "1003", body.fetch("quote_tweet_id")
    refute_match %r{https?://}, body.fetch("text")
    refute_match %r{https?://}, JSON.generate(body)
  end

  def test_final_series_summary_quotes_the_series_opener_with_the_article_link
    card = {
      "id" => "free-air-summary",
      "series" => "Free Air",
      "part" => 5,
      "publication_type" => "series_summary",
      "status" => "queued",
      "text" => "Sanne leaves the station to choose her own future.",
      "article_url" => "https://www.stephan-schwab.com/2026/08/23/free-air.html",
      "footer" => "Free Air — a serialized story."
    }

    body = series_summary_body(card, "1001")

    assert_equal "Sanne leaves the station to choose her own future.\n\nRead the full story: https://www.stephan-schwab.com/2026/08/23/free-air.html\n\nFree Air — a serialized story.", body.fetch("text")
    assert_equal "1001", body.fetch("quote_tweet_id")
    refute body.key?("reply")
  end

  def test_final_series_summary_rejects_an_external_article_link
    card = {
      "id" => "free-air-summary",
      "series" => "Free Air",
      "part" => 5,
      "publication_type" => "series_summary",
      "status" => "queued",
      "text" => "A summary.",
      "article_url" => "https://example.com/2026/08/23/free-air.html",
      "footer" => "Free Air — a serialized story."
    }

    _, stderr = capture_io do
      assert_raises(SystemExit) { series_summary_text(card) }
    end
    assert_includes stderr, "needs a full article URL"
  end

  def test_a_closed_series_cannot_publish_another_chapter
    card = { "id" => "free-air-05", "series" => "Free Air", "part" => 5 }
    closed_records = records + [{ "series" => "Free Air", "publication_type" => "series_summary", "source_card_id" => "free-air-04" }]

    _, stderr = capture_io do
      assert_raises(SystemExit) { quote_target_for(card, records: closed_records, account: "snscaimito") }
    end
    assert_includes stderr, "already closed"
  end

  def test_final_chapter_has_a_separate_queued_summary_card
    Dir.mktmpdir do |queue|
      final = {
        "id" => "free-air-04", "series" => "Free Air", "part" => 4,
        "series_end" => true, "series_summary_card_id" => "free-air-summary"
      }
      summary = {
        "id" => "free-air-summary", "series" => "Free Air", "part" => 5,
        "publication_type" => "series_summary", "status" => "queued",
        "text" => "Sanne chooses her own future.",
        "article_url" => "https://www.stephan-schwab.com/2026/08/23/free-air.html",
        "footer" => "Free Air — a serialized story."
      }
      File.write(File.join(queue, "free-air-summary.json"), JSON.generate(summary))

      path, loaded_summary = series_summary_card_for(final, queue: queue)

      assert_equal "free-air-summary.json", File.basename(path)
      assert_equal "queued", loaded_summary.fetch("status")
      assert_equal 5, loaded_summary.fetch("part")
      assert_equal "series_summary", loaded_summary.fetch("publication_type")
    end
  end

  def test_summary_waits_for_its_final_chapter
    Dir.mktmpdir do |queue|
      final = {
        "id" => "free-air-04", "series" => "Free Air", "part" => 4,
        "series_end" => true, "series_summary_card_id" => "free-air-summary",
        "series_root_reply_status" => "published"
      }
      File.write(File.join(queue, "free-air-04.json"), JSON.generate(final))
      summary = { "id" => "free-air-summary", "series" => "Free Air", "part" => 5, "publication_type" => "series_summary" }

      _, stderr = capture_io do
        assert_raises(SystemExit) { validate_series_summary_predecessor(summary, records: [], queue: queue) }
      end
      assert_includes stderr, "before its final chapter"

      assert_nil validate_series_summary_predecessor(summary, records: records + [{ "card_id" => "free-air-04", "part" => 4 }], queue: queue)
    end
  end

  def test_a_source_backed_final_chapter_requires_a_summary_package
    card = {
      "id" => "the-certainty-index-06",
      "status" => "queued",
      "series" => "The Certainty Index",
      "source" => { "file" => "_posts/2026/2026-08-26-the-certainty-index.markdown", "section" => 6 }
    }

    _, stderr = capture_io do
      assert_raises(SystemExit) { validate_final_source_section(card) }
    end
    assert_includes stderr, "needs series_end"
  end

  def test_series_opener_has_no_quote_target
    card = { "id" => "free-air-01", "series" => "Free Air", "part" => 1 }

    assert_nil quote_target_for(card, records: records, account: "snscaimito")
  end

  def test_story_package_uses_plain_language_series_footer
    card = {
      "status" => "queued",
      "series" => "Mobilizing Private Savings",
      "footer" => "Mobilizing Private Savings — a serialized story."
    }

    assert_nil validate_story_package(card, "card.json")
  end

  def test_card_image_paths_supports_up_to_four_ordered_images
    card = {
      "id" => "gnn-island-exclusive",
      "images" => [
        "img/the-last-foundry/06-gnn-island-exclusive.png",
        "img/the-last-foundry/02-independent-power.png",
        "img/the-last-foundry/03-silicon-inheritance.png",
        "img/the-last-foundry/04-compute-assembly.png"
      ]
    }

    assert_equal card.fetch("images").map { |path| File.expand_path(path, REPOSITORY) }, card_image_paths(card)
  end

  def test_card_image_paths_preserves_legacy_single_image_cards
    card = { "id" => "legacy", "image" => "img/legacy.png" }

    assert_equal [File.expand_path("img/legacy.png", REPOSITORY)], card_image_paths(card)
  end

  def test_card_image_paths_allows_a_text_only_card
    card = { "id" => "text-only-reply" }

    assert_empty card_image_paths(card)
  end

  def test_reply_target_uses_the_recorded_parent_card
    reply_records = records + [
      {
        "published_at" => "2026-09-19T12:00:00Z",
        "card_id" => "the-last-responsible-person",
        "x_post_id" => "2001",
        "x_post_url" => "https://x.com/i/web/status/2001"
      }
    ]
    card = {
      "id" => "the-last-responsible-person-reply",
      "reply_to_card_id" => "the-last-responsible-person"
    }

    target = reply_target_for(card, records: reply_records, account: "snscaimito")

    assert_equal "2001", target.fetch("x_post_id")
    assert_equal "the-last-responsible-person", target.fetch("card_id")
    assert_equal "https://x.com/snscaimito/status/2001", target.fetch("x_post_url")
  end

  def test_reply_body_uses_the_native_reply_reference
    target = { "x_post_id" => "2001" }

    assert_equal(
      {
        "text" => "The explanation.",
        "reply" => { "in_reply_to_tweet_id" => "2001" }
      },
      reply_body("The explanation.", target)
    )
  end

  def test_publication_text_preserves_native_long_posts
    body = "Complete approved copy. " * 20
    card = {
      "text" => body,
      "series" => "AI Island",
      "footer" => "AI Island — a serialized story."
    }

    assembled = publication_text(card)

    assert_operator assembled.length, :>, 280
    assert_equal "#{body.rstrip}\n\nAI Island — a serialized story.", assembled
  end

  def test_publication_page_data_groups_series_and_keeps_only_public_metadata
    page_records = records + [
      {
        "published_at" => "2026-08-02T10:00:01Z",
        "publication_type" => "series_root_reply",
        "series" => "Free Air",
        "linked_part" => 2,
        "x_post_id" => "1003",
        "x_post_url" => "https://x.com/i/web/status/1003",
        "text" => "Part 2"
      },
      {
        "published_at" => "2026-08-03T10:00:00Z",
        "publication_type" => "article",
        "article_title" => "API Article",
        "x_post_id" => "1004",
        "x_post_url" => "https://x.com/i/web/status/1004",
        "article_content_state" => { "private" => "not exported" }
      }
    ]

    data = publication_page_data(page_records, account: "snscaimito")

    assert_equal ["Free Air", "Standalone posts"], data.fetch("groups").map { |group| group.fetch("name") }
    assert_equal "The city woke under a quiet sky. Nobody knew what would happen next.", data.dig("groups", 0, "posts", 0, "excerpt")
    assert_equal "API Article", data.dig("groups", 1, "posts", 0, "excerpt")
    refute_includes JSON.generate(data), "1003"
    refute_includes JSON.generate(data), "not exported"
    refute_includes JSON.generate(data), '"text":'
    refute_includes JSON.generate(data), '"label":'
  end

  def test_publication_page_excerpt_is_compact
    excerpt = publication_page_excerpt({ "text" => "word " * 100 }, max_length: 40)

    assert_operator excerpt.length, :<=, 41
    assert excerpt.end_with?("…")
  end

  def test_publication_page_images_use_public_paths_and_copy_non_public_originals
    Dir.mktmpdir do |repository|
      public_directory = File.join(repository, "img", "story")
      mirror_directory = File.join(repository, "img", "x-publications")
      FileUtils.mkdir_p(public_directory)
      public_image = File.join(public_directory, "part-one.jpeg")
      private_image = File.join(repository, "publisher", "part-two.png")
      FileUtils.mkdir_p(File.dirname(private_image))
      File.binwrite(public_image, "public image")
      File.binwrite(private_image, "private image")
      record = {
        "x_post_id" => "1005",
        "images" => [public_image, private_image]
      }

      urls = publication_page_image_urls(record, repository: repository, mirror_directory: mirror_directory)

      assert_equal ["/img/story/part-one.jpeg", "/img/x-publications/1005-2.png"], urls
      assert_equal "private image", File.binread(File.join(mirror_directory, "1005-2.png"))
    end
  end

  def test_publication_page_export_writes_jekyll_data
    Dir.mktmpdir do |directory|
      path = File.join(directory, "_data", "x_publications.json")

      write_publication_page_data(records: records, path: path, account: "snscaimito")

      data = JSON.parse(File.read(path))
      assert_equal "2026-08-02T10:00:00Z", data.fetch("updated_at")
      assert_equal ["https://x.com/snscaimito/status/1001", "https://x.com/snscaimito/status/1002"],
                   data.dig("groups", 0, "posts").map { |post| post.fetch("url") }
    end
  end

  def test_source_card_omits_site_only_future_vision
    card = {
      "id" => "bread-and-games-09",
      "source" => { "file" => "_posts/2026/2026-08-06-bread-and-games.markdown", "section" => 9 }
    }

    text = source_section_text(card)

    assert_includes text, "Tonight,” she said, “you are all on my team."
    refute_includes text, "future-vision"
    refute_includes text, "What waits for us when work is gone?"
  end

end
