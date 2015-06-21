---
layout: special
title: Quality
---
According to the dictionary quality is either

> the standard of something as measured against other things of a similar kind

or

> the degree of excellence of something

In software development we don't mass produce objects. Therefore it is more likely that the second definition of quality applies to our work.

<table>
{% for post in site.categories.quality %}
<tr style="vertical-align: top">
	<td nowrap>{{ post.date | date: "%d %b %Y" }}</td>
	<td><a href="{{ post.url }}">{{ post.title }}</a></td>
</tr>
{% endfor %}
</table>
