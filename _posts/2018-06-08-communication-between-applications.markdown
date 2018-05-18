---
layout: post
title: Communication between applications
tags:
- en
- farm-it
categories:
- software-development
---
{% include series-header.html introURL = "/2018/04/02/considerations-for-a-farm-following-the-principles-of-lean-startup.html" %}

It is likely that information maintained by one of the SCS applications is needed in the context of another one. In my case the main application wants to present a list of featured recipes on the opening page of the application.

Recipes are the responsability of the recipe application. Presenting and editing recipes should be done as much as possible by that application. If I were using a regular micro service for recipes, I were exposing an API and then the consumer application would receive data and take care of the rendering in human readable form. The drawback is that I likely will have a lot of duplication and the need to maintain old APIs for quite some time until all users of it have updated. In the long run that might turn into a challenge altough at the moment it seems to be a good idea.


{% include series-footer.html seriesTag = "farm-it" %}
