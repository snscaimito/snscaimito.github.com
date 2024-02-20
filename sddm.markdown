---
layout: special
title: Software Development Decision Making
---
In a [blog post about Aeronautical Decision Making (ADM)](/2014/11/30/aeronautical-decision-making-for-software-developers.html) I discovered that the 3P technique used in ADM is similar to what Dave Snowden teaches us with the [Cynefin](http://en.wikipedia.org/Cynefin) model. Subsequently I started to explore what software developers can learn from the aviation industry and named my own effort *Software Development Decision Making*.

<table>
{% for post in site.tags.SDDM reversed %}
<tr>
	<td>{{ post.date | date: "%d %b %Y" }}</td>
	<td><a href="{{ post.url }}">{{ post.title }}</a></td>
</tr>
{% endfor %}
</table>
