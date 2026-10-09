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
ruby _tools/x.rb post --text 'A considered post.' --link 'https://example.com' --image image-1.png --image image-2.png --dry-run
```

Preview a prepared publication card without contacting X:

```sh
ruby _tools/x.rb preview --file _tools/publication-queue/the-little-oracle-01.json
```

The preview prints the exact text, its source, status, character count, and absolute image paths. Every series installment is a standalone post. The character count is informational: do not impose a 280-character limit or shorten copy to meet one. This workflow supports native long posts, and canonical or user-approved text must remain complete unless the user explicitly requests editorial shortening. The preview validates the JSON and images but does not authorize, refresh a token, upload media, or publish. Codex can render the reported image paths in this chat when you ask to preview a card.

Review the manual cadence and its recommended next installment without contacting X:

```sh
ruby _tools/x.rb cadence
ruby _tools/x.rb cadence --series 'The Mouth Between Suns'
ruby _tools/x.rb preview-next
ruby _tools/x.rb preview-next --series 'The Mouth Between Suns'
```

The recommendation considers only final `queued` cards, continues each series in part order, and mixes topics by preferring the started series that has waited longest. A series that has not started becomes eligible after no started series has a publishable next card. This is a manual recommendation only; it does not impose a publication window or schedule posts. It is calculated when the command runs; there is no scheduler, daemon, polling process, or background publication.

Publish only after reviewing the exact copy and image:

```sh
ruby _tools/x.rb post --text 'A considered post.' --link 'https://example.com' --image image-1.png --image image-2.png
```

The link is appended to the text. Images may be JPG, PNG, GIF, or WebP, up to 5 MB each. Repeat `--image` to attach up to four photos. An animated GIF must be the only attachment.

Prepared cards remain backward-compatible with the singular `"image"` field. For multiple photos, use an ordered `"images"` array containing one to four repository-relative paths. The publisher uploads every image and sends the returned IDs together in `media.media_ids`.

A text-only prepared card may omit both image fields. For a separately approved reply outside a series, set `"reply_to_card_id"` to the parent card's ID. The publisher resolves the parent's recorded X post ID, sends it through `reply.in_reply_to_tweet_id`, records the relationship, and refuses to publish when the parent has no local publication record. Series cards ignore legacy reply and quote metadata and always publish as standalone installments.

The final chapter follows the same publication path as every other installment. `"series_end": true` may identify it in metadata, but no opener, navigation reply, or summary card is required. Legacy `series_summary` cards are excluded from cadence and rejected for publication. Remove obsolete queued summary cards instead of publishing them.

Publish an approved prepared card the same way:

```sh
ruby _tools/x.rb post --file _tools/publication-queue/the-little-oracle-01.json
```

Publish the recommended next installment only in response to an explicit request:

```sh
ruby _tools/x.rb post-next
ruby _tools/x.rb post-next --series 'Bread and Games'
```

`post-next` publishes the recommended queued installment whenever explicitly invoked. The recommendation does not delay publication; queue-status and duplicate-publication safeguards remain in force.

Every successful API publication is written locally to `_tools/.x-publisher/publications.jsonl`, including its X post ID, URL, timestamp, exact sent text, narrative without the footer, attached images, source card, source selection, and series/part metadata. Historical posts recovered from X are kept separately in `_tools/.x-publisher/historical-publications.jsonl`; they retain their confirmed IDs, URLs, timestamps, and any old quote or reply relationships without pretending to be newly published. Review the combined history without contacting X:

```sh
ruby _tools/x.rb history
```

Successful content publications also regenerate the tracked, public-safe `_data/x_publications.json` export used by the unlinked `/x-publications/` Jekyll page. The export contains series names, short post excerpts, post IDs, canonical account-qualified X URLs (`https://x.com/<account>/status/<id>`), publication timestamps, publication kinds, and public image paths; it never exposes complete post text, local paths, or Article content state. The account-qualified form lets X recognize a pasted link as a post and render its preview. Series-root navigation replies are excluded. Images already under `img/` are reused directly; originals elsewhere are copied unchanged to `img/x-publications/` so Jekyll can display them.

