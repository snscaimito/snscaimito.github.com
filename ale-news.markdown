---
layout: special
title: Development of ALE News
---
[ALE News](http://www.ale-news.com) is a news website with user-contributed content. ALE refers to the [ALE network](http://alenetwork.eu) for collaboration of Agile & Lean thinkers and activists across Europe.

Sometime in 2012 I first started this little side project and published a first version. Unfortunately, as it always happens, I got too busy with clients and other [things](/airtravel/) and had to abandon the project for a while. 

Now I'm trying to restart it in a slightly different way. What follows are pointers to a collection of articles about how I develop the new version of ALE News using Acceptance Test-Driven Development, which happens to be what most of my clients these days want to learn.

The new version of [ALE News](http://www.ale-news.com) should not so much be a public service but instead a tool to show to potential and existing clients how one would develop a product using Acceptance Test-Driven Development (ATDD).

## Open source
The source code for this project is available at [GitHub](https://github.com/snscaimito/ale-news-atdd).

<ul>
{% for post in site.tags.ale-news-service reversed %}
	 <li>{{ post.date | date: "%d %b %Y" }} <a href="{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}
</ul>
