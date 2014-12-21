---
layout: post
title: Adding the web client module
tags:
- en
- ale-news-service
categories:
- ATDD
- Software-Development
---
{% include ale-news-post-header.html %}

So far I've created a draft implementation of a RESTful service to interact with an archive of article metadata. Before fleshing out that service I want to add a web client to my project. The web client should consume the article service as its backend.

## Need to deploy multiple web applications to the same servlet container
I learned that I will have to deploy the article service webapp and the web client webapp to the same servlet container. That seems to be doable with Tomcat but it appears to be easier with Jetty. I don't really care about the servlet container I'm using for this, so I decided to switch to Jetty.

## Preparations
As I mentioned before, being able to deliver at any point in time is important to me. So before I actually start writing code for the web client I want to make all the necessary changes to the build configuration. That includes:

* add a parent pom.xml
* turn the article-service from a standalone Maven project into a Maven module
* use dependency management in the parent POM
* use Jetty as servlet container instead of Tomcat

## Run the full single command build again
After all those changes I can run <code>mvn install</code> again and the output will now look like this (warnings removed for brevity):

	[INFO] Scanning for projects...
	[INFO] ------------------------------------------------------------------------
	[INFO] Reactor Build Order:
	[INFO] 
	[INFO] ALE News
	[INFO] ALE News Article Service Webapp
	[INFO] web-client Maven Webapp
	[INFO]                                                                         
	[INFO] ------------------------------------------------------------------------
	[INFO] Building ALE News 0.0.2-SNAPSHOT
	[INFO] ------------------------------------------------------------------------
	[INFO] 
	[INFO] --- maven-install-plugin:2.4:install (default-install) @ ale-news ---
	[INFO] Installing /Users/sns/Documents/dev/ale-news-atdd/source/pom.xml to /Users/sns/.m2/repository/net/caimito/ale-news/ale-news/0.0.2-SNAPSHOT/ale-news-0.0.2-SNAPSHOT.pom
	[INFO]                                                                         
	[INFO] ------------------------------------------------------------------------
	[INFO] Building ALE News Article Service Webapp 0.0.2-SNAPSHOT
	[INFO] ------------------------------------------------------------------------
	[INFO] 
	[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ article-service ---
	[WARNING] Using platform encoding (UTF-8 actually) to copy filtered resources, i.e. build is platform dependent!
	[INFO] Copying 0 resource
	[INFO] 
	[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ article-service ---
	[INFO] Nothing to compile - all classes are up to date
	[INFO] 
	[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ article-service ---
	[WARNING] Using platform encoding (UTF-8 actually) to copy filtered resources, i.e. build is platform dependent!
	[INFO] Copying 2 resources
	[INFO] 
	[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ article-service ---
	[INFO] Nothing to compile - all classes are up to date
	[INFO] 
	[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ article-service ---
	[INFO] 
	[INFO] --- maven-war-plugin:2.2:war (default-war) @ article-service ---
	[INFO] Packaging webapp
	[INFO] Assembling webapp [article-service] in [/Users/sns/Documents/dev/ale-news-atdd/source/article-service/target/article-service]
	[INFO] Processing war project
	[INFO] Copying webapp resources [/Users/sns/Documents/dev/ale-news-atdd/source/article-service/src/main/webapp]
	[INFO] Webapp assembled in [102 msecs]
	[INFO] Building war: /Users/sns/Documents/dev/ale-news-atdd/source/article-service/target/article-service.war
	[INFO] WEB-INF/web.xml already added, skipping
	[INFO] 
	[INFO] >>> jetty-maven-plugin:8.1.16.v20140903:start (start-jetty) > validate @ article-service >>>
	[INFO] 
	[INFO] <<< jetty-maven-plugin:8.1.16.v20140903:start (start-jetty) < validate @ article-service <<<
	[INFO] 
	[INFO] --- jetty-maven-plugin:8.1.16.v20140903:start (start-jetty) @ article-service ---
	[INFO] Configuring Jetty for project: ALE News Article Service Webapp
	[INFO] webAppSourceDirectory not set. Defaulting to /Users/sns/Documents/dev/ale-news-atdd/source/article-service/src/main/webapp
	[INFO] Reload Mechanic: automatic
	[INFO] Classes = /Users/sns/Documents/dev/ale-news-atdd/source/article-service/target/classes
	[INFO] Context path = /article-service
	[INFO] Tmp directory = /Users/sns/Documents/dev/ale-news-atdd/source/article-service/target/tmp
	[INFO] Web defaults = org/eclipse/jetty/webapp/webdefault.xml
	[INFO] Web overrides =  none
	[INFO] web.xml file = file:/Users/sns/Documents/dev/ale-news-atdd/source/article-service/src/main/webapp/WEB-INF/web.xml
	[INFO] Webapp directory = /Users/sns/Documents/dev/ale-news-atdd/source/article-service/src/main/webapp
	2014-09-23 14:31:31.651:INFO:oejs.Server:jetty-8.1.16.v20140903
	2014-09-23 14:31:32.241:INFO:oejpw.PlusConfiguration:No Transaction manager found - if your webapp requires one, please configure one.
	2014-09-23 14:32:01.870:WARN:oejsh.RequestLogHandler:!RequestLog
	[INFO] Started Jetty Server
	2014-09-23 14:32:01.887:INFO:oejs.AbstractConnector:Started SelectChannelConnector@0.0.0.0:8080
	[INFO] 
	[INFO] --- maven-failsafe-plugin:2.17:integration-test (default) @ article-service ---
	[INFO] Failsafe report directory: /Users/sns/Documents/dev/ale-news-atdd/source/article-service/target/failsafe-reports

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
	0m2.060s

	Tests run: 20, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 2.552 sec - in net.caimito.ale_news.article_service.RunCukesIntegrationTest

	Results :

	Tests run: 20, Failures: 0, Errors: 0, Skipped: 0

	[INFO] 
	[INFO] --- jetty-maven-plugin:8.1.16.v20140903:stop (stop-jetty) @ article-service ---
	[INFO] 
	[INFO] --- maven-failsafe-plugin:2.17:verify (default) @ article-service ---
	[INFO] Failsafe report directory: /Users/sns/Documents/dev/ale-news-atdd/source/article-service/target/failsafe-reports
	[INFO] 
	[INFO] --- maven-install-plugin:2.4:install (default-install) @ article-service ---
	[INFO] Installing /Users/sns/Documents/dev/ale-news-atdd/source/article-service/target/article-service.war to /Users/sns/.m2/repository/net/caimito/ale-news/article-service/0.0.2-SNAPSHOT/article-service-0.0.2-SNAPSHOT.war
	[INFO] Installing /Users/sns/Documents/dev/ale-news-atdd/source/article-service/pom.xml to /Users/sns/.m2/repository/net/caimito/ale-news/article-service/0.0.2-SNAPSHOT/article-service-0.0.2-SNAPSHOT.pom
	[INFO]                                                                         
	[INFO] ------------------------------------------------------------------------
	[INFO] Building web-client Maven Webapp 0.0.2-SNAPSHOT
	[INFO] ------------------------------------------------------------------------
	[INFO] 
	[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ web-client ---
	[INFO] Copying 0 resource
	[INFO] 
	[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ web-client ---
	[INFO] No sources to compile
	[INFO] 
	[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ web-client ---
	[INFO] skip non existing resourceDirectory /Users/sns/Documents/dev/ale-news-atdd/source/web-client/src/test/resources
	[INFO] 
	[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ web-client ---
	[INFO] No sources to compile
	[INFO] 
	[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ web-client ---
	[INFO] No tests to run.
	[INFO] 
	[INFO] --- maven-war-plugin:2.2:war (default-war) @ web-client ---
	[INFO] Packaging webapp
	[INFO] Assembling webapp [web-client] in [/Users/sns/Documents/dev/ale-news-atdd/source/web-client/target/web-client]
	[INFO] Processing war project
	[INFO] Copying webapp resources [/Users/sns/Documents/dev/ale-news-atdd/source/web-client/src/main/webapp]
	[INFO] Webapp assembled in [412 msecs]
	2014-09-23 14:32:05.636:INFO:oejsl.ELContextCleaner:javax.el.BeanELResolver purged
	2014-09-23 14:32:05.636:INFO:oejsh.ContextHandler:stopped o.m.j.p.JettyWebAppContext{/article-service,file:/Users/sns/Documents/dev/ale-news-atdd/source/article-service/src/main/webapp/},file:/Users/sns/Documents/dev/ale-news-atdd/source/article-service/src/main/webapp/
	[INFO] Building war: /Users/sns/Documents/dev/ale-news-atdd/source/web-client/target/web-client.war
	[INFO] WEB-INF/web.xml already added, skipping
	[INFO] 
	[INFO] --- maven-install-plugin:2.4:install (default-install) @ web-client ---
	[INFO] Installing /Users/sns/Documents/dev/ale-news-atdd/source/web-client/target/web-client.war to /Users/sns/.m2/repository/net/caimito/ale-news/web-client/0.0.2-SNAPSHOT/web-client-0.0.2-SNAPSHOT.war
	[INFO] Installing /Users/sns/Documents/dev/ale-news-atdd/source/web-client/pom.xml to /Users/sns/.m2/repository/net/caimito/ale-news/web-client/0.0.2-SNAPSHOT/web-client-0.0.2-SNAPSHOT.pom
	[INFO] ------------------------------------------------------------------------
	[INFO] Reactor Summary:
	[INFO] 
	[INFO] ALE News ........................................... SUCCESS [  0.250 s]
	[INFO] ALE News Article Service Webapp .................... SUCCESS [ 35.760 s]
	[INFO] web-client Maven Webapp ............................ SUCCESS [  1.659 s]
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD SUCCESS
	[INFO] ------------------------------------------------------------------------
	[INFO] Total time: 37.807 s
	[INFO] Finished at: 2014-09-23T14:32:06+08:00
	[INFO] Final Memory: 25M/614M
	[INFO] ------------------------------------------------------------------------

By now I have the structure in place to get started with the web client. **I can still ship the draft version of the article service. That allows me to continue with confidence.**

## Merge the changes into master
I always keep the master branch in the git repository clean and ready for release. The code in master should be working software - fully tested and ready for deployment.

With those major changes finished it is now time to merge by development branch into the master branch:

	14:40 sns ~/Documents/dev/ale-news-atdd/source  (dev)$ git status
	On branch dev
	nothing to commit, working directory clean
	14:40 sns ~/Documents/dev/ale-news-atdd/source  (dev)$ git checkout master
	Switched to branch 'master'
	Your branch is up-to-date with 'origin/master'.
	14:40 sns ~/Documents/dev/ale-news-atdd/source  (master)$ git merge dev
	Updating ed8dae2..d4c2ebb
	Fast-forward
	 .gitignore                                  |   5 +++-
	 README.md                                   |   5 ++++
	 article-service/pom.xml                     | 141 +++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------
	 article-service/src/main/webapp/index.html  |   5 ----
	 pom.xml                                     | 122 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
	 web-client/.bowerrc                         |   3 +++
	 web-client/bower.json                       |  26 +++++++++++++++++++
	 web-client/pom.xml                          |  34 +++++++++++++++++++++++++
	 web-client/src/main/webapp/WEB-INF/web.xml  |   7 +++++
	 web-client/src/main/webapp/app/css/main.css |  36 ++++++++++++++++++++++++++
	 web-client/src/main/webapp/index.html       |  23 +++++++++++++++++
	 11 files changed, 306 insertions(+), 101 deletions(-)
	 create mode 100644 README.md
	 delete mode 100644 article-service/src/main/webapp/index.html
	 create mode 100644 web-client/.bowerrc
	 create mode 100644 web-client/bower.json
	 create mode 100644 web-client/pom.xml
	 create mode 100644 web-client/src/main/webapp/WEB-INF/web.xml
	 create mode 100644 web-client/src/main/webapp/app/css/main.css
	 create mode 100644 web-client/src/main/webapp/index.html
	14:40 sns ~/Documents/dev/ale-news-atdd/source  (master)$ git push
	Counting objects: 46, done.
	Delta compression using up to 4 threads.
	Compressing objects: 100% (32/32), done.
	Writing objects: 100% (38/38), 6.52 KiB | 0 bytes/s, done.
	Total 38 (delta 9), reused 0 (delta 0)
	To https://github.com/snscaimito/ale-news-atdd.git
	   ed8dae2..d4c2ebb  master -> master
	14:41 sns ~/Documents/dev/ale-news-atdd/source  (master)$ 

{% include ale-news-post-footer.html %}
