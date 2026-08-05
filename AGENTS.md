# Repository Instructions

Repository-specific guidance for AI assistance in this Jekyll site.

## General Editing

- Preserve the author's established voice and keep edits focused on the requested change.
- Use American English spelling and vocabulary in English-language prose.
- Use file-editing tools for content changes; do not use terminal heredocs or shell text rewriting for prose or markup edits.
- Do not run Jekyll build or serve commands unless explicitly asked.
- Keep generated blog prose suitable for direct publication and avoid adding explanatory notes inside the post unless requested.

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
