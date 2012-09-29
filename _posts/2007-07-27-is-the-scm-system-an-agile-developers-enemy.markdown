---
layout: post
title: Is the SCM system an agile developers' enemy?
tags:
- Software-Development
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>Tools are built using a model of the environment they are intended to work in. Waterfall'ish approaches assume that programmers write code, check it in and then changes are managed and controlled. The assumption is that all changes are inherently dangerous and need to be watched closely.</p>

<p>An agile developer works completely different. As agilists we create and change interfaces, classes and methods as we see fit while we refine our data model and the operations through constant refactoring. That sounds like a nightmare to a person used to change management - doesn't it?</p>

<p>Currently I have to use Perforce SCM and I'm starting to get annoyed by the way it works. All the files are read-only by default and you have to tell Perforce when you want to edit a file. The plugin for Eclipse seems to be doing this in background for you, but it doesn't always work. So you end up with files that stay read-only and the process of moving an interface or class to another package gets abruptly aborted. Then you have to spend some time fighting the tool until it allows you to move the compilation unit.</p>

<p>Tools should not get into a developers' way. Change management of source code is the wrong approach. You can manage changes on configuration files (say the configuration of a Cisco router), but not code that's actively being developed. So a developer should be allowed to edit, delete or move around any piece at any time. That's the way it works with Subversion.</p>

