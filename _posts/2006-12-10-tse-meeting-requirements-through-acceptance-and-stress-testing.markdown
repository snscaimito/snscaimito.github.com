---
layout: post
title: ! '[TSE] Meeting Requirements through Acceptance and Stress Testing'
tags:
- en
categories:
- miscellaneous
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>My fellow German developer Eberhard Wolff is speaking this morning about acceptance and stress testing to meet requirements.</p>

<p>As an introduction he's wrapping up what Spring provides in the org.springframework.test package.</p>

<p><strong>Acceptance Tests</strong></p>

<p>Now we are getting into Acceptance Tests. You use them to find errors in the implementation of business requirements or use cases. One can see them as formalized requirements. Unfortunately many times they are done manually and after the whole system has been developed. <a href="http://fitnesse.org/">Fit/FitNesse</a> is a tool for acceptance tests. The customer and the developer should write the acceptance tests together - so does XP say. Fit/FitNesse uses HTML as input format. Test data and expected results are provided as HTML tables. You need to write a simple class as a wrapper for business logic, which can be injected using @Configurable. This class is then used to pass data into the test and check the results.</p>

<p>Eberhard is working on a general <a href="https://spring-fitnesse.dev.java.net/">Fit Exporter for Spring</a>. It's currently Alpha code.</p>

<p>The SpringActionFixture can be used to test actions that are usually performed in a GUI. You specify input data and actions - e.g. press add button - and then look for results. In the HTML input file you use the expression "press" to call a method. So the UI stuff is left out, but the method that normally be called by the UI is now being called by FitNesse.</p>

<p>One question from the audience is whether you can run Fit/Fitnesse as part of a Maven build. As it's a command line tool that should be no problem.</p>

<p>Fit uses HTML <strong>files</strong> as input. Fitnesse uses Wiki pages. Triggered by a question from the audience Eberhard opinions that probably Word documents that get exported to HTML are the best solution to get business people to provide test data and rules.</p>

<p><strong>Performance Tests</strong></p>

<p><a href="http://jakarta.apache.org/jmeter/">JMeter</a> is a good tool to performance test web based applications. JMeter creates a large number of requests, but how do you measure the performance in the whole system. You want to measure each part of the system. Using a regular profiler for Java would not be sufficient for the purpose of performance tests, because it only focuses on the Java code itself. <a href="http://jamonapi.sourceforge.net/">JAMon</a> is a monitoring framework, which offers a Spring interceptor. For web application you configure a filter in web.xml. The JAMon filter measures HTTP request/response. JAMon profiles method calls using AOP. JAMon can be used as well to profile other parts of the system by simply declaring other AOP aspects, e.g. you could use it to profile SQL queries.</p>

<p>One could use JAMon <em>even in production</em> as the overhead is very little. It can use exiting Pointcuts and Spring AOP proxies. </p>

