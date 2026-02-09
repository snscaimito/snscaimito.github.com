---
layout: special
title: Germany
---
On December 15 in the year 1967 I was born in Kassel. There I grew up and went to school. Later I went to University in Dortmund.

In 1989 two friends and I formed a company called Softstream Development in Dortmund. We created *Convince*, an illustration and presentation graphics program, and a software technology we called *DEO (Documents of Embedded Objects)* in C/C++ on Windows 3.0 that is a little bit comparable to OLE 2 from Microsoft. Our product knew a container application with software components running inside. Available software components were a spreadsheet, illustration graphics, presentation graphics and a word-processing component from a third party.

By 1993 my interest had shifted a bit towards networks and eventually a new Internet Service Provider started to offer Internet access in Dortmund and Heidelberg. Later that business grew and eventually I moved to Heidelberg.

Between 1999 and 2003 I lived in Frankfurt where I served as the CEO of DINX, another Internet Service Provider I founded.

<table>
{% for post in site.categories.germany %}
<tr>
	<td>{{ post.date | date: "%d %b %Y" }}</td>
	<td><a href="{{ post.url }}">{{ post.title }}</a></td>
</tr>
{% endfor %}
</table>
