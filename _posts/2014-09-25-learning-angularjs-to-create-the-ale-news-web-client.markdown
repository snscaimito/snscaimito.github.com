---
layout: post
title: Learning AngularJS to create the ALE News web client
tags:
- en
- ale-news-service
categories:
- ATDD
- Software-Development
---
{% include ale-news-post-header.html %}

The ALE News web client will be implemented using the [AngularJS](http://angularjs.org) web framework as a single page web application in JavaScript. To help me with the layout I'm going to use Twitter Bootstrap. I added [NodeJS](http://nodejs.org), NPM and [Bower](http://bower.io) to my system and created a simple first HTML page:

```html
<html>
<head>
    <title>ALE News</title>
    <link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap.css">
    <link rel="stylesheet" href="app/css/main.css">
</head>
<body ng-app ng-init="name = 'World'">
    <h1>Hello {{name}}!</h1>

    <script src="bower_components/jquery/dist/jquery.js"></script>
    <script src="bower_components/bootstrap/dist/js/bootstrap.js"></script>
    <script src="bower_components/angular/angular.js"></script>
</body>
</html>
```

## Running multiple web applications at the same time
As the web client will consume the article service, which comes in the form of another WAR file, I added the following Jetty configuration to my pom.xml. It will deploy both WAR files to separate context paths.

    <build>
        <finalName>web-client</finalName>
        <plugins>
            <plugin>
                <groupId>org.mortbay.jetty</groupId>
                <artifactId>jetty-maven-plugin</artifactId>
                <configuration>
                    <webApp>
                        <contextPath>/web-client</contextPath>
                    </webApp>
                    <contextHandlers>
                        <contextHandler implementation="org.eclipse.jetty.webapp.WebAppContext">
                            <war>${project.basedir}/../article-service/target/article-service.war</war>
                            <contextPath>/article-service</contextPath>
                        </contextHandler>
                    </contextHandlers>
                </configuration>
            </plugin>
        </plugins>
    </build>

With that in place I can do <code>mvn jetty:run</code> inside the web-client module and will get this output on the console:

	2014-09-23 14:47:05.985:INFO:oejs.Server:jetty-8.1.16.v20140903
	2014-09-23 14:47:06.157:INFO:oejpw.PlusConfiguration:No Transaction manager found - if your webapp requires one, please configure one.
	2014-09-23 14:47:06.708:INFO:oejw.WebInfConfiguration:Extract jar:file:/Users/sns/Documents/dev/ale-news-atdd/source/article-service/target/article-service.war!/ to /Users/sns/Documents/dev/ale-news-atdd/source/article-service/target/article-service
	2014-09-23 14:47:08.076:WARN:oejsh.RequestLogHandler:!RequestLog
	2014-09-23 14:47:08.090:INFO:oejs.AbstractConnector:Started SelectChannelConnector@0.0.0.0:8080

A quick test reveals that both applications can be accessed through their URL.

## What is the simplest thing that could possibly work
I don't have any experience with the AngularJS web framework. With the help of their tutorial and some basic knowledge of JavaScript I was able to create a minimalistic application that consumes the article service and asks for a list of articles in the archive.

Here is the screen output from this simplistic webapp:

![Minimalistic Ale News](/img/posts/ale-news/minimalistic-ale-news.png)

This output is produced by the following HTML in index.html.

```html
<html ng-app="articleApp">
<head>
    <title>ALE News</title>
    <link rel="stylesheet" href="bower_components/bootstrap/dist/css/bootstrap.css">
    <link rel="stylesheet" href="app/css/main.css">
</head>
<body ng-controller="ArticleListCtrl">
    <h1>ALE News</h1>

    <ul>
        <li ng-repeat="article in articles">
            <a href="{{article.location}}">{{article.title}}</a><br/>
            By {{article.author}}
        </li>
    </ul>

    <script src="bower_components/jquery/dist/jquery.js"></script>
    <script src="bower_components/bootstrap/dist/js/bootstrap.js"></script>
    <script src="bower_components/angular/angular.js"></script>
    <script src="app/js/article-service.js"></script>
</body>
</html>
```

The <code>ArticleListCtrl</code> is defined in the article-service.js file:

```javascript
var articleApp = angular.module('articleApp', []);

articleApp.controller('ArticleListCtrl', ['$scope', '$http',
  function ($scope, $http) {
    $http.get('http://localhost:8080/article-service/article').success(function(data) {
      $scope.articles = data;
    });
  }]);
```

## Where did the data come from?
As the article service has only a fake data storage, a simple static instance variable, a GET request to obtain a list of articles will return an empty array. I used the [CocoaRestClient](http://mmattozzi.github.io/cocoa-rest-client/) to submit data to it via the POST method. That way I was able to use the service from the prototype web client.


So far I have experimented a little bit in order to learn more about how to use AngularJS. There was no point yet in writing a specification for the web client. That will follow next.

{% include ale-news-post-footer.html %}
