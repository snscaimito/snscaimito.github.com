---
layout: post
title: Build with a single command
tags:
- en
- ale-news-service
categories:
- atdd
- software_development
---
{% include ale-news-post-header.html %}

To me, being able to build a software product with a single command on the command line is very important. I want to be able to check out the source code from version control and then type a single command. After a while, can be a minute or 30 minutes, all components should be built and tested and the product is ready to be used.

I call this the ability to deliver at any point in time. And I want to defend it once I've gained it.

For version 0.0.1 the project layout looks like this:

	11:48 sns ~/tmp/ale-news-atdd  ((article-service-0.0.1))$ ls -l
	total 0
	drwxr-xr-x  7 sns  staff  238 23 Sep 11:47 article-service
	11:48 sns ~/tmp/ale-news-atdd  ((article-service-0.0.1))$ cd article-service/
	11:48 sns ~/tmp/ale-news-atdd/article-service  ((article-service-0.0.1))$ ls -l
	total 24
	-rw-r--r--   1 sns  staff    78 23 Sep 11:46 TODO.md
	-rw-r--r--   1 sns  staff  4280 23 Sep 11:46 pom.xml
	drwxr-xr-x   4 sns  staff   136 23 Sep 11:46 src

The main project directory is <code>ale-news-atdd</code> and inside that I am using another directory for the article service. It does contain a <code>pom.xml</code> file for the Maven configuration to build the project and the source code in <code>src</code>.

## Single command build for the Article Service
To build the article service, which at the moment is the only piece I have so far, a single command is all that is needed: <code>mvn install</code>

Maven will fetch all dependencies, compile, run tests and package the article service in one single run. The promise is: if the build succeeds, then it is good and ready to be shipped.

