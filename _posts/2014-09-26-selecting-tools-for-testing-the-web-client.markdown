---
layout: post
title: Selecting tools for testing the web client
tags:
- en
- ale-news-service
categories:
- atdd
- software_development
---
After learning a bit about [AngularJS](http://angularjs.org) to create some simple web client I want to continue on the ATDD path and write a specification before diving deeper into coding the web client.

{% include ale-news-post-header.html %}

Originally I had planned to use [page-object](https://github.com/cheezy/page-object) and Cucumber for that. page-object makes it really simple to describe a web page and there is very little code required to interact with the page or check for the existence of elements. page-object is a Ruby gem. So I tried to add JRuby to my Maven build. However, I discovered that it is more effort than what I want to do at the moment. I like to keep things stupid and simple (KISS).

So far I'm using Java and JavaScript as programming languages for the behavior of my application. There is HTML and CSS for the presentation. If I were to use Ruby tools, then I would use two languages for the production code and introduce a third language for some of the test code.

As I'm working on this alone, I can use any mix of languages and technologies that I am familiar with. In the case of a development team there might be limitations to what can be choosen. The team might have dedicated testers who don't know Java but happen to know scripting languages like Ruby or Python. In that case JRuby might have been a good choice and the effort of integrating it into the single command build - *mvn install* at the moment - is certainly justified.

## Step definitions in Java and Selenium to automate the web browser
So I decided to use Java to implement the steps of my scenarios - the acceptance tests - and use Selenium WebDriver to automate the web browser. I added the following additional dependencies to the pom.xml of the web-client module and also added the configuration for Maven Surefire to run my Cucumber features as part of the integration-test phase.

	<dependency>
	    <groupId>org.seleniumhq.selenium</groupId>
	    <artifactId>selenium-java</artifactId>
	    <version>2.43.1</version>
	    <scope>test</scope>
	</dependency>
	<dependency>
	    <groupId>com.github.detro.ghostdriver</groupId>
	    <artifactId>phantomjsdriver</artifactId>
	    <version>1.1.0</version>
	    <scope>test</scope>
	</dependency>

## PhantomJS as headless web browser
PhantomJS is a [WebKit](http://www.webkit.org) web browser that doesn't open a window and doesn't want a human to interact with it. It has become popular amongst web developers and is perfectly suited to run headless in-browser tests.

I downloaded and installed PhantomJS and wrote a simple scenario and corresponding step definitions to try out the whole setup.

```java
public class StepDefinitions {
    private DesiredCapabilities capabilities = DesiredCapabilities.phantomjs();
    private PhantomJSDriver driver = new PhantomJSDriver(capabilities);

    @When("^I open ALE News$")
    public void i_open_ALE_News() throws Throwable {
        driver.get("http://localhost:8080/web-client");
    }

    @Then("^I see a list of articles$")
    public void i_see_a_list_of_articles() throws Throwable {
        assertThat(driver.findElement(By.id("articleList")), is(notNullValue())) ;
    }
}
```

The full source code for everything up to this point can be found at GitHub under a [tag ](https://github.com/snscaimito/ale-news-atdd/tree/headless_web_testing).

## Running the full build
With those changes in place I was then able to go into the root directory of my project and run *mvn install* from there.

	17:08 sns ~/Documents/dev/ale-news-atdd/source  (master)$ mvn clean install
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

... some parts omitted ...

	[INFO] ------------------------------------------------------------------------
	[INFO] Building web-client Maven Webapp 0.0.2-SNAPSHOT
	[INFO] ------------------------------------------------------------------------
	[INFO] 
	[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ web-client ---
	[INFO] Deleting /Users/sns/Documents/dev/ale-news-atdd/source/web-client/target
	[INFO] 
	[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ web-client ---
	[INFO] Copying 0 resource
	[INFO] 
	[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ web-client ---
	[INFO] No sources to compile
	[INFO] 
	[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ web-client ---
	[INFO] Copying 1 resource
	[INFO] 
	[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ web-client ---
	[INFO] Changes detected - recompiling the module!
	[INFO] Compiling 2 source files to /Users/sns/Documents/dev/ale-news-atdd/source/web-client/target/test-classes
	[INFO] 
	[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ web-client ---
	[INFO] 
	[INFO] --- maven-war-plugin:2.2:war (default-war) @ web-client ---
	[INFO] Packaging webapp
	[INFO] Assembling webapp [web-client] in [/Users/sns/Documents/dev/ale-news-atdd/source/web-client/target/web-client]
	[INFO] Processing war project
	[INFO] Copying webapp resources [/Users/sns/Documents/dev/ale-news-atdd/source/web-client/src/main/webapp]
	[INFO] Webapp assembled in [141 msecs]
	[INFO] Building war: /Users/sns/Documents/dev/ale-news-atdd/source/web-client/target/web-client.war
	[INFO] WEB-INF/web.xml already added, skipping
	[INFO] 
	[INFO] >>> jetty-maven-plugin:9.2.3.v20140905:start (start-jetty) > validate @ web-client >>>
	[INFO] 
	[INFO] <<< jetty-maven-plugin:9.2.3.v20140905:start (start-jetty) < validate @ web-client <<<
	[INFO] 
	[INFO] --- jetty-maven-plugin:9.2.3.v20140905:start (start-jetty) @ web-client ---
	[INFO] Configuring Jetty for project: web-client Maven Webapp
	[INFO] webAppSourceDirectory not set. Trying src/main/webapp
	[INFO] Reload Mechanic: automatic
	[INFO] Classes = /Users/sns/Documents/dev/ale-news-atdd/source/web-client/target/classes
	[INFO] Context path = /web-client
	[INFO] Tmp directory = /Users/sns/Documents/dev/ale-news-atdd/source/web-client/target/tmp
	[INFO] Web defaults = org/eclipse/jetty/webapp/webdefault.xml
	[INFO] Web overrides =  none
	[INFO] web.xml file = file:/Users/sns/Documents/dev/ale-news-atdd/source/web-client/src/main/webapp/WEB-INF/web.xml
	[INFO] Webapp directory = /Users/sns/Documents/dev/ale-news-atdd/source/web-client/src/main/webapp
	2014-09-25 17:09:15.024:INFO:oejs.Server:main: jetty-9.2.3.v20140905
	2014-09-25 17:09:15.150:INFO:oejsh.ContextHandler:main: Started o.e.j.m.p.JettyWebAppContext@5e98032e{/web-client,file:/Users/sns/Documents/dev/ale-news-atdd/source/web-client/src/main/webapp/,AVAILABLE}{file:/Users/sns/Documents/dev/ale-news-atdd/source/web-client/src/main/webapp/}
	2014-09-25 17:09:16.410:INFO:oejsh.ContextHandler:main: Started o.e.j.w.WebAppContext@4fe8f2ae{/article-service,file:/Users/sns/Documents/dev/ale-news-atdd/source/article-service/target/article-service/,AVAILABLE}{/Users/sns/Documents/dev/ale-news-atdd/source/web-client/../article-service/target/article-service.war}
	2014-09-25 17:09:16.412:WARN:oejsh.RequestLogHandler:main: !RequestLog
	2014-09-25 17:09:16.413:INFO:oejs.ServerConnector:main: Started ServerConnector@62158991{HTTP/1.1}{0.0.0.0:8080}
	2014-09-25 17:09:16.413:INFO:oejs.Server:main: Started @40646ms
	[INFO] Started Jetty Server
	[INFO] 
	[INFO] --- maven-failsafe-plugin:2.17:integration-test (default) @ web-client ---
	[INFO] Failsafe report directory: /Users/sns/Documents/dev/ale-news-atdd/source/web-client/target/failsafe-reports

	-------------------------------------------------------
	 T E S T S
	-------------------------------------------------------
	Running net.caimito.ale_news.web_client.RunCukesIntegrationTest
	Feature: List articles
	Sep 25, 2014 5:09:17 PM org.openqa.selenium.phantomjs.PhantomJSDriverService <init>
	INFO: executable: /Users/sns/bin/phantomjs
	Sep 25, 2014 5:09:17 PM org.openqa.selenium.phantomjs.PhantomJSDriverService <init>
	INFO: port: 5855
	Sep 25, 2014 5:09:17 PM org.openqa.selenium.phantomjs.PhantomJSDriverService <init>
	INFO: arguments: [--webdriver=5855, --webdriver-logfile=/Users/sns/Documents/dev/ale-news-atdd/source/web-client/phantomjsdriver.log]
	Sep 25, 2014 5:09:17 PM org.openqa.selenium.phantomjs.PhantomJSDriverService <init>
	INFO: environment: {}
	PhantomJS is launching GhostDriver...
	[INFO  - 2014-09-25T09:09:18.504Z] GhostDriver - Main - running on port 5855
	[INFO  - 2014-09-25T09:09:18.650Z] Session [a1632c70-4493-11e4-9b90-892d0b7edf33] - page.settings - {"XSSAuditingEnabled":false,"javascriptCanCloseWindows":true,"javascriptCanOpenWindows":true,"javascriptEnabled":true,"loadImages":true,"localToRemoteUrlAccessEnabled":false,"userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X) AppleWebKit/534.34 (KHTML, like Gecko) PhantomJS/1.9.7 Safari/534.34","webSecurityEnabled":true}
	[INFO  - 2014-09-25T09:09:18.650Z] Session [a1632c70-4493-11e4-9b90-892d0b7edf33] - page.customHeaders:  - {}
	[INFO  - 2014-09-25T09:09:18.651Z] Session [a1632c70-4493-11e4-9b90-892d0b7edf33] - Session.negotiatedCapabilities - {"browserName":"phantomjs","version":"1.9.7","driverName":"ghostdriver","driverVersion":"1.1.0","platform":"mac-unknown-32bit","javascriptEnabled":true,"takesScreenshot":true,"handlesAlerts":false,"databaseEnabled":false,"locationContextEnabled":false,"applicationCacheEnabled":false,"browserConnectionEnabled":false,"cssSelectorsEnabled":true,"webStorageEnabled":false,"rotatable":false,"acceptSslCerts":false,"nativeEvents":true,"proxy":{"proxyType":"direct"}}
	[INFO  - 2014-09-25T09:09:18.651Z] SessionManagerReqHand - _postNewSessionCommand - New Session Created: a1632c70-4493-11e4-9b90-892d0b7edf33

	  Scenario: List articles         # net/caimito/ale_news/web_client/articles.feature:3
	    When I open ALE News          # StepDefinitions.i_open_ALE_News()
	    Then I see a list of articles # StepDefinitions.i_see_a_list_of_articles()

	1 Scenarios (1 passed)
	2 Steps (2 passed)
	0m2.208s

	Tests run: 3, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 2.646 sec - in net.caimito.ale_news.web_client.RunCukesIntegrationTest

	Results :

	Tests run: 3, Failures: 0, Errors: 0, Skipped: 0

	[INFO] 
	[INFO] --- jetty-maven-plugin:9.2.3.v20140905:stop (stop-jetty) @ web-client ---
	[INFO] Waiting 10 seconds for jetty to stop
	2014-09-25 17:09:19.713:INFO:oejs.ServerConnector:ShutdownMonitor: Stopped ServerConnector@62158991{HTTP/1.1}{0.0.0.0:8080}
	2014-09-25 17:09:19.721:INFO:oejsh.ContextHandler:ShutdownMonitor: Stopped o.e.j.w.WebAppContext@4fe8f2ae{/article-service,file:/Users/sns/Documents/dev/ale-news-atdd/source/article-service/target/article-service/,UNAVAILABLE}{/Users/sns/Documents/dev/ale-news-atdd/source/web-client/../article-service/target/article-service.war}
	2014-09-25 17:09:20.224:INFO:oejsh.ContextHandler:ShutdownMonitor: Stopped o.e.j.m.p.JettyWebAppContext@5e98032e{/web-client,file:/Users/sns/Documents/dev/ale-news-atdd/source/web-client/src/main/webapp/,UNAVAILABLE}{file:/Users/sns/Documents/dev/ale-news-atdd/source/web-client/src/main/webapp/}
	[INFO] Server reports itself as stopped
	[INFO] 
	[INFO] --- maven-failsafe-plugin:2.17:verify (default) @ web-client ---
	[INFO] Failsafe report directory: /Users/sns/Documents/dev/ale-news-atdd/source/web-client/target/failsafe-reports
	[INFO] 
	[INFO] --- maven-install-plugin:2.4:install (default-install) @ web-client ---
	[INFO] Installing /Users/sns/Documents/dev/ale-news-atdd/source/web-client/target/web-client.war to /Users/sns/.m2/repository/net/caimito/ale-news/web-client/0.0.2-SNAPSHOT/web-client-0.0.2-SNAPSHOT.war
	[INFO] Installing /Users/sns/Documents/dev/ale-news-atdd/source/web-client/pom.xml to /Users/sns/.m2/repository/net/caimito/ale-news/web-client/0.0.2-SNAPSHOT/web-client-0.0.2-SNAPSHOT.pom
	[INFO] ------------------------------------------------------------------------
	[INFO] Reactor Summary:
	[INFO] 
	[INFO] ALE News ........................................... SUCCESS [  0.388 s]
	[INFO] ALE News Article Service Webapp .................... SUCCESS [ 36.820 s]
	[INFO] web-client Maven Webapp ............................ SUCCESS [  6.003 s]
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD SUCCESS
	[INFO] ------------------------------------------------------------------------
	[INFO] Total time: 43.371 s
	[INFO] Finished at: 2014-09-25T17:09:20+08:00
	[INFO] Final Memory: 45M/676M
	[INFO] ------------------------------------------------------------------------

That is proof enough that I can still deliver at any time and it is now time to begin working on a specification that explains what the web client should do.

{% include ale-news-post-footer.html %}