When publishing a card, the CLI first rejects anything other than `queued` and refuses a card already present in the ledger. After X confirms publication, it appends the ledger record and updates the card with `published` status, timestamp, X post ID, X URL, `published_text`, and `narrative_text`. It preserves the original queue text or source selector. Later previews use the frozen published text, even if the source changes or disappears. A previously published card with an old pending navigation reply cannot publish or retry that reply. The ledger and the queue are local and Git-ignored.

The tool has been authorized and has successfully read the latest post from the configured account. Live use has confirmed regular text publishing, image upload, native longer posts, and Article draft/publish flow with embedded Article images. Article publication remains a separate, explicit command.

## Publishing format decision

Use native longer posts for a serialized story. Publish only the installment itself as an independent top-level post. The blog article holds the complete series and grows as installments are published. No X quote chain, navigation reply, or final summary accompanies an installment.

Use an X Article for a complete standalone story or essay that benefits from rich layout, a cover, and inline images. Do not use Articles for a chapter-by-chapter serial: the Articles API cannot make a published Article announcement quote its predecessor, update a published Article body, or add forward navigation after a later chapter exists.

This is a publication-format choice made for each approved work. It does not change the existing regular-post workflow or automatically convert any queued story.

## X Articles

X Articles are an opt-in extension to the existing post/card workflow. They do not affect `post`, `preview`, cadence, or standalone installments. Invoke the Article command only for a specifically approved standalone publication.

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

## Composing new X posts

Establish the central claim or tension in the first two or three sentences, then develop it through a concrete scene and consequence. A story should begin inside the predicament, with enough context to recognize what is at stake. Do not open with a summary of the lesson or outcome. Keep the author's quiet, considered voice without flattening the character's feelings. Do not manufacture outrage, news hooks, or bait.

Each installment must work for someone encountering the series for the first time. Establish its situation and stakes within the copy, and put the series name in the existing plain-language footer. End newly composed copy with one specific question that readers can answer from their own work, such as “What did the approval actually reduce?” Place it before the footer and approve it as part of the canonical text.

Compose tightly around one observation. Choose an image that carries the same concrete situation; when suitable, put one sharp sentence from the approved copy visibly on it. Check that the lettering remains legible at feed size. Image prompts describe visible composition and literal lettering only; captions and alt text describe visible content, including relevant text, without symbolism or instructions about audience reactions. Concision is a composition choice, not a character-limit check: native long posts remain supported.

Choose the audience language for that publication and publish the original once. Keep English, German, and Spanish versions on the blog with the language switcher. Do not create parallel translated X originals. A later announcement pointing to a language version is a separate publication requiring an explicit request.

Prefer roughly three original pieces a week, with time for substantive replies in relevant conversations about delivery, liability, or regulation. A useful reply contributes one concrete scene or case and its consequence. This editorial preference does not change the CLI's manual cadence, enforce a weekly quota, schedule anything, or authorize public replies.

Use these rules while creating new canonical copy. Existing approved cards and published source text remain intact; revising them requires an explicit editorial request. The publisher distributes the approved package without adding a hook, question, or text overlay during publication. A shorter new post can still be a complete canonical installment.

Treat the supplied claims about reach and algorithm behavior as hypotheses, not verified account analytics. When reviewing results, consider replies, bookmarks, profile clicks, and useful reader contributions alongside views, using available evidence. Do not claim that these changes guarantee wider distribution.

### First-person stories grounded in real rules

These instructions apply to fictional narrative installments, including the tax and company-law series. They do not require ordinary announcements or factual commentary to impersonate a character.

