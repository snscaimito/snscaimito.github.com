---
layout: post
title: First draft of the article service
tags:
- en
- ale-news-service
categories:
- ATDD
- Software-Development
---
This blog post is part of a series about the development of ALE News using an approach to software development called Acceptance Test-Driven Development. <a href="/ale-news.html">For an overview please see the introductory article</a>.

## Strict separation between client and server
Unlike in the past I wanted to use a modern web application architecture. The server should not be concerned with any presentation duties. That means: no HTML will be created on the server. Instead there will be a server application exposing RESTful web services and the actual website will be rendered in the browser - being a pure client consuming the services from the server.

I want to start with a service that allows CRUD operations onto an archive for article metadata.

## Preliminary description
Before going deep it makes sense to gain a rough overview of the task at hand. What follows is an overview of the planned service to access the archive for article metadata.

	Feature: CRUD and list scooped articles
		Scenario: Create new article metadata
		Scenario: Read article metadata
		Scenario: Update article metadata
		Scenario: Delete article metadata
		Scenario: List article metadata

With that feature description I outlined **what** my service is going to do.

## Creating new article metadata
With that in place I was talking to my self and came up with the following, more detailed, scenario for creating a new entry in the metadata archive.

RESTful web services use HTTP verbs to perform actions onto a resource. A good overview is available at [Wikipedia](http://en.wikipedia.org/wiki/Representational_State_Transfer). To create a new item one sends a POST request to the web service and the service should then return some ID for the newly created item.

```gherkin

	Scenario: Create new article metadata
		When I post the following article metadata to the article service with URI "/article"
			| Author         | Title                                            | location                                                                                                     |
			| Stephan Schwab | From competition it is a big leap to cooperation | http://www.stephan-schwab.com/china/culture/management/thoughts/2014/08/30/collaboration-or-cooperation.html |
		Then an article ID is returned
		And the article metadata has been stored in the archive
```

## Different views about the WHAT and HOW
I would have written this scenario in a slightly different way:

```gherkin

	Scenario: Create new article metadata
		When I post the following article metadata to the article service
			| Author         | Title                                            | location                                                                                                     |
			| Stephan Schwab | From competition it is a big leap to cooperation | http://www.stephan-schwab.com/china/culture/management/thoughts/2014/08/30/collaboration-or-cooperation.html |
		Then an article ID is returned
		And the article metadata has been stored in the archive
```

The second version is more about **WHAT** the service does and does not give away and details about how to **use** the service. However, when working with a group of developers earlier this year in Berlin I learned that sometimes giving away a little hint isn't that bad. Those developers wanted to have their scenarios express how to use the service so that the scenarios can be used as some sort of user documentation for those consuming the service. I think that makes sense.

Then I created the necessary boilerplate for [Cucumber JVM](https://github.com/cucumber/cucumber-jvm) and provided step definitions for the first two steps of my scenario - just enough to get started.

```java

	@When("^I post the following article metadata to the article service with URI \"(.*?)\"$")
	public void postArticle(String uri, List<ArticleMetadata> metadata) throws Throwable {
		expectedMetadata = metadata.get(0);
		actualArticleId = ClientBuilder.newClient()
	            .target("http://localhost:8080/article-service").path(uri)
	            .request(MediaType.APPLICATION_JSON_TYPE).post(Entity.entity(expectedMetadata, MediaType.APPLICATION_JSON))
	            .readEntity(ArticleId.class);
	}
	
	@Then("^an article ID is returned$")
	public void an_article_ID_is_returned() throws Throwable {
		assertThat(actualArticleId.getId(), is(notNullValue())) ;
	}
```

The Java step definition contains a number of technical details. Those are clearly about **how to use** the service and should definitely not be in the scenario description.

The data format used by consumer and service is JSON. In the request the client is asking for JSON data: <code>request(MediaType.APPLICATION_JSON_TYPE)</code>. It is also sending the encoded entity (the article metadata) as JSON: <code>post(Entity.entity(expectedMetadata, MediaType.APPLICATION_JSON))</code>

## Time to write some production code
With that in place I needed to write just enough code to at least get to the *Then an article ID is returned* step. So I wrote this:

```java

	@Path("article")
	public class ArticleResource {
		// todo: fake
		private static ArticleMetadata fakeArticle ;
		
	    @POST
	    @Produces(MediaType.APPLICATION_JSON)
	    @Consumes(MediaType.APPLICATION_JSON)
	    public ArticleId storeArticle(ArticleMetadata metadata) {
	    	ArticleId id = ArticleId.generate() ;
	    	fakeArticle = metadata ;
	        fakeArticle.setId(id.getId()) ;
	        return id ;
	    }
		
	}
```
## No storage facility needed at this point
Note that I'm using a static variable to hold the article metadata posted to the service.

Unlike other approaches, I want to focus on the behavior of the service and not spend time thinking about how the service will perform it's work on the inside. There will be a time for that later on. At the moment I feel that for the new version of [ALE News](http://www.ale-news.com) I need the ability to somehow store and retrieve article metadata but there is certainly a lot more than just that. I want to explore those other things first a bit before spending time and effort on fleshing out a service that I might need to change substantially or replace with something else soon.

After all, software product development is a journey and you never know what you will discover.

{% include ale-news-post-footer.html %}
