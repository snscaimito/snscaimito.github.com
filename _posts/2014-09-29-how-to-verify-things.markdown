---
layout: post
title: How to verify things
tags:
- en
- ale-news-service
categories:
- ATDD
- Software-Development
---
ATDD stands for Acceptance Test-Driven Development. If you will, it is some sort of outside-in TDD, which is test-driven development on the inside of software. With TDD we want to describe the behavior of the inner building blocks of software. Those building blocks in an object-oriented language would be the classes. With ATDD we want to describe the behavior of the software as a whole. It is about describing, in terms of observable behavior, what the software will do in reaction to eg. external events.

Let's have a look at the following scenario:

```gherkin
Scenario: Create new article metadata
When I submit the following article metadata
  | Author         | Title                                            | location                                                                                                     |
  | Stephan Schwab | From competition it is a big leap to cooperation | http://www.stephan-schwab.com/china/culture/management/thoughts/2014/08/30/collaboration-or-cooperation.html |
Then I see a list of articles
```

Submitting article metadata is certainly an external event. I'm not describing how metadata is submitted - I only mention the fact that it is submitted. So that is good, as I'm not giving away details of the implementation or prescribing the implementation in any way.

*A specification is not the same as a blueprint. With a specification we don't want to prescribe how an implementor has to solve the given problem.*

The *Then* step, however, may go a bit too far.

{% include ale-news-post-header.html %}

If I look at it very closely, then I see an imperative description of the user interface. *I see a list of articles* means that the software will show me a list. So that kind of describes that, first, there will be a form to fill out - the submission in the first step - and, second, a list will be printed on the screen.

Maybe that's a bit too much?

For the article service a similar scenario was this:

```gherkin
Scenario: Create new article metadata
	When I post the following article metadata to the article service with URI "/article"
		| Author         | Title                                            | location                                                                                                     |
		| Stephan Schwab | From competition it is a big leap to cooperation | http://www.stephan-schwab.com/china/culture/management/thoughts/2014/08/30/collaboration-or-cooperation.html |
	Then an article ID is returned
	And the article metadata has been stored in the archive
```

That was for a piece of software that does not have a human computer interface (HCI) but instead communicates machine to machine.

For the article service returning the article ID is important, because RESTful services are expected to return a reference to the newly created resource. In the case of HCI the article ID is certainly irrelevant, because humans don't care about an ID.

So maybe the scenario for submitting new article metadata through the web client should read like the following?

```gherkin
Scenario: Create new article metadata
When I submit the following article metadata
  | Author         | Title                                            | location                                                                                                     |
  | Stephan Schwab | From competition it is a big leap to cooperation | http://www.stephan-schwab.com/china/culture/management/thoughts/2014/08/30/collaboration-or-cooperation.html |
Then the article metadata has been stored in the archive
```

How can we find out from the outside that the article metadata has been stored? We can use the article service. It allows us to query for a specific article. For that we will need to know the ID. Or it can list all articles that are currently stored and then we will have to search for the one we are interested in.

Let's try the latter:

```java
@Then("^the article metadata has been stored in the archive$")
public void the_article_metadata_has_been_stored_in_the_archive() throws Throwable {
    GenericType<List<ArticleMetadata>> articleListType = new GenericType<List<ArticleMetadata>>() {};

    List<ArticleMetadata> actualArticles = ClientBuilder.newClient()
            .target("http://localhost:8080/article-service").path("/article")
            .request(MediaType.APPLICATION_JSON).get(articleListType) ;

    assertThat(actualArticles.size(), is(not(0))) ;
}
```

That seems to work. I have removed the log messages from PhantomJS for clarity.

	-------------------------------------------------------
	 T E S T S
	-------------------------------------------------------
	Running net.caimito.ale_news.web_client.RunCukesIntegrationTest
	Feature: Article metadata archive

	  Scenario: Create new article metadata                      # net/caimito/ale_news/web_client/articles.feature:3
	    When I submit the following article metadata             # StepDefinitions.i_submit_the_following_article_metadata(ArticleMetadata>)
	    Then the article metadata has been stored in the archive # StepDefinitions.the_article_metadata_has_been_stored_in_the_archive()

	  Scenario: List articles         # net/caimito/ale_news/web_client/articles.feature:9
	    When I open ALE News          # StepDefinitions.i_open_ALE_News()
	    Then I see a list of articles # StepDefinitions.i_see_a_list_of_articles()

	2 Scenarios (2 passed)
	4 Steps (4 passed)
	0m5.466s

	Tests run: 6, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 5.875 sec - in net.caimito.ale_news.web_client.RunCukesIntegrationTest

	Results :

	Tests run: 6, Failures: 0, Errors: 0, Skipped: 0

## Conclusion
There are basically two options for verification:

* look up behind the scenes (database, service call, etc.)
* verify through user interface

At the moment I have chosen to look up things behind the scenes. That gets me around the issue of imperatively describing how the application behaves in terms of human computer interaction.

However, at a later point I certainly will have to describe a bit of the user interface behavior. But then it's another story. I will come back to this.

{% include ale-news-post-footer.html %}
