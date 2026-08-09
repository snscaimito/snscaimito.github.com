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
ruby _tools/x.rb preview --file _tools/private-drafts/the-little-oracle-01.json
```

The preview prints the exact text, status, character count, and absolute image path. It validates the JSON and image but does not authorize, refresh a token, upload media, or publish. Codex can render the reported image path in this chat when you ask to preview a card.

Publish only after reviewing the exact copy and image:

```sh
ruby _tools/x.rb post --text 'A considered post.' --link 'https://example.com' --image image.png
```

The link is appended to the text. Images may be JPG, PNG, GIF, or WebP, up to 5 MB.

Publish an approved prepared card the same way:

```sh
ruby _tools/x.rb post --file _tools/private-drafts/the-little-oracle-01.json
```

Every successful API publication is written locally to `_tools/.x-publisher/publications.jsonl`, including its X post ID, URL, timestamp, exact text, attached image, and source card. Historical posts recovered from X are kept separately in `_tools/.x-publisher/historical-publications.jsonl`; they retain their confirmed IDs, URLs, and timestamps without pretending to be newly published. Review the combined history without contacting X:

```sh
ruby _tools/x.rb history
```

When publishing a card, the CLI first rejects anything other than a `draft` and refuses a card already present in the ledger. After X confirms publication, it appends the ledger record and updates the card with `published` status, timestamp, X post ID, and X URL. The ledger and the cards are local and Git-ignored.

The tool has been authorized and has successfully read the latest post from the configured account. A disposable test post has confirmed live text publishing, image upload, and link attachment. Long-form publishing remains to be confirmed separately.

## Long-form publishing strategy

X Premium subscribers can create native longer posts (up to 25,000 characters) with images. That is the appropriate X format for this local API workflow, subject to the account’s entitlement; the first approved long-form publication will confirm it live.

X Articles are richer and suit long-form reading, but X documents their creation through the Articles tab on x.com. No public X API endpoint for publishing Articles has been identified, so Articles are not part of this CLI workflow.

## Story distribution rule

X is a distribution mechanism for the full canonical story—not a place to publish an adaptation, teaser, summary, excerpt, or rewritten version. When distributing a site story, use a source-backed card that reads the canonical article directly.

Divide only at existing article chapter boundaries. If the article has an introduction before its first chapter, include it with the first card. Each source-backed card posts every word of the selected narrative body unaltered, in source order. The only removed material is the website's section heading, Jekyll front matter, and site-only image/lightbox markup; its image is attached to the X post separately. Do not add a title, series label, part number, link, or rewritten closing to the narrative. Add only a separate, compact footer after the narrative to identify the series through one clickable hashtag, for example `Part of #TheMouthBetweenSuns.`

The source-backed cards for *The Mouth Between Suns* and *Mobility, As Authorized* follow this rule. They are `draft`—not approved or scheduled—and are kept locally in `_tools/private-drafts/`. `preview --file <card>` displays the exact distribution payload, while `post --file <card>` sends that same payload to X and records the outcome locally.

## Scheduling and measurement

X does not expose post scheduling through its public API. X Pro has a web scheduler, but X states that longer posts cannot currently be scheduled on the web.

Codex can schedule a one-off future task that invokes this local CLI. A scheduled publication must contain the already approved final text, image path, and exact time; it must not be an open-ended instruction to generate and publish content autonomously.

For later reporting, X’s post analytics API offers impressions, bookmarks, replies, quotes, profile clicks, URL clicks, and detail expands for owned posts. Analytics reporting is not yet implemented in `x.rb`.
