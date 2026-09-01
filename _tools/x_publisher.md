# Manual X CLI and publishing notes

`_tools/x.rb` is a local, single-account command-line publisher for the X API. It is deliberately small: Ruby standard library only—no gems, npm packages, Python packages, or external upload tools. It is for deliberate publishing from this Mac, not RSS ingestion, background polling, or multi-user access.

## Account, credentials, and privacy

The CLI reads only these values from `_tools/.env`:

```text
X_CLIENT_ID=...
X_ACCOUNT=your_handle
```

`X_ACCOUNT` binds the tool to that X handle. Before any read or write, it checks the authenticated user returned by X and stops if the handle differs. Existing bearer tokens, consumer keys, client secrets, and API secrets in `.env` are not read by this CLI.

The tool uses OAuth 2.0 Authorization Code with PKCE as an X Native App. Its registered callback must exactly be:

```text
http://127.0.0.1:8765/callback
```

The requested permissions are `tweet.read`, `tweet.write`, `users.read`, `media.write`, and `offline.access`.

Both `_tools/.env` and `_tools/.x-publisher/` are Git-ignored. `_tools/` is excluded from the Jekyll/GitHub Pages build. That prevents these local files from being deployed with the site; never commit a secret or token regardless.

## Authorization and token lifetime

Authorize once in the browser:

```sh
ruby _tools/x.rb authorize
```

The browser returns only to this Mac at `127.0.0.1`. The access token is short-lived (X currently issued roughly two-hour tokens). Because the request includes `offline.access`, X also issues a refresh token. The CLI refreshes the access token automatically shortly before expiry and saves the rotated token state at `_tools/.x-publisher/token.json` with owner-only permissions.

Reauthorize if the refresh token is revoked or refresh fails—for example, after revoking the app in X or changing its authorization. Never copy the token-state file to another machine or repository.

## Commands

Check the account and read its own posts:

```sh
ruby _tools/x.rb me
ruby _tools/x.rb posts --limit 20
```

`posts --limit 1` shows one post but X requires the request to retrieve at least five; the CLI displays only the requested number.

Review a post without contacting X:

```sh
ruby _tools/x.rb post --text 'A considered post.' --link 'https://example.com' --image image.png --dry-run
```

Preview a prepared publication card without contacting X:

```sh
ruby _tools/x.rb preview --file _tools/publication-queue/the-little-oracle-01.json
```

The preview prints the exact text, status, character count, absolute image path, and—when applicable—the preceding installment that the post will quote. It validates the JSON and image but does not authorize, refresh a token, upload media, or publish. Codex can render the reported image path in this chat when you ask to preview a card.

Review the manual cadence and its recommended next installment without contacting X:

```sh
ruby _tools/x.rb cadence
ruby _tools/x.rb cadence --series 'The Mouth Between Suns'
ruby _tools/x.rb preview-next
ruby _tools/x.rb preview-next --series 'The Mouth Between Suns'
```

The cadence is one story installment every 24 hours. The recommendation considers only final `queued` cards, continues each series in part order, and mixes topics by preferring the started series that has waited longest. A series that has not started becomes eligible after no started series has a publishable next card. This is calculated only when the command runs; there is no scheduler, daemon, polling process, or background publication.

Publish only after reviewing the exact copy and image:

```sh
ruby _tools/x.rb post --text 'A considered post.' --link 'https://example.com' --image image.png
```

The link is appended to the text. Images may be JPG, PNG, GIF, or WebP, up to 5 MB.

Publish an approved prepared card the same way:

```sh
ruby _tools/x.rb post --file _tools/publication-queue/the-little-oracle-01.json
```

Publish the recommended next installment only in response to an explicit request:

```sh
ruby _tools/x.rb post-next
ruby _tools/x.rb post-next --series 'Bread and Games'
```

`post-next` refuses to publish before the 24-hour window. An explicit decision to publish early can be carried out with `--override-cadence`; that option bypasses only the timing check, never the queue-status or duplicate-publication safeguards.

