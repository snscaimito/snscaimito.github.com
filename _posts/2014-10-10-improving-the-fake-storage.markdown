---
layout: post
title: Improving the fake storage
tags:
- en
- ale-news-service
categories:
- ATDD
- Software-Development
---
So far I've been using a simple static variable as a fake storage to hold article metadata. That was enough to move forward, to explore the API for the service and how to use it from a client.

{% include ale-news-post-header.html %}

Another thing that was also in the back of my head is versioning. Sometime in the future the API of the service will evolve and I might have to distinguish different versions of it.

For now I just wanted to improve the storage a bit and changed this to an ArrayList. That change is now breaking my scenario tests, because I get a NullPointerException when my code is trying to use the list to find article metadata.

Initially I was using

```java
	// todo: fake
	private static Map<String, ArticleMetadata> fakeArticles = new HashMap<String, ArticleMetadata>();
```

and then got the NullPointerException when trying to access <code>fakeArticles</code>. I then changed this to

```java
	// todo: fake
	private static Map<String, ArticleMetadata> fakeArticles ;

    public ArticleResource() {
        fakeArticles = new HashMap<String, ArticleMetadata>();
    }
```

and now it is clear what is causing the problem: re-instantiating the class.

So I need to create a slightly more elaborate storage facility. I'm still not ready to invest into using a real database, as that would require me to do all kinds of additional work unrelated to working on **what** ALE News should do.

When I was browsing the documentation for Jersey I saw that it can be used together with Java CDI (Context Dependency Injection). I could have an instance of a class holding the ArrayList and have that injected into the @Resource to serve RESTful service requests.

That seemed like a nice way to continue going without committing on too much just yet.

However, it appears that for using CDI one needs to also use an Application Server. I looked around and found Glassfish, JBoss and even the real big ones like Websphere. That's not what I want to use at the point. Supposedly Jetty can also be configured to manage beans and support CDI. But somehow all that is a bit too much dependency for my taste. I consider choosing an application server or any slightly bit more elaborate runtime environment as a dependency an early commitment and I don't want to do that at the moment. I want to keep my options open and focus on fleshing out the **what** of ALE News. I might change a lot of things very soon and any early commitment would just make that change harder.

## Remembering an old friend
Then I remembered an old friend: Spring Framework. Several years ago that was what a Java programmer would usually use for Dependency Injection. So I looked it up and saw that Pivotal Labs is now maintaining it. I don't know the details and I don't intent to research it but I thought "Oh! A Ruby shop has taken over a popular Java framework". The current spring.io website looks very good and there I also found that all I want to do at the moment I can do with Spring. That includes RESTful web services. I might want to continue with Spring instead of Jersey.

The good part about Spring has always been that one really *owns* the code. The framework itself is open source, which means that one can have a copy of it and it is not very likely to disappear. The other good part is that nothing really requires an application server. Everything can just as well be run as a standalone Java executable. So running something in a server becomes an option not a requirement.

## Switching to Spring
Although it is not much right now I have a RESTful service implemented using Jersey. Jersey can integrate with Spring and so I decided to some minimal invasive changes to my code by adding a dependency:

	<dependency>
	    <groupId>org.glassfish.jersey.ext</groupId>
	    <artifactId>jersey-spring3</artifactId>
	    <version>2.12</version>
	</dependency>

I also had to add

	<dependency>
	    <groupId>commons-logging</groupId>
	    <artifactId>commons-logging</artifactId>
	    <version>1.2</version>
	</dependency>

And an applicationContext.xml file to /src/main/resources

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd">

    <context:annotation-config/>
    <context:component-scan base-package="net.caimito.ale_news"/>

</beans>
```

Then I changed ArticleResource by adding a new class ArticleStorage and have Spring inject it into ArticleResource:

```java
@Path("article")
public class ArticleResource {

    @Autowired
	private ArticleStorage articleStorage ;
```

ArticleStorage is simple:

```java
@Repository
public class ArticleStorage {

    private Map<String, ArticleMetadata> metaData = new HashMap<String, ArticleMetadata>() ;

    public Map<String, ArticleMetadata> getStorage() {
        return metaData;
    }
}
```

After changing the methods in ArticleResource I was able to run mvn install on the whole project. The existing acceptance tests for the *CRUD and list scooped articles* feature that I have for the Article Service did all work but the ones for the web client did break.

## Trouble using separate WAR files
Further investigation showed that Spring does not get initialized when Jetty loads the second war file.

So I researched and thought about that for quite a while. I even did an experiment using the Maven plugin for Glassfish.

## Merging the modules
In the end I decided to merge the article-service and web-client modules. I'm not happy with that but for the moment it should be ok to continue with more important things. I need to come back to this issue though.

{% include ale-news-post-footer.html %}