- Write from inside the participant's experience: what I want, assume, notice, resist, fear, and decide. First-person pronouns alone do not turn an explanatory report into a story. Let inner thoughts and natural dialogue carry the discovery.
- Make the opening immediately relevant to the intended reader's own working life. Introduce a specific conflict and a question the scene will develop. A famous name can enter through conversation, but the next sentences must connect it to the narrator's stakes. Fulfill the opening's promise within the post.
- Give the narrator competence, desires, and something concrete to protect. A challenged assumption about independence, earnings, family, or work can carry the emotion. Do not substitute obligatory poverty, tears, bodily symptoms, or self-reproach for a developed conflict.
- Build around one consequential discovery. Let research determine what can actually happen, then show the person interpreting and responding to it. A friend should sound like a friend, not a legal reference page. Keep the larger “Why?” alive through what the character cannot reconcile.
- Use connected paragraphs and varied sentence lengths. Do not put every sentence on its own line or disguise a string of disconnected dramatic fragments as a paragraph. Details should change how we understand the person's predicament.
- Keep character belief, fear, and verified rules distinct. A feared assessment is not an established debt or investigation. A celebrity's dispute does not prove another person's liability. Fictional dialogue and social-media encounters are scenes, not evidence about population-wide behavior; retain the fictional framing in the series presentation.
- Give the scene a meaningful turn or consequence before the closing question. Aim for recognition that makes a reader think of their own situation or someone they know. Ask one concrete question about relevant experience; avoid generic vulnerability prompts and requests for likes or reposts.
- Keep research citations in the planning record and eventual host page when the requested X copy contains no links. Do not turn the narrative into a source summary or append an explanatory moral.

### Reach as an editorial test

Write for a relevant reader to recognize the situation, continue reading, and have a reason to share it or contribute an experience. These are editorial aims to evaluate, not guaranteed algorithm effects. First-person narration, a closing question, emotional intensity, and length do not independently establish a reach advantage. Inspect the opening in its likely feed context, but do not assume a fixed preview cutoff or shorten the complete post to 280 characters.

