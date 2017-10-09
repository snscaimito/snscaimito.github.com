---
layout: post
title: Scenarios that depend on each other are bad
tags:
- en
- ale-news-service
categories:
- atdd
- software-development
---
For the web client I originally created this specification for the *Interact with article metadata archive* feature:

```gherkin
Feature: Interact with article metadata archive

  Scenario: Create new article metadata
    When I submit the following article metadata
      | Author         | Title                                            | location                                                                                                     |
      | Stephan Schwab | From competition it is a big leap to cooperation | http://www.stephan-schwab.com/china/culture/management/thoughts/2014/08/30/collaboration-or-cooperation.html |
    Then the article metadata has been stored in the archive

  Scenario: List articles
    When I open ALE News
    Then I see a list of articles
```

Unfortunately at the moment I've managed to create a situation where scenarios depend on each other.

## The known state of the system
For each scenario the state of the system should be known. If it happens to use a database, then that known state of the system should be an empty database or a database with known content.

{% include ale-news-post-header.html %}

In the article service I have not yet hooked up a database but the simple array list does act as one. So I need to find a way to make sure that it is empty or has known content when I run a scenario.

The simplest solution for that seems to be:

```gherkin
  Background:
    Given there are no articles in the archive
```

I can implement that step by calling the article service with the HTTP verb DELETE for every article that it contains. I get the list of articles by using GET on the main resource /article.

With that background step the scenario *Create new article metadata* is now right but the second one *List articles* will fail.

The solution for now is to modify the second scenario.

```gherkin
Feature: Interact with article metadata archive

  Background:
    Given there are no articles in the archive

  Scenario: Create new article metadata
    When I submit the following article metadata
      | Author         | Title                                            | location                                                                                                     |
      | Stephan Schwab | From competition it is a big leap to cooperation | http://www.stephan-schwab.com/china/culture/management/thoughts/2014/08/30/collaboration-or-cooperation.html |
    Then the article metadata has been stored in the archive

  Scenario: List articles
    When I submit the following article metadata
      | Author         | Title                                            | location                                                                                                     |
      | Stephan Schwab | From competition it is a big leap to cooperation | http://www.stephan-schwab.com/china/culture/management/thoughts/2014/08/30/collaboration-or-cooperation.html |
    And I open ALE News
    Then I see a list of articles
```

With that out of the way I have a clean build again:

	[INFO] ------------------------------------------------------------------------
	[INFO] Reactor Summary:
	[INFO] 
	[INFO] ALE News ........................................... SUCCESS [  0.326 s]
	[INFO] common ............................................. SUCCESS [  1.481 s]
	[INFO] ALE News Article Service Webapp .................... SUCCESS [ 43.168 s]
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD SUCCESS
	[INFO] ------------------------------------------------------------------------
	[INFO] Total time: 45.121 s
	[INFO] Finished at: 2014-10-14T13:38:28+08:00
	[INFO] Final Memory: 85M/646M
	[INFO] ------------------------------------------------------------------------

I should probably rename the article-service module in the Maven project, because it now contains the service as well as the web client code. But I'm holding off on that for now, because there might be a way to separate the two again. I really don't want to couple the service and the web client. That goes against the whole idea behind it. But it is not my highest priority at the moment.

## A more interesting client
As I was saying earlier, I don't expect the web client to be the main means of adding articles to the archive. Personally I read a lot of web content on my iPhone and iPad. What I use depends on the situation but it is almost always that I read on a mobile device.

I've started to explore the new IOS share extension API and will have to learn a bit more about the current IOS 8 development environment and brush up on my Objective-C knowledge. I will report soon how that goes...

{% include ale-news-post-footer.html %}
