---
layout: special
title: Quality
---
According to the dictionary quality is either

> the standard of something as measured against other things of a similar kind

or

> the degree of excellence of something

In software development we don't mass produce objects. Therefore it is more likely that the second definition of quality applies to our work.

{% assign posts = "" | split: "" %}
{% for post in site.posts %}
    {% if post.categories contains 'Quality' %}
		{% assign posts = posts | push: post %}
    {% endif %}
    {% if post.categories contains 'quality' %}
		{% assign posts = posts | push: post %}
    {% endif %}
{% endfor %}

<table>
{% for post in posts %}
<tr style="vertical-align: top">
	<td nowrap>{{ post.date | date: "%d %b %Y" }}</td>
	<td><a href="{{ post.url }}">{{ post.title }}</a></td>
</tr>
{% endfor %}
</table>
