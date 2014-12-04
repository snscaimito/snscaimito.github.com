---
layout: special
title: Horses
---
While I was living in the country side in [Panama](/panama.html) and [USA](/usa.html) I had a few horses and learnt quite a lot from these interesting creatures.

The following articles tell the stories.

<table>
{% for post in site.tags.Horses %}
<tr>
	<td>{{ post.date | date: "%d %b %Y" }}</td>
	<td><a href="{{ post.url }}">{{ post.title }}</a></td>
</tr>
{% endfor %}
</table>
