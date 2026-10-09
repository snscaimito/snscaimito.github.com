# Repository Instructions

## Repository boundary

These instructions apply only to this repository and the work requested here. Nested instructions refine only their own directories. Related repositories, hosted services and available credentials do not expand the task; do not inspect or change them unless the user's request includes them. Preserve this repository's own stack, design and runtime boundaries.

Repository-specific guidance for AI assistance in this Jekyll site.

## Website Design

- Read and follow [design.md](design.md) for every layout or styling change. The site must always remain responsive across phone, tablet, and desktop widths.

## General Editing

- Preserve the author's established voice and keep edits focused on the requested change.
- Use American English spelling and vocabulary in English-language prose.
- Use file-editing tools for content changes; do not use terminal heredocs or shell text rewriting for prose or markup edits.
- Do not run Jekyll build or serve commands unless explicitly asked.
- Keep generated blog prose suitable for direct publication and avoid adding explanatory notes inside the post unless requested.

## Website Publication

- Unfinished work is an editorial publication concern, not confidential information. Drafts, outlines, planning files, and experiments may be tracked and pushed to this public repository.
- The repository remains public on GitHub Free. When the user asks to push, visibility of unfinished source in GitHub is authorized; do not require a separate approval for it or make the repository private.
- The published website must not reveal unfinished content, including draft articles, excerpts, navigation links, feeds, illustrations, and full-size image copies. Use `published: false` for unfinished posts and exclude their unpublished assets from Jekyll output. Preserve assets shared with finished, published content.
- Keep internal instructions, tooling, planning files, and test pages out of the published website. Check publication safety with `ruby _tools/check_publication.rb`; CI must also check the generated artifact before uploading it to Pages.
- Actual secrets, such as credentials, private keys, and access tokens, must remain out of both the public repository and the website. Editorial content does not become secret or confidential merely because it is unfinished or unpublished.

## X Publications