The [public X recommendation code](https://github.com/xai-org/x-algorithm) describes personalized ranking using predicted reader actions, including reading time, replies, and sharing, alongside negative feedback. Its weights are not exchange rates between actual likes and replies, and published code does not establish an account's live configuration. [X view counts](https://help.x.com/en/using-x/view-counts) can include repeat views and the author's own views; they do not establish unique readers or completion. Keep account observations separate from assumptions about why distribution changed. These sources were reviewed on October 9, 2026; recheck them before making new platform claims.

## Story distribution rule

For serialized X posts, there are only two editorial states: discussion in the current task and a complete `queued` card. Keep proposed text and image choices in the conversation until the user asks to queue the post. Do not create a separate draft, review, held, or pending publication state, or leave a finished publication package outside the queue. When asked to queue, save the full canonical text and matching images in a text-backed or source-backed `queued` card, then run `preview --file` and `cadence --series` to confirm that the card is publishable and visible. A queued card is ready for a later explicit publication request; it is not permission to post now. This rule concerns serialized X posts; the separate X Articles API has its own draft operation.

X distributes the full canonical installment. The canonical copy may come from a blog article or from the posting queue; neither source authorizes an adaptation, teaser, summary, excerpt, or rewritten version.

### Choosing the canonical source

For a blog-sourced installment, omit `text` and select the article's chapter through `source.section` or an ordered `source.sections` array. Section 0 is the introduction before the first `##` heading; later numbers identify chapters. Include `[0, 1]` when the first installment needs both the introduction and first chapter. A source may also reference a repository-owned manuscript while the published blog series is still growing.

```json
{
  "id": "the-certainty-index-06",
  "status": "queued",
  "series": "The Certainty Index",
  "part": 6,
  "source": {
    "file": "_posts/2026/2026-08-26-the-certainty-index.markdown",
    "section": 6
  },
  "image": "img/the-certainty-index/the-certainty-index-scene-06-the-unpaved-step.jpeg",
  "footer": "The Certainty Index — a serialized story."
}
```

For a queue-sourced installment, put the complete approved narrative in `text`, without the series footer. Use the same image and series metadata. No blog article has to exist before posting.

```json
{
  "id": "example-series-01",
  "status": "queued",
  "series": "Example Series",
  "part": 1,
  "text": "The complete approved installment.",
  "image": "img/example-series/scene-01.png",
  "footer": "Example Series — a serialized story."
}
```

If both `text` and `source` are present, the queue narrative and selected source narrative must match, apart from trailing whitespace and the existing removal of site-only material. The publisher rejects mismatches before accessing X. Resolve a mismatch using the user's requested edit direction; do not silently choose one copy, remove the source link, or publish stale text. `preview` and `post --dry-run` report `queue`, `blog`, or `source_file` so the selected source is visible before publication. Keep an approved package intact when changing its storage; verify the complete text and matching images again.

### Article-first and X-first work

These are standing workflows for every agent working in this repository. Read the card, its linked source, and the publication ledger before editing or posting. Identify the workflow from those files; the user does not need to explain it again.

**Article first:** work on the complex story in its blog article. Keep unfinished articles unpublished under the website safety rules. When asked to queue, select complete chapters through `source.section` or `source.sections` and attach their matching images. An article revision flows into source-backed cards directly; update any stored queue copy, image paths, and section selectors affected by the edit. After each confirmed X publication, update that chapter's X metadata in the article and its language editions without duplicating the narrative.

**X first:** work on complete installments in queue cards or referenced manuscripts. Before a corresponding article chapter exists, the queue is the source. After publication, compile the ledger's narrative and matching images into one article per series and language. Add the saved card's `source` selector for the corresponding original-language chapter so later agents can find both copies. Keep waiting installments out of the public article; synchronize linked unpublished copies while they are being edited.

**Edits in either direction:** apply the requested narrative or image change to both linked copies. An article edit updates waiting cards; a queue edit updates its linked chapter. Check chapter order and source selectors after moving or adding headings. Keep the X footer outside the blog narrative. When the source article exists, a card with both `text` and `source` is ready only when both contain the same narrative and use the matching images. Do not automatically shorten, translate, or otherwise rewrite the approved X copy while synchronizing it.

**After publication:** the exact sent text and historical records remain fixed. Use `published_text` and the ledger's `narrative_text` to complete or recover the blog update. A later source edit does not change what was posted. A posting task is complete only after the corresponding article, chapter metadata, images, and English, German, and Spanish editions have been checked and committed locally. Resume an interrupted blog update from the ledger; never repost the installment to repair the blog.

Divide only at existing article chapter or scene boundaries. If the article has an introduction before its first chapter, include it with the first card. Each source-backed card posts every word of the selected narrative body unaltered, in source order, including any opening claim or closing question approved as part of that body. The only removed material is the website's section heading, Jekyll front matter, and site-only image/lightbox markup. Do not add a title, series label, part number, link, or rewritten closing to the narrative during distribution.

Every prepared story post is a three-part publication package: the complete canonical chapter or scene text as written, its matching image, and a separate plain-language footer in the exact form `<Series Title> — a serialized story.` For example: `The Mouth Between Suns — a serialized story.` Do not use hashtags; they no longer serve as the series identifier. The footer is part of the package, not part of the story text. A footer never makes a summary, excerpt, adaptation, or rewritten scene acceptable.

## Blog synchronization and translation

Some connected series live on undated topic pages in `_topics/` with `layout: topic`, such as Who Can Afford to Take a Risk? For those series, the existing topic replaces the dated blog article throughout this workflow. Append confirmed installments and update all three topic language editions, images, and `x_chapters`; preserve `x_post_id` and `x_published_at`. Do not create a duplicate blog post or add a page date. Source-backed cards may select chapters from `_topics/` exactly as from `_posts/`; previews identify these as `topic`. When converting or renaming a topic, update linked card source paths and preserve the frozen sent text and ledger history, including its original `x_series` identity. Keep former dated and topic URLs as redirects.

Topic pages display the latest confirmed installment at the top, below the summary, in every language edition. Keep chapters and their matching `x_chapters` in chronological source order and append new confirmed entries to both; the topic layout renders them newest first while preserving existing queue section selectors. Each entry links to its own X post directly below its heading, before the narrative, with the X logo and its recorded posting date. Use that entry's `x_post_id` and `published_at`; do not use a footnote or an end-of-entry link. The topic itself remains undated.

Every authorized X content publication includes updating its existing blog article or creating one if no corresponding article exists. This applies when actually posting to X, not merely queueing or previewing. An existing article must contain the published content once and have current X publication metadata; do not create duplicate articles or chapters.

For fiction first published to X, use one blog entry per series, dated to the first published installment in Europe/Madrid. After X confirms publication, use the ledger's `narrative_text`, images, post ID, and timestamp to add the installment as the next chapter and extend `x_chapters`. Keep the article's original filename and date, and keep `x_post_id` pointing to the first installment. Preserve the published narrative verbatim, omit the X series footer, and add no unpublished installments, transitions, summaries, or endings. For older records without `narrative_text`, recover the recorded text and remove only its known series footer.

For a queue-sourced installment, create the series article if needed or append to the existing article. For a blog-sourced installment, verify the selected chapter already appears once and update its X metadata; do not append a duplicate. The published ledger is the record of what was sent. Blog synchronization and translation remain required work in the posting task; the Ruby CLI records the publication but does not generate blog prose or translations.

At the time of posting, create or update the blog article's English, German, and Spanish editions. Translate the newly published chapter into every other blog language, preserving its meaning, chapter order, and matching images; translate image descriptions and captions and maintain the language-switcher metadata and links. For an existing complete article, verify that all three blog editions already contain the corresponding chapter and update them where needed. Keep the original article URL stable and use explicit translation URLs when its canonical language is not English.

Translate the blog post only. The X post stays in its approved original language and is published once; do not translate its copy or publish translated versions on X. The posting task is complete only after the corresponding blog updates and translations have been verified and committed locally under the repository workflow. If X publication succeeds but a blog update is interrupted, resume from the recorded publication instead of posting to X again. A request to post to X does not by itself authorize pushing or deploying the blog changes.

After updating, verifying, and committing the website content locally, suggest running `git push` in the completion message so the website updates can be published. Push only when the user has authorized it. If the changes have already been pushed, report that instead of suggesting another push.

## Standalone installments and the blog series

Every installment, including the first and last, creates one standalone X post. Its request contains the approved text and attached media only. It does not quote part 1, reply to another post, publish a navigation reply, or require a recorded opener. Part numbers control the queue's reading order and the blog's chapter metadata.

The blog article is the series archive. Update it after each confirmed publication and keep its language editions aligned. If the blog update is interrupted, finish it from the ledger without reposting the installment.

Existing X posts, old quote relationships, navigation replies, and historical ledger entries remain unchanged. Queued cards with legacy chain fields are published without those relationships. Already published cards are rejected, including cards with `series_root_reply_status: pending`; the publisher no longer retries navigation replies.

Final unpublished packages remain `queued` in `_tools/publication-queue/` for an explicit publication decision. `preview --file <card>` displays the exact payload, while `post --file <card>` sends that payload to X and records the outcome locally. Cadence considers installments only; old navigation replies and summaries do not affect the recommendation.

## Scheduling and measurement

The recommendation commands are advisory and manual. `cadence` reports which queued installment is recommended next, `preview-next` shows the exact payload, and `post-next` is the only one of those commands that contacts X—and it does so only when explicitly invoked. No publication window is enforced. Successful publication updates the existing local ledger and card status, so the next invocation advances automatically without a separate queue pointer.

X does not expose post scheduling through its public API. X Pro has a web scheduler, but X states that longer posts cannot currently be scheduled on the web.

Codex can schedule a one-off future task that invokes this local CLI. A scheduled publication must contain the already approved final text, image path, and exact time; it must not be an open-ended instruction to generate and publish content autonomously.

For later reporting, X’s post analytics API offers impressions, bookmarks, replies, quotes, profile clicks, URL clicks, and detail expands for owned posts. Analytics reporting is not yet implemented in `x.rb`.