Every successful API publication is written locally to `_tools/.x-publisher/publications.jsonl`, including its X post ID, URL, timestamp, exact text, attached image, source card, and quote target when present. Historical posts recovered from X are kept separately in `_tools/.x-publisher/historical-publications.jsonl`; they retain their confirmed IDs, URLs, and timestamps without pretending to be newly published. Review the combined history without contacting X:

```sh
ruby _tools/x.rb history
```

When publishing a card, the CLI first rejects anything other than `queued` and refuses a card already present in the ledger. After X confirms publication, it appends the ledger record and updates the card with `published` status, timestamp, X post ID, X URL, and quote target where applicable. The ledger and the queue are local and Git-ignored.

The tool has been authorized and has successfully read the latest post from the configured account. Live use has confirmed regular text publishing, image upload, native longer posts, and Article draft/publish flow with embedded Article images. Article publication remains a separate, explicit command.

## Publishing format decision

Use native longer posts for a serialized story. Every chapter remains an independent top-level post; part 2 onward quotes the recorded part 1 hub, and part 1 receives a direct navigation reply that natively quotes each new chapter. This gives the series an X-native two-way reading path while preserving the existing cadence, preview, duplicate, and fail-closed opener safeguards.

Use an X Article for a complete standalone story or essay that benefits from rich layout, a cover, and inline images. Do not use Articles for a chapter-by-chapter serial: the Articles API cannot make a published Article announcement quote its predecessor, update a published Article body, or add forward navigation after a later chapter exists.

This is a publication-format choice made for each approved work. It does not change the existing regular-post workflow or automatically convert any queued story.

## X Articles

X Articles are an opt-in extension to the existing post/card workflow. They do not affect `post`, `preview`, cadence, prepared story cards, or quote-post chaining. Invoke the Article command only for a specifically approved standalone publication.

The command creates an X Article draft and publishes it immediately by default. Use `--dry-run` to review the exact DraftJS request locally, or `--draft-only` to create a draft without making it public:

```sh
ruby _tools/x.rb article --title "A considered Article" --markdown article.md --cover image.png --dry-run
ruby _tools/x.rb article --title "A considered Article" --markdown article.md --cover image.png
ruby _tools/x.rb article --title "A considered Article" --content-state article.json --draft-only
```

`--markdown` converts paragraphs, level-one through level-three headings, ordered and unordered list items, and block quotes into DraftJS blocks. A standalone Markdown image line such as `![A short caption](images/divider.jpeg)` becomes an atomic Article image block: the CLI uploads the local image, adds its media ID to an `image` entity, and places the block at that point in the Article. It is best for straightforward prose. The `--title` value is the Article heading rendered by X; do not repeat that title as a Markdown `#` heading in the body. For rich formatting, links, code, tables, dividers, LaTeX, or embedded posts, provide the complete native DraftJS state with `--content-state`; the CLI passes it through after structural validation. `--cover` uploads a JPG, PNG, GIF, or WebP through the existing media-upload flow and sends its `tweet_image` media ID as the Article cover.

On publication, the local ledger records the Article ID, exact title and content state, source file, optional cover image, and the announcement-post URL returned by X. Replies belong to that announcement post, not to individual Article blocks. A draft-only command prints its Article ID but deliberately does not write a publication record. The Articles endpoints require the existing user-context OAuth flow and the account's current X Article eligibility.

The current Article command accepts a standalone Markdown file or native DraftJS JSON. It does not yet import a Jekyll `_post` directly: passing an existing post with site `<figure>` markup would render that markup as text. Keep using source-backed cards for serialized `_posts`. A future Jekyll importer must remove front matter, turn each site figure into an atomic Article image, select a cover image, and preserve canonical chapter boundaries before it is used for site posts.

