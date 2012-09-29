---
layout: post
title: Evaluating technologies for new product development
tags:
- Software-Development
status: publish
type: post
published: true
meta: {}
---
<p>We are working on a new software product, which will be maintained over several iterations. Although we've created a small working prototype, we are still evaluating technologies we want to use or, as one might want to say, bet on. When you develop a product - and in fact software development is always new product development - you should spend some time thinking about the dependencies your product will have and how these dependencies might affect you and your users. If your solution relies on some third party library and the vendor of that library changes important features or stops development, then that undoubtedly affects you. At the very least you need to provide yourself an answer to the question how dramatically that might affect you and what your ability to cope with it is.</p>

<p>This post is about some of the things we are currently thinking about.</p>

<p><strong>Platform neutral UI</strong></p>

<p>Future customers will use the product locally and remotely accessing a central server over the Internet. The UI needs to be platform neutral. Both requirements lead to a web application. Web applications can be installed locally and offered using the ASP business model. Web applications have a platform neutral UI, as the client application is the web browser and most platforms offer such a software.</p>

<p><strong>10 minutes test</strong></p>

<p>Installation of the product should be as simple as possible to make evaluation a painless process. It's very important that a potential customer can install, set up the product, and play around with it in less than 10 minutes and it should just work. If the product fails the 10 minute test, we might loose a potential customer right from the start and would never hear from him to be able to offer help.</p>

<p><strong>Deployment as standalone application</strong></p>

<p>We can't expect a certain environment other than the JVM to be installed on the machine where the customer wants to evaluate our product. We can say Java 5 is required, but telling the customer to install a complex thing like JBoss, Tomcat, Geronimo or commercial application servers like IBM Websphere or BEA Weblogic would be prohibitive. The best way to get around this problem is to provide a standalone version of the product by using an embedded servlet container like <a href="http://jetty.mortbay.com/">Jetty</a>. The server application can then be installed and started as it were a regular Unix daemon. On Windows it can be deployed as a service.</p>

<p><strong>Data storage</strong></p>

<p>Our prototype was created in good TDD/DDD manner using a file-based repository (hash maps and data objects stored as XML files via the built-in XMLEncoder/XMLDecoder) instead of a complex ORM tool talking to a real database. We wanted to model key objects, learn about their relationship and come up with a basic design very fast. So instead of working on the data layer, we worked on the business objects and <a href="/2007/03/04/1173040249999.html">created some web UI</a> for the basic workflow of the application.</p>

<p>We then came to the point where we would be putting too much work into our file-based repository and started thinking about using an ORM tool. Hibernate is the most prominent one and we have some experience with the 3.x versions and the XML configuration of the object mappings.</p>

<p>When Hibernate was developed XML configuration was the only choice on JDK 1.4. XML configuration can be quite excessive and the developer needs to maintain the Java code and the corresponding XML mapping files in sync. Java 5 introduced annotations to express metadata to the language. As we are working on a completely new product and Java 5 has been out long enough (Java is now at version 6), we decided to go with <a href="http://java.sun.com/javaee/technologies/entapps/persistence.jsp">Java Persistence</a> and the implementation <a href="/2007/03/08/1173410671927.html">Hibernate Annotations</a>. We are still using Hibernate, but don't tie ourselves to a single vendor implementation. Others might provide an alternative implementation of Java Persistence and our changes to substitute Hibernate, if the need arises, are much better.</p>

<p>The old XML approach used by classic Hibernate doesn't tie the application to Hibernate either, but we want to XML as much as possible. Still we believe Hibernate is a good tool and did not want to switch to something completely unknown. So <a href="http://annotations.hibernate.org/">Hibernate Annotations</a> seems to be a good choice.</p>

<p><strong>Web framework</strong></p>

<p>When you develop a web application you should use a web framework and not work directly with servlets. :-) Request-based frameworks were discarded as we want our application to make use of Ajax for a compelling and responsive user interface. Component-based frameworks seem to have better support for Ajax and our first experiments with <a href="/2007/03/04/1173040249999.html">Tapestry 4</a> were successful so far. Instead of writing XML configuration to describe the workflow of the application, we can deal with pages, components, and actions in Java code. For now we can use simple HTML templates and later on let a skilled and creative web designer enhance the look of the application. As Tapestry uses templates that can be manipulated, without damage to the markup required to interface to the Java code, in web designer tools like Dreamweaver that should be a breeze.</p>

