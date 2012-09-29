---
layout: post
title: Java stack for all purpose development
tags:
- Software-Development
status: publish
type: post
published: true
meta: {}
---
<p>You can't know everything and have experience with any and all technologies that might be used to solve a given problem. Instead it is a good idea to limit yourself to a certain set and become in an expert in those. The deep knowledge you will gain will allow you to solve problems quickly and at reasonable cost, because instead of struggling with technologies that are new to you, you will be working on the problem itself. Seldom clients pay for research, but expect a product in short time.</p>

<p>For the needs of Caimito we've defined a stack of Java technologies for three tier applications on the web (thin client) or on the desktop (thick client).</p>

<p align="center"><img src="images/3TierArchitecture.png" border="0" height="447" width="482" alt="3TierArchitecture.png" /></p>

<p><strong>Presentation Layer</strong></p>

<p>For thick client applications the choice is relatively easy. Java comes with <a href="http://java.sun.com/javase/6/docs/technotes/guides/swing/index.html"><strong>Swing</strong></a>, although there is RCP (rich client platform) from the Eclipse Foundation. RCP might provide technical advantages through the use of platform-specific native libraries for UI elements, but I believe it will always be easier to maintain Swing code as there will probably be more people with Swing knowledge than those who know <a href="http://wiki.eclipse.org/index.php/Rich_Client_Platform">Eclipse RCP</a>.</p>

<p>For thin clients on the web a large number of technologies is available and almost every other month something changes or is added to the list. At some point you may think that building web frameworks is the favorite hobby of the Java community. Our stack contains three web frameworks and two different rendering technologies for the request-based frameworks Spring MVC and Struts.</p>

<p><a href="http://struts.apache.org/"><strong>Struts</strong></a> is the oldest and probably the most well-known web framework for Java. It is request-based and is action driven. Recently another web framework called WebWork has been renamed to Struts 2 after the original Struts team and the folks from WebWork decided to join forces. Now there is the old Struts with a large number of applications built with it and the new <a href="http://struts.apache.org/2.x/">Struts 2</a>, which is essentially WebWorks at the moment.</p>

<p><a href="http://static.springframework.org/spring/docs/2.0.x/reference/mvc.html"><strong>Spring MVC</strong></a> is part of the Spring Framework and request-based as well. It's prominent feature is good data binding capability. Form data gets bounds to a domain model object that is passed into a controller class where the data can be processed. Spring MVC is very light weight and can as well be used for remoting purposes to process data POSTed from non-browser clients.</p>

<p><a href="http://java.sun.com/products/jsp/">JSP</a> and <a href="http://velocity.apache.org/">Velocity</a> are two rendering technologies that can be used to create web pages enriched with data from your domain objects. JSP requires the Java compiler to be present on the web server, as this Sun technology uses template files (HTML with additional markup) that are pre-compiled to Java classes. Velocity is a template engine available from the Apache Foundation. With Velocity not only can be used to enrich HTML pages with domain model data, but as well to create emails and any other kind of file as it doesn't care about the file's content but its own tags.</p>

<p><a href="http://tapestry.apache.org/"><strong>Tapestry</strong></a> is a completely different animal. Tapestry is a component-based framework - and to be honest - is way ahead of any request-based framework. Instead of carefully matching the content of HTML pages to your Java code, you use Java components to create HTML pages. Those components contain HTML fragments. Layout and appearance are added via layout templates and CSS stylesheets. You can have a web designer take care of that part and let Java developers create the application without running the risk that they are stepping on eachothers toes. Tapestry doesn't need any rendering technology due to its component-based approach and direct rendering of HTML. The latest version, <a href="http://tapestry.apache.org/tapestry5/">Tapestry 5</a>, allows to develop with a speed usually known from scripting environments due to its unique dynamic class loading feature.</p>

<p><strong>Business Layer</strong></p>

<p>In the business layer we make sure to have no dependencies on any presentation or infrastructure technology at all. The business layer is comprised of pure POJO classes that are small, do one thing well and can easily be unit-tested with <strong>JUnit</strong>.</p>

<p>As past experiences have shown techniques such as TDD (test driven development) and DDD (domain driven development) help in the design of a good domain model, which is well suited for the purpose of the application without getting bloated or hard to maintain. Instead of trying to come up with a great design upfront and then implement it (that would be waterfall), writing unit-tests to solve problems at a high abstraction level is really a good idea and very agile.</p>

<p><strong>Infrastructure Layer</strong></p>

<p>Our infrastructure layer is hidden behind the <a href="http://www.springframework.org/"><strong>Spring Framework</strong></a> to reduce the amount of intimate knowledge of all the different and constantly emerging J<em>whatever</em> technologies. Spring Framework provides a unified and simplified way of accessing important middleware technologies via its templates. For a lot of third-party libraries documentation is available how to wire them up with Spring. A developer with good knowledge about how to use the Spring Framework doesn't need to become an expert in a large number of infrastructure APIs. Instead he can concentrate on the upper two layers (business and presentation) that appear to be more important to the client. The implementors of the Spring Framework have done most of the work beneath the hood.</p>

<p>Similar as the Spring Framework the <a href="http://www.hibernate.org/"><strong>Hibernate</strong></a> project has created a wonderful ORM (object-relational mapping) tool, which can be used through Spring templates. As our stack is Java 5 based we use <a href="http://java.sun.com/javaee/technologies/persistence.jsp">EJB3 Java Persistence</a> annotations to configure entity classes that get mapped by Hibernate to the database. That way are don't depend on the Hibernate implementation of EJB3 directly and could exchange it for something else. At the same time we don't depend on any particular database implementation thanks to Hibernate's support for various SQL dialects. So whether MySQL is enough or it need to be Microsoft SQL Server or Oracle, we are prepared and our client can benefit from a wise choice of technology.</p>
