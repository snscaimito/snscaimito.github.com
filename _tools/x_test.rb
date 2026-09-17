# frozen_string_literal: true

require "minitest/autorun"
require_relative "x"

class XPublisherTest < Minitest::Test
  def records
    [
      {
        "published_at" => "2026-08-01T10:00:00Z",
        "series" => "Free Air",
        "part" => 1,
        "x_post_id" => "1001",
        "x_post_url" => "https://x.com/i/web/status/1001"
      },
      {
        "published_at" => "2026-08-02T10:00:00Z",
        "series" => "Free Air",
        "part" => 2,
        "x_post_id" => "1002",
        "x_post_url" => "https://x.com/i/web/status/1002"
      }
    ]
  end

  def test_later_installments_quote_part_one
    card = { "id" => "free-air-03", "series" => "Free Air", "part" => 3 }

    target = quote_target_for(card, records: records)

    assert_equal 1, target.fetch("part")
    assert_equal "1001", target.fetch("x_post_id")
  end

  def test_series_root_reply_uses_native_references_without_a_url
    card = { "id" => "free-air-03", "series" => "Free Air", "part" => 3 }
    root = quote_target_for(card, records: records)

    body = series_root_reply_body(card, root, "1003")

    assert_equal "Part 3", body.fetch("text")
    assert_equal({ "in_reply_to_tweet_id" => "1001" }, body.fetch("reply"))
    assert_equal "1003", body.fetch("quote_tweet_id")
    refute_match %r{https?://}, body.fetch("text")
    refute_match %r{https?://}, JSON.generate(body)
  end

  def test_series_opener_has_no_quote_target
    card = { "id" => "free-air-01", "series" => "Free Air", "part" => 1 }

    assert_nil quote_target_for(card, records: records)
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
