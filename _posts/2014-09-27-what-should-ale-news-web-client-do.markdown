---
layout: post
title: What should the ALE News web client do?
tags:
- en
categories:
- ATDD
- Software-Development
- ale-news-service
---
Now that I have decided on my toolset for the acceptance tests I am thinking about **what** the web client should really do. The purpose of [ALE News](http://www.ale-news.com) is to share articles people find. Where do people find interesting articles related to Agile and Lean? There is probably a huge number of sources and ways to find articles. It definitely is not only browsing the *World Wide Web*.

{% include ale-news-post-header.html %}

These days I find myself following a number of people on Twitter. Whenever they post a link that sounds interesting, I follow it. Usually I read Twitter posts on my iPhone or iPad - rarely am I doing that on my laptop. That means that in my case a web browser based submission method would probably not be used by me - at least not frequently.

So I will have to develop some sort of extension to be used within the Twitter client on the iPhone and iPad - at least at some point.

Right now I'm facing a another little challenge: without any data in the article metadata archive there isn't much to display. That is why, if properly coded, this scenario will always fail:

```gherkin
Scenario: List articles
	When I open ALE News
	Then I see a list of articles
```

That is why I want to create a simple submission method so that I can use the web client to populate the archive. So for the moment the specification for the web client will be this:

```gherkin
Feature: Article metadata archive

  Scenario: Create new article metadata
    When I submit the following article metadata
      | Author         | Title                                            | location                                                                                                     |
      | Stephan Schwab | From competition it is a big leap to cooperation | http://www.stephan-schwab.com/china/culture/management/thoughts/2014/08/30/collaboration-or-cooperation.html |
    Then I see a list of articles

  Scenario: List articles
    When I open ALE News
    Then I see a list of articles
```

## First try to fulfill the specification
I added two routes to the web client. One for looking at existing article metadata and another one for adding it.

```javascript
articleApp.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/article/add', {
        templateUrl: 'partials/article/add.html'
      }).
      when('/article', {
        templateUrl: 'partials/article/list.html',
        controller: 'articleListController'
      }).
      otherwise({
        redirectTo: '/article'
      });

  }]);
```

To handle display and input of article metadata I am using the following controller implementation:

```javascript
var articleControllers = angular.module('articleControllers', []);

articleControllers.controller('articleListController', ['$scope', '$http',
    function ($scope, $http) {
        $http.get('http://localhost:8080/article-service/article').success(function(data) {
            $scope.articles = data;
        });
    }]);

articleControllers.controller('articleAddController', ['$scope', '$http',
    function ($scope, $http) {
        $scope.add = function(article) {
            $http.post('http://localhost:8080/article-service/article', $scope.article).success(function(data) {
                $scope.articleId = data;
            });
        } ;
    }]);
```

Because I'm new to AngularJS and needed to experiment I decided to fumble around with it a bit before trying to test it. It is better to focus on one thing than to try to get multiple things working at the same time.

With the interesting parts of the rudimentary web client working I switched back to the executable specification. I added finding form elements and filling out the form to the step definitions and modified the entry point to the application. For the moment it is */web-client/app* but I want to remove the *app* at some point. I will get back to that once I'm understanding AngularJS a bit better.

```java
@When("^I submit the following article metadata$")
public void i_submit_the_following_article_metadata(List<ArticleMetadata> articleMetadataList) throws Throwable {
    ArticleMetadata metadata = articleMetadataList.get(0) ;

    driver.get("http://localhost:8080/web-client/app/#/article/add");

    driver.findElement(By.id("author")).sendKeys(metadata.getAuthor());
    driver.findElement(By.id("title")).sendKeys(metadata.getTitle());
    driver.findElement(By.id("location")).sendKeys(metadata.getLocation());
    driver.findElement(By.id("save")).click();
}

@When("^I open ALE News$")
public void i_open_ALE_News() throws Throwable {
    driver.get("http://localhost:8080/web-client/app");
}
```

With all these modifications in place I then executed *mvn clean install* and in the log I got this:

```gherkin
  Scenario: Create new article metadata          # net/caimito/ale_news/web_client/articles.feature:3
    When I submit the following article metadata # StepDefinitions.i_submit_the_following_article_metadata(ArticleMetadata>)
    Then I see a list of articles                # StepDefinitions.i_see_a_list_of_articles()
      java.lang.AssertionError: 
      Expected: is not an empty collection
           but: was <[]>
        at org.hamcrest.MatcherAssert.assertThat(MatcherAssert.java:20)
        at org.junit.Assert.assertThat(Assert.java:865)
        at org.junit.Assert.assertThat(Assert.java:832)
        at net.caimito.ale_news.web_client.StepDefinitions.i_see_a_list_of_articles(StepDefinitions.java:45)
        at ✽.Then I see a list of articles(net/caimito/ale_news/web_client/articles.feature:7)
```

PhantomJS was taking a screenshot for the first failure:

![Screenshot Create new article metadata](/img/posts/ale-news/screenshot8482977782544543232.png)

With the web client and the article service deployed to Jetty I can also run my Cucumber feature in Intellij IDEA interactively:

![Cucumber](/img/posts/ale-news/Screen%20Shot%202014-09-27%20at%2013.25.03.png)

The second scenario (List articles) passes and the screenshot shows this:

![Screenshot List articles](/img/posts/ale-news/screenshot1023176486617764092.png)

The good news here is that I now have my own method for inputting data without relying on an external tool like [CocoaRestClient](http://mmattozzi.github.io/cocoa-rest-client/) that I need to operate manually. That is why the second scenario passes now.

The problem with the first scenario is that am using the existing step *Then I see a list of articles* to verify that adding article metadata was successful. That step wants to find a list of article metadata on the web page. I could redirect there after adding article metadata but I don't want to do that at the moment.

There are a few other considerations first. See the next blog post about those.

{% include ale-news-post-footer.html %}
