# frozen_string_literal: true

require "minitest/autorun"
require "minitest/mock"
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

  def installment_card
    {
      "id" => "the-certainty-index-06",
      "status" => "queued",
      "series" => "The Certainty Index",
      "part" => 6,
      "footer" => "The Certainty Index — a serialized story."
    }
  end

  def with_card(card)
    Dir.mktmpdir do |directory|
      path = File.join(directory, "card.json")
      File.write(path, JSON.generate(card))
      yield path
    end
  end

  def publish_locally(card, existing_records: [])
    requests = []
    ledger = []
    uploads = []
    request = lambda do |method, path, **options|
      requests << [method, path, JSON.parse(options.fetch(:body))]
      { "data" => { "id" => "test-installment" } }
    end
    upload = lambda do |path, _token|
      uploads << path
      "media-#{uploads.length}"
    end

    with_card(card) do |path|
      stub(:access_token, "test-token") do
        stub(:expected_account, "snscaimito") do
          stub(:publication_records, existing_records) do
            stub(:append_publication, ->(record) { ledger << record }) do
              stub(:upload_image, upload) do
                stub(:x_request, request) do
                  capture_io { post(["--file", path]) }
                end
              end
            end
          end
        end
      end
      saved = JSON.parse(File.read(path))
      yield requests, ledger, saved, uploads, path
    end
  end

  def test_queue_copy_publishes_one_standalone_installment_and_preserves_images
    body = "The approval moved the cost to the workshop.\n\nWhat did the approval actually reduce?"
    card = installment_card.merge(
      "text" => body,
      "images" => [
        "img/the-certainty-index/the-certainty-index-scene-01-the-steady-number.jpeg",
        "img/the-certainty-index/the-certainty-index-scene-06-the-unpaved-step.jpeg"
      ],
      "quote_tweet_id" => "legacy-root",
      "series_root_reply_status" => "pending",
      "reply_to_card_id" => "legacy-parent"
    )

    publish_locally(card) do |requests, ledger, saved, uploads, path|
      assert_equal 1, requests.length
      assert_equal [:post, "/2/tweets"], requests.first.first(2)
      assert_equal "#{body}\n\n#{card.fetch('footer')}", requests.first.last.fetch("text")
      assert_equal({ "media_ids" => %w[media-1 media-2] }, requests.first.last.fetch("media"))
      refute requests.first.last.key?("quote_tweet_id")
      refute requests.first.last.key?("reply")
      assert_equal card_image_paths(card), uploads
      assert_equal 1, ledger.length
      assert_equal "queue", ledger.first.fetch("text_source")
      assert_equal body, ledger.first.fetch("narrative_text")
      assert_equal body, saved.fetch("text")
      assert_equal "published", saved.fetch("status")
      assert_equal requests.first.last.fetch("text"), publication_text(load_publication_card(path).last)
      refute saved.key?("quote_tweet_id")
      refute saved.key?("series_root_reply_status")
      refute saved.key?("reply_to_card_id")
    end
  end

  def test_blog_sourced_final_chapter_publishes_without_an_opener_or_summary
    card = installment_card.merge(
      "source" => { "file" => "_posts/2026/2026-08-26-the-certainty-index.markdown", "section" => 6 },
      "series_summary_card_id" => "missing-summary"
    )
    expected = publication_text(card)

    publish_locally(card) do |requests, ledger, saved, _, path|
      assert_equal 1, requests.length
      assert_equal({ "text" => expected }, requests.first.last)
      assert_equal "blog", ledger.first.fetch("text_source")
      assert_equal card.fetch("source"), ledger.first.fetch("source")
      narrative = ledger.first.fetch("narrative_text")
      assert narrative.start_with?("By Friday morning, Elena wore the watch beneath her coat sleeve.")
      assert narrative.end_with?("The other counted nothing but the seconds that were hers.")
      refute_includes narrative, "<figure"
      refute_includes narrative, card.fetch("footer")
      refute saved.key?("text")
      refute saved.key?("series_summary_card_id")

      # The exact sent copy remains available even if its original source disappears.
      saved["source"]["file"] = "_posts/missing-article.markdown"
      File.write(path, JSON.generate(saved))
      assert_equal expected, publication_text(load_publication_card(path).last)
    end
  end

  def test_linked_queue_copy_and_blog_chapter_must_match_before_posting
    source = { "file" => "_posts/2026/2026-08-26-the-certainty-index.markdown", "section" => 6 }
    card = installment_card.merge("source" => source, "text" => "A revision made in the queue.")
    with_card(card) do |path|
      stub(:access_token, -> { flunk "Unsynchronized copy must not contact X" }) do
        _, stderr = capture_io { assert_raises(SystemExit) { post(["--file", path]) } }
        assert_includes stderr, "Synchronize the queue and source before posting"
      end
    end

    card["text"] = source_section_text(card)
    publish_locally(card) do |requests, ledger, saved, _, _|
      assert_equal 1, requests.length
      assert_equal "queue", ledger.first.fetch("text_source")
      assert_equal card.fetch("text"), ledger.first.fetch("narrative_text")
      assert_equal source, saved.fetch("source")
    end
  end

  def test_topic_sourced_chapter_preserves_narrative_and_publication_source
    card = installment_card.merge(
      "series" => "Company Law in Europe", "part" => 11,
      "footer" => "Company Law in Europe — a serialized story.",
      "source" => { "file" => "_topics/who-can-afford-to-take-a-risk.markdown", "section" => 11 }
    )
    expected = source_section_text(card)

    publish_locally(card) do |requests, ledger, saved, _, _|
      assert_equal "#{expected}\n\n#{card.fetch('footer')}", requests.first.last.fetch("text")
      assert_equal "topic", ledger.first.fetch("text_source")
      assert_equal expected, ledger.first.fetch("narrative_text")
      assert_equal card.fetch("source"), saved.fetch("source")
      refute_includes expected, "<figure"
    end
  end

  def test_preview_and_dry_run_show_only_the_installment_without_reading_x_state
    card = installment_card.merge("text" => "A complete scene.", "series_end" => true)
    unexpected = ->(*) { flunk "Preview must not read account state or contact X" }

    with_card(card) do |path|
      stub(:expected_account, unexpected) do
        stub(:publication_records, unexpected) do
          stub(:access_token, unexpected) do
            stub(:x_request, unexpected) do
              output, = capture_io { preview(["--file", path]) }
              assert_includes output, "Text source: queue"
              assert_includes output, "Quote post: none"
              assert_includes output, "Reply: none"
              refute_includes output, "Series-root reply:"
              dry_run, = capture_io { post(["--file", path, "--dry-run"]) }
              payload = JSON.parse(dry_run)
              assert_equal publication_text(card), payload.fetch("text")
              refute payload.key?("quote_tweet_id")
              refute payload.key?("reply_to_tweet_id")
              refute payload.key?("series_root_reply")
              refute payload.key?("series_summary_post")
            end
          end
        end
      end
    end
  end

  def test_published_legacy_card_with_pending_reply_cannot_send_another_post
    card = installment_card.merge(
      "status" => "published", "text" => "The original post.\n\nThe Certainty Index — a serialized story.",
      "x_post_id" => "old-installment", "series_root_reply_status" => "pending"
    )
    with_card(card) do |path|
      assert_equal card.fetch("text"), publication_text(load_publication_card(path).last)
      stub(:access_token, -> { flunk "A published card must not contact X" }) do
        _, stderr = capture_io { assert_raises(SystemExit) { post(["--file", path]) } }
        assert_includes stderr, "published, not queued"
      end
    end
  end

  def test_previously_recorded_queued_card_cannot_publish_again
    card = installment_card.merge("text" => "The original post.")
    with_card(card) do |path|
      stub(:publication_records, [{ "card_id" => card.fetch("id") }]) do
        stub(:access_token, -> { flunk "A recorded card must not contact X" }) do
          _, stderr = capture_io { assert_raises(SystemExit) { post(["--file", path]) } }
          assert_includes stderr, "already recorded as published"
        end
      end
    end
  end

  def test_obsolete_summary_cards_are_excluded_from_cadence_and_rejected
    summary = installment_card.merge("publication_type" => "series_summary", "text" => "A summary.")
    with_card(summary) do |path|
      assert_empty next_publication_cards(queue: File.dirname(path))
      _, stderr = capture_io { assert_raises(SystemExit) { load_publication_card(path) } }
      assert_includes stderr, "only installments belong in the X queue"
    end
  end

  def test_historical_navigation_replies_and_summaries_do_not_affect_cadence
    candidates = {
      "Free Air" => { "series" => "Free Air", "part" => 3 },
      "Other Series" => { "series" => "Other Series", "part" => 2 }
    }
    history = [
      { "series" => "Free Air", "part" => 2, "published_at" => "2026-08-01T10:00:00Z" },
      { "series" => "Other Series", "part" => 1, "published_at" => "2026-08-02T10:00:00Z" },
      { "series" => "Free Air", "publication_type" => "series_root_reply", "published_at" => "2026-10-01T10:00:00Z" },
      { "series" => "Free Air", "publication_type" => "series_summary", "published_at" => "2026-10-02T10:00:00Z" }
    ]
    stub(:next_publication_cards, candidates) do
      stub(:publication_records, history) do
        assert_equal "Free Air", cadence_snapshot.fetch("candidate").fetch("series")
      end
    end
  end

  def test_separately_requested_reply_outside_a_series_still_uses_one_post
    card = {
      "id" => "standalone-reply", "status" => "queued",
      "text" => "The workshop paid the bill.", "reply_to_card_id" => "parent"
    }
    parent = {
      "card_id" => "parent", "x_post_id" => "parent-post", "published_at" => "2026-10-01T10:00:00Z"
    }
    publish_locally(card, existing_records: [parent]) do |requests, ledger, saved, _, _|
      assert_equal 1, requests.length
      assert_equal(
        { "text" => card.fetch("text"), "reply" => { "in_reply_to_tweet_id" => "parent-post" } },
        requests.first.last
      )
      assert_equal "parent-post", ledger.first.fetch("reply_to_tweet_id")
      assert_equal "parent-post", saved.fetch("reply_to_tweet_id")
    end
  end

  def test_story_package_uses_plain_language_series_footer
    card = {
      "id" => "mobilizing-private-savings-01",
      "status" => "queued",
      "series" => "Mobilizing Private Savings",
      "part" => 1,
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

  def test_publication_page_does_not_export_api_experiments
    experiments = PUBLICATION_PAGE_EXCLUDED_IDS.map do |post_id|
      { "x_post_id" => post_id, "published_at" => "2026-08-23T10:17:25Z",
        "publication_type" => "article", "article_title" => "API publishing test" }
    end

    data = publication_page_data(records + experiments, account: "snscaimito")

    assert_equal ["Free Air"], data.fetch("groups").map { |group| group.fetch("name") }
    assert_equal %w[1001 1002], data.dig("groups", 0, "posts").map { |post| post.fetch("id") }
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