- For every X composition, queue review, or publication task, read and follow [_tools/x_publisher.md](_tools/x_publisher.md). Use `_tools/x.rb` for previewing, account checks, and posting. The two content workflows below are standing instructions for future agents.
- When composing new X posts, lead with the central claim or tension in the first two lines, then develop it through a concrete scene or consequence. Preserve the author's quiet, considered voice; do not manufacture outrage, news hooks, or bait.
- Make every installment readable without earlier parts. Establish the situation and stakes within the post; keep the series name in the existing footer instead of opening with a title or part number.
- End newly composed posts with one concrete, relevant question that readers can answer from their own experience. Make it part of the canonical copy before approval, followed by the series footer when applicable. Do not append an engagement prompt to already approved or published text.
- Compose new posts tightly around one observation. Use the image as part of the opening: when suitable, place one sharp sentence from the approved copy visibly on the image, with legible typography at feed size. Keep image prompts, captions, and alt text limited to visible subjects, actions, objects, and literal lettering; do not describe symbolism or intended audience reactions.
- Choose one audience language for each X publication. Keep translations on the blog and accessible through its language switcher. Do not publish parallel translated originals; a later language-version announcement requires its own explicit request.
- Prefer roughly three original pieces a week, leaving time for substantive replies in relevant conversations about delivery, liability, or regulation. Compose replies with one concrete scene or case and its consequence. This is an editorial preference, not a scheduler or authorization to post originals or replies.
- Treat the supplied reach and algorithm advice as an editorial hypothesis. When reviewing results, consider replies, bookmarks, profile clicks, and useful contributions alongside views, using available evidence rather than assuming distribution effects.
- For serialized X posts, use only two editorial states: discussion in the current task or a complete `queued` publication card. Keep proposed copy and image choices in the conversation until the user asks to queue them. Do not create a separate draft, review, held, or pending publication state or keep a finished post outside the queue for later review.
- Publish each installment as one standalone X post with its approved text, matching images, and series footer. Do not quote another installment, create navigation replies or a reply chain, or publish a separate series summary. Keep part numbers as queue and blog metadata. Preserve past X posts and publication records.
- Support both content workflows. **Article first:** develop the complex story in its blog article, then queue its complete chapters through `source.section` or `source.sections`. **X first:** compose complete installments in the queue's `text` field or a referenced manuscript, then compile confirmed publications into the series article. Neither workflow requires converting to the other before publication.
- Keep linked content synchronized in both directions. An article edit must update its waiting X copy, source-section mapping, and matching images; a queue edit must update its linked article chapter and images. Source-backed cards without stored `text` read the current article directly. If both `text` and `source` exist, their narrative must match; the publisher rejects divergence. Resolve it using the requested edit direction, not by silently choosing a version or dropping the source link. Append the X footer once, outside the shared narrative.
- The series lives in one blog article per language. After X confirms publication, add queue-sourced installments to that article or verify that blog-sourced installments already appear there once, then update `x_chapters` and retain the first installment's `x_post_id`, date, and URL. Link compiled queue cards to their article chapters through `source`. Use the recorded published narrative and matching images; keep waiting installments out of an article compiled from X publications. Linked unpublished copies may be revised together without making them public.
- Preserve the exact sent text in the ledger and published card. Do not rewrite past publication records when a source is edited. If X succeeds but blog synchronization is interrupted, finish the article and translations from the recorded publication without posting again. Do not report a posting task complete until both the X record and the blog's language editions agree.
- When asked to queue a post, save its complete canonical text and matching image, create the card with `status: queued`, and verify it appears in the series cadence. Queuing does not authorize publishing to X.
- Do not impose a 280-character limit on X posts. This repository's X workflow supports native long posts.
- Treat the character count shown by `_tools/x.rb preview` as informational only. Never shorten, summarize, excerpt, or otherwise rewrite canonical or user-approved copy solely to fit 280 characters.
- Shorten X copy only when the user explicitly requests an editorial shortening. Preserve the complete text and its series footer otherwise.
- Every authorized X content publication must also update its existing blog article or create one if none exists. For an ongoing series, append the newly published installment as a chapter in the same article, preserving its first-publication date, published narrative text, matching images, and X publication metadata.
- At the time of posting to X, create or update the blog article's English, German, and Spanish editions, including the new chapter in every edition and maintaining the language switcher. Translate the blog content only; publish the X post solely in its approved original language, without translating it or creating translated X posts. Complete the blog updates and translations in the same posting task before reporting completion; queueing or previewing alone does not trigger this requirement.
- After updating, verifying, and committing the website content locally, the X poster must suggest running `git push` in its completion message. Push only when the user has authorized it; if the changes have already been pushed, report that instead.

## Topic Pages

- Topics are undated collections of connected installments, stored in `_topics/` with `layout: topic`.
- Keep one topic page per language, with explicit language-switcher URLs under `/topics/`.
- Preserve published narrative, images, `x_post_id`, `x_published_at`, and `x_chapters` when converting a blog series. Redirect its former dated URLs and update linked queue source paths without rewriting sent text or ledger records.
- Append later confirmed X installments to an existing topic and all its language editions. The topic replaces the blog article for that series; do not create a duplicate dated post.
- Display topic entries newest first, below the topic summary, in every language edition. Keep source chapters and their matching `x_chapters` in chronological order so existing queue source selectors remain stable; the topic layout reverses their display order. Add each confirmed installment and its metadata at the end of the source so it appears at the top of the page.
- Place each entry's X link directly below its heading, before the narrative. Show the X logo and original posting date in the link, using that entry's `x_post_id` and `published_at`; do not place the link in a footnote or at the end of the entry. Keep the topic itself undated.
- Use `order` for homepage ordering and `published: false` for unfinished topics. Exclude their unpublished images under the same publication rules as posts.

## Blog Posts

- Blog posts live under `_posts/<year>/` and use dated filenames such as `YYYY-MM-DD-title-slug.markdown`.
- Use the existing front matter style:

```yaml
---
layout: post
title: Title Here
tags:
- en
categories:
- culture
- fiction
hashtags:
- ai
---
```

- Keep front matter lists in the same block-list style used by nearby posts.
- For an unfinished post under `_posts/`, set `published: false` in its front matter. Do not use `draft: true`; Jekyll ignores that custom field and will publish the post.
- For fiction posts, favor immersive prose over explanation. Do not introduce a full plot when the task asks only for world-building or atmosphere.
- For fiction first published to X, keep one blog entry per series, dated to its first published installment in Europe/Madrid. Preserve that filename and date as the series grows.
- Include only installments confirmed in the local publication ledgers, preserving their narrative text and matching posted images. Omit the X series footer; do not include queued installments or invent transitions, summaries, or endings.
- Append later published installments as chapters in the same entry and extend its `x_chapters` front matter with each part number, X post ID, and original publication timestamp. Keep `x_post_id` pointing to the first installment.
- Complete published chapters of an ongoing series are publishable even when more chapters are planned; do not set `published: false` solely because the series is ongoing.

## Post Images

Use the image integration pattern established by `_posts/2026/2026-05-12-open-weight-contraband.markdown`.

- Store article images in `img/<post-slug>/`.
- Store lightbox/full-size versions in `img/<post-slug>/full/`.
- If only one image size is available, use the same JPEG in both locations so the lightbox path still works.
- Insert images with this structure:

```html
<figure class="post-hero-figure">
	<a class="post-lightbox-trigger" href="/img/<post-slug>/full/<image-name>.jpeg" data-lightbox-src="/img/<post-slug>/full/<image-name>.jpeg" data-lightbox-alt="Descriptive alt text.">
		<img src="/img/<post-slug>/<image-name>.jpeg" alt="Descriptive alt text." />
	</a>
	<figcaption>Short caption. Click the image to view it full size.</figcaption>
</figure>
```

- Use meaningful alt text that describes the image, not generic labels like "hero image".
- Keep captions short and in the tone of the article.
- Place the first image near the beginning of the post, after the opening paragraph or first setup beat.

## Local delivery rules

- Default to this repository's trunk, `master`. Do not switch an existing checkout's branch as a side effect of unrelated work.
- Do not create branches or pull requests unless the user explicitly asks.
- After completing an authorized repository change and passing its relevant verification, create a local commit before reporting completion; do not wait for a separate commit request.
- Keep commits local until pushing is authorized. When asked to push, commit verified outstanding changes and push `master` directly unless the user requests a different workflow; follow any more specific deployment authorization documented here.
- The delivery unit is this repository's complete tested working tree. Do not selectively stage files or hunks, cherry-pick a subset, or commit/push only part of the state that was verified. If unrelated or concurrent changes make complete delivery unsafe, stop and ask before testing or committing.
- For deployments owned by this repository, use its documented deployment path and validated, committed primary `master` checkout; never deploy from detached HEAD or a temporary worktree. Preserve any CI-owned deployment boundary.
- Select verification for the affected files and runtime. Documentation/instruction-only edits require text, link and `git diff --check` validation, not application compilation or tests solely for prose changes.
- Before pushing executable changes, run the required suites for the affected runtime against the complete delivery state. Reuse passing checks while their code, tests and executable configuration are unchanged; committing or elapsed time alone does not invalidate them.
- For complete, verified GitHub issue work, use a clear imperative commit subject and a real closing footer such as `Fixes #123`. Only an explicitly requested incomplete checkpoint uses a non-closing reference. Do not close a parent issue while its own scope or child issues remain unfinished.
- Use real newlines in commit messages. A closing footer in a local commit does not authorize pushing.

## Layout scope

- For HTML/CSS work in this repository, prefer flexbox and layouts that adapt to viewport width unless a technical constraint requires otherwise. Preserve this project's existing framework, styling system and design; this preference does not authorize introducing another project's UI stack.
