---
layout: post
title: ! '[TSE] System Integration Testing with Spring'
tags:
- Miscellaneous
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>Fixing defects at a late stage in a project is more costly and causes more pain than doing it as early as possible.</p>

<p>Testable code is good code. Testing is essential to agile processes. AOP helps to isolate concerns. Infrastructure can be left out of the business logic and hence makes testing the business logic easier or - in some cases - possible.</p>

<p>Developers should take ownership of unit and integration tests and not rely on a QA function. A QA function is still needed, but developers should start testing while writing code. Many developers don't test the UI, which is bad. <a href="http://jwebunit.sourceforge.net/">JWebUnit</a> can help with that for web applications.</p>

<p>Rod stresses the importance of performance assurance and regression testing. <a href="http://grinder.sourceforge.net/">The Grinder</a> is a free tool for load testing.</p>

<p>Unit testing. Don't use Spring in a unit test. Do use mocks or stubs. Unit tests should run extremely fast. With mock objects you can create expectations. See <a href="http://www.easymock.org/">Easymock</a> or <a href="http://www.mockobjects.com/">Mockobjects</a>. Mock objects are great for service layer objects and domain objects and to test what happens in the event of a failure. A few things that make testing hard: static methods, final classes. You can't test in isolation: configuration, JDBC code or O/M mapping and how classes work together.</p>

<p>Artifacts to test: service layer, domain objects, special cases such as aspects, web tier code, code containing SQL or other queries and code interacting with J2EE APIs. Non-Java code like stored procedures or triggers, database schema and views. O/R mappings, Spring configuration, JSPs and other view technologies. With Velocity you can test the without being tied to a container.</p>

<p>In-Container testing with tools like Cactus is not the answer.</p>

<p>Spring helps with the org.springframework.test package available in spring-mock.jar since Spring 1.1.1. Provides Spring context loading and caching, transaction management and - of course - dependency injection.</p>

<p>Put things like the datasource and transaction manager declaration in configuration files of their own so you can use different ones for testing and production use.</p>

<p>If you are on Java5 use AbstractAnnotationAwareTransactionalTests for tests.</p>

<p>Use the JDBCTemplate exposed by the abstract classes to verify that the O/RM tool did what it's supposed to do.</p>

<p>Test lazy loading with endTransaction()</p>

<p>startNewTransaction() to test attach/detach in an ORM tool (merge() or saveOrUpdate()). Test locking strategies.</p>