*For brevity I have removed some of Maven's warning messages from the following output.*

	12:00 sns ~/tmp/ale-news-atdd/article-service  ((article-service-0.0.1))$ mvn install
	[INFO] Scanning for projects...
	[INFO]                                                                         
	[INFO] ------------------------------------------------------------------------
	[INFO] Building article-service Maven Webapp 0.0.1-SNAPSHOT
	[INFO] ------------------------------------------------------------------------
	[INFO] 
	[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ article-service ---
	[INFO] skip non existing resourceDirectory /Users/sns/tmp/ale-news-atdd/article-service/src/main/resources
	[INFO] 
	[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ article-service ---
	[INFO] Changes detected - recompiling the module!
	[INFO] Compiling 4 source files to /Users/sns/tmp/ale-news-atdd/article-service/target/classes
	[INFO] 
	[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ article-service ---
	[INFO] Copying 2 resources
	[INFO] 
	[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ article-service ---
	[INFO] Changes detected - recompiling the module!
	[INFO] Compiling 2 source files to /Users/sns/tmp/ale-news-atdd/article-service/target/test-classes
	[INFO] 
	[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ article-service ---
	[INFO] 
	[INFO] --- maven-war-plugin:2.2:war (default-war) @ article-service ---
	[INFO] Packaging webapp
	[INFO] Assembling webapp [article-service] in [/Users/sns/tmp/ale-news-atdd/article-service/target/article-service]
	[INFO] Processing war project
	[INFO] Copying webapp resources [/Users/sns/tmp/ale-news-atdd/article-service/src/main/webapp]
	[INFO] Webapp assembled in [138 msecs]
	[INFO] Building war: /Users/sns/tmp/ale-news-atdd/article-service/target/article-service.war
	[INFO] WEB-INF/web.xml already added, skipping

Up to this point the source has been compiled and the web application was created. There is now a WAR file available that can be deployed to a servlet container or application server.

I am using the Tomcat plugin for Maven to start a servlet container to run tests:

	[INFO] 
	[INFO] >>> tomcat7-maven-plugin:2.2:run (start-tomcat) > process-classes @ article-service >>>
	[INFO] 
	[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ article-service ---
	[INFO] skip non existing resourceDirectory /Users/sns/tmp/ale-news-atdd/article-service/src/main/resources
	[INFO] 
	[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ article-service ---
	[INFO] Nothing to compile - all classes are up to date
	[INFO] 
	[INFO] <<< tomcat7-maven-plugin:2.2:run (start-tomcat) < process-classes @ article-service <<<
	[INFO] 
	[INFO] --- tomcat7-maven-plugin:2.2:run (start-tomcat) @ article-service ---
	[INFO] Running war on http://localhost:8080/article-service
	[INFO] Creating Tomcat server configuration at /Users/sns/tmp/ale-news-atdd/article-service/target/tomcat
	[INFO] create webapp with contextPath: /article-service
	Sep 23, 2014 12:01:02 PM org.apache.coyote.AbstractProtocol init
	INFO: Initializing ProtocolHandler ["http-bio-8080"]
	Sep 23, 2014 12:01:02 PM org.apache.catalina.core.StandardService startInternal
	INFO: Starting service Tomcat
	Sep 23, 2014 12:01:02 PM org.apache.catalina.core.StandardEngine startInternal
	INFO: Starting Servlet Engine: Apache Tomcat/7.0.47
	Sep 23, 2014 12:01:05 PM org.apache.coyote.AbstractProtocol start
	INFO: Starting ProtocolHandler ["http-bio-8080"]

Tomcat has started and the application is deployed.

Next Maven will use the Surefire plugin to execute my tests. <code>RunCukesIntegrationTest</code> is the Cucumber test runner, which uses JUnit as platform and is bound to the integration-test phase.

	[INFO] 
	[INFO] --- maven-failsafe-plugin:2.17:integration-test (default) @ article-service ---
	[INFO] Failsafe report directory: /Users/sns/tmp/ale-news-atdd/article-service/target/failsafe-reports

	-------------------------------------------------------
	 T E S T S
	-------------------------------------------------------
	Running net.caimito.ale_news.article_service.RunCukesIntegrationTest
	Feature: CRUD and list scooped articles

	  Scenario: Create new article metadata                                                   # net/caimito/ale_news/article_service/articles.feature:3
	    When I post the following article metadata to the article service with URI "/article" # ArticleStepDefinitions.postArticle(String,ArticleMetadata>)
	    Then an article ID is returned                                                        # ArticleStepDefinitions.an_article_ID_is_returned()
	    And the article metadata has been stored in the archive                               # ArticleStepDefinitions.the_article_metadata_has_been_stored_in_the_archive()

	  Scenario: Read article metadata                                                                     # net/caimito/ale_news/article_service/articles.feature:10
	    Given some article metadata with key "550e8400-e29b-11d4-a716-446655440000" exists in the archive # ArticleStepDefinitions.some_article_metadata_with_key_exists_in_the_archive(String)
	    When I ask the article service with URI "/article/550e8400-e29b-11d4-a716-446655440000"           # ArticleStepDefinitions.i_ask_the_article_service_with_URI_for_article_id(String)
	    Then I receive the article metadata                                                               # ArticleStepDefinitions.i_receive_the_article_metadata()

	  Scenario: Update article metadata                                                               # net/caimito/ale_news/article_service/articles.feature:15
	    Given the article with key "550e8400-e29b-11d4-a716-446655440000" exists in the archive       # ArticleStepDefinitions.the_article_with_key_exists_in_the_archive(String,ArticleMetadata>)
	    When I update details of the article with URI "/article/550e8400-e29b-11d4-a716-446655440000" # ArticleStepDefinitions.i_update_details_of_the_article_with_URI(String,ArticleMetadata>)
	    Then the metadata for article "550e8400-e29b-11d4-a716-446655440000" in the archive is        # ArticleStepDefinitions.the_article_metadata_in_the_archive_is(String,ArticleMetadata>)

	  Scenario: Delete article metadata                                                         # net/caimito/ale_news/article_service/articles.feature:26
	    Given the article with key "550e8400-e29b-11d4-a716-446655440000" exists in the archive # ArticleStepDefinitions.the_article_with_key_exists_in_the_archive(String,ArticleMetadata>)
	    When I delete the article with key "550e8400-e29b-11d4-a716-446655440000"               # ArticleStepDefinitions.i_delete_the_article_with_key(String)
	    Then the article with key "550e8400-e29b-11d4-a716-446655440000" does not exist         # ArticleStepDefinitions.the_article_with_key_does_not_exist(String)

	  Scenario: List article metadata                         # net/caimito/ale_news/article_service/articles.feature:33
	    Given some articles exist in the archive              # ArticleStepDefinitions.some_articles_exist_in_the_archive()
	    When I ask for a list of articles with URI "/article" # ArticleStepDefinitions.i_ask_for_a_list_of_articles_with_URI(String)
	    Then I will receive a list of articles                # ArticleStepDefinitions.i_will_receive_a_list_of_articles()

	5 Scenarios (5 passed)
	15 Steps (15 passed)
	0m2.039s

	Tests run: 20, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 2.646 sec - in net.caimito.ale_news.article_service.RunCukesIntegrationTest

	Results :

	Tests run: 20, Failures: 0, Errors: 0, Skipped: 0

All Cucumber scenarios pass. Maven will now shutdown Tomcat:

	[INFO] 
	[INFO] --- tomcat7-maven-plugin:2.2:shutdown (stop-tomcat) @ article-service ---
	Sep 23, 2014 12:01:08 PM org.apache.coyote.AbstractProtocol pause
	INFO: Pausing ProtocolHandler ["http-bio-8080"]
	Sep 23, 2014 12:01:08 PM org.apache.catalina.core.StandardService stopInternal
	INFO: Stopping service Tomcat
	Sep 23, 2014 12:01:09 PM org.apache.coyote.AbstractProtocol stop
	INFO: Stopping ProtocolHandler ["http-bio-8080"]
	[INFO] 
	[INFO] --- maven-failsafe-plugin:2.17:verify (default) @ article-service ---
	[INFO] Failsafe report directory: /Users/sns/tmp/ale-news-atdd/article-service/target/failsafe-reports
	[INFO] 
	[INFO] --- maven-install-plugin:2.4:install (default-install) @ article-service ---
	[INFO] Installing /Users/sns/tmp/ale-news-atdd/article-service/target/article-service.war to /Users/sns/.m2/repository/net/caimito/ale-news/article-service/0.0.1-SNAPSHOT/article-service-0.0.1-SNAPSHOT.war
	[INFO] Installing /Users/sns/tmp/ale-news-atdd/article-service/pom.xml to /Users/sns/.m2/repository/net/caimito/ale-news/article-service/0.0.1-SNAPSHOT/article-service-0.0.1-SNAPSHOT.pom
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD SUCCESS
	[INFO] ------------------------------------------------------------------------
	[INFO] Total time: 10.547 s
	[INFO] Finished at: 2014-09-23T12:01:09+08:00
	[INFO] Final Memory: 48M/513M
	[INFO] ------------------------------------------------------------------------

With the BUILD SUCCESS message on the screen I now have the <code>article-service.war</code> available for deployment into production. It does behave as specified in <code>articles.feature</code>.

## Cutting release 0.0.1
Because all tests/scenarios are good, I can run <code>mvn release:prepare</code> and actually perform the release. In economic language: **by now I have realized value and gotten a return on my investment into writing the specification and the code to pass it**.

## Are we done now?
No, we are not yet done. But we have a positive starting point and we can actually show the result to a customer to ask "Is this the behavior you expect from the Article Service?"

The specification does not exist to verify the Article Service. It does exist to find out and clarify expected behavior. It is a starting point for further collaboration and acts as a first checkpoint.

{% include ale-news-post-footer.html %}
