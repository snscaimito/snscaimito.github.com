---
layout: special
title: Living and working in Panama
---
In 2006 my wife and I obtained permanent residency in the Republic of Panama. We moved there from Florida in the U.S. after living there for about two years.

The general population in Panama speaks Spanish. That's the same language we mostly use at home due to the fact that my wife is Colombian. The Spanish language lends itself to talk about fun and family topics.

In Panama an international couple turned into a small family with another international member: our daughter was born in Panama City and is growing up in a multi-cultural and multi-lingual environment.

<table>
{% for post in site.categories.panama reversed %}
<tr>
	<td>{{ post.date | date: "%d %b %Y" }}</td>
	<td><a href="{{ post.url }}">{{ post.title }}</a></td>
</tr>
{% endfor %}
</table>