Articles can link back to an earlier announcement through a DraftJS link or embedded-post entity, but this is only one-way. The documented API has draft creation and publication endpoints, not Article editing or a `quote_tweet_id` option. For durable two-way navigation among Article-sized chapters, use an editable site-hosted series index; do not pretend the Article API supplies a native quote chain.

## Story distribution rule

X is a distribution mechanism for the full canonical story—not a place to publish an adaptation, teaser, summary, excerpt, or rewritten version. When distributing a site story, use a source-backed card that reads the canonical article directly.

Divide only at existing article chapter or scene boundaries. If the article has an introduction before its first chapter, include it with the first card. Each source-backed card posts every word of the selected narrative body unaltered, in source order. The only removed material is the website's section heading, Jekyll front matter, and site-only image/lightbox markup. Do not add a title, series label, part number, link, or rewritten closing to the narrative.

Every prepared story post is a three-part publication package: the complete canonical chapter or scene text as written, its matching image, and a separate plain-language footer in the exact form `<Series Title> — a serialized story.` For example: `The Mouth Between Suns — a serialized story.` Do not use hashtags; they no longer serve as the series identifier. The footer is part of the package, not part of the story text. A footer never makes a summary, excerpt, adaptation, or rewritten scene acceptable.

## Series linking through the part 1 hub

Each series opener (part 1) is the permanent hub and a normal top-level X post. Every later installment is another top-level post that natively quotes part 1. After that installment succeeds, the publisher creates a direct reply beneath part 1 whose text is only `Part N` and which natively quotes the new installment. The root therefore carries forward links to every later part, while every later part links back to the root.

The publisher uses X reference fields for both directions. The installment request sends `quote_tweet_id` for part 1. The navigation request sends `reply.in_reply_to_tweet_id` for part 1 and `quote_tweet_id` for the new installment. It deliberately puts no URL in the navigation text: X's pay-per-use pricing distinguishes ordinary content creation from the more expensive “Content: Create (with URL)” operation. The navigation reply remains a second content-create request, but it is URL-free. Recheck the [current X API pricing](https://docs.x.com/x-api/getting-started/pricing) before live use because rates and entitlements can change.

For a prepared card with part 2 or later, the publisher requires a local publication record for part 1 with an X post ID and refuses publication when the opener cannot be identified. `preview --file <card>` and `post --file <card> --dry-run` show the root quote plus the URL-free navigation reply before any X request. Use the Ruby CLI only; do not create either relationship through browser automation.

The installment is recorded immediately after X creates it, before the root reply is attempted, so a second-request failure cannot cause a duplicate installment. Its card remains marked with `series_root_reply_status: pending`; rerunning the same `post --file` command retries only the missing root reply. A successful navigation reply receives its own ledger record and changes the relationship status to `published` on the card.

The source-backed cards for *The Mouth Between Suns* and *Mobility, As Authorized* follow this rule. Final unpublished packages remain `queued`—ready for an explicit publication decision but not scheduled—and are kept locally in `_tools/publication-queue/`. `preview --file <card>` displays the exact distribution payload, while `post --file <card>` sends that same payload to X and records the outcome locally.

## Scheduling and measurement

The cadence commands are advisory and manual. `cadence` reports what is due, `preview-next` shows the exact payload, and `post-next` is the only one of those commands that contacts X—and it does so only when explicitly invoked. Successful publication updates the existing local ledger and card status, so the next invocation advances automatically without a separate queue pointer.

X does not expose post scheduling through its public API. X Pro has a web scheduler, but X states that longer posts cannot currently be scheduled on the web.

Codex can schedule a one-off future task that invokes this local CLI. A scheduled publication must contain the already approved final text, image path, and exact time; it must not be an open-ended instruction to generate and publish content autonomously.

For later reporting, X’s post analytics API offers impressions, bookmarks, replies, quotes, profile clicks, URL clicks, and detail expands for owned posts. Analytics reporting is not yet implemented in `x.rb`.
