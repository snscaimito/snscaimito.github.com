---
layout: post
title: Don't tie Cucumber features 1:1 to stories
tags:
- en
categories:
- software_development
- atdd
- quality
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
  jabber_published: '1299858398'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1300792828";}
  _wpas_done_twitter: '1'
---
When practicing Acceptance Test Driven Development one may think that there is a one to one match between a user story and a Cucumber feature. Initially that may seem to be a good idea but you get into trouble, if you actually want to preserve some kind of paper trail.

Here is an example:

Let's assume your team numbers user stories and then creates Cucumber features that also use the story number in the file name and within the feature file. Doing so establishes a one to one relationship between story and Cucumber feature.

After a while the thing described in some initial story evolves by means of other stories. You will certainly create new Cucumber features, faithfully following your pattern, to describe the new functionality.

What about the steps you used in the initial feature?

You may find that some of these steps don't apply because they don't describe sufficiently the new functionality. So you create new steps.

Over time you will have many steps that are very similar and only differ in minor details. But they all talk about the same thing.

Because you want to maintain a "paper trail" you don't change older features, as that would break the one to one relationship to the stories they are based on.

Using a 1:1 relationship between Cucumber features and user stories and maintaining that is an anti-pattern that should be avoided. It seems to appear frequently together with UI centric features that focus on how the application is to be operated. Both lead to brittle tests that are increasingly hard to maintain.
