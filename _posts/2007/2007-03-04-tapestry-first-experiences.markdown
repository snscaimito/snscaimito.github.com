---
layout: post
title: ! 'Tapestry: first experiences'
tags:
- en
categories:
- software_development
status: publish
type: post
published: true
meta: {}
---
<p>Together with Fidel, Caimito's new hire in Panama, I started to experiment with the component-based web framework <a href="http://tapestry.apache.org">Tapestry</a>. We were inspired by Brian Sam-Bodden's book <a href="http://www.amazon.com/Beginning-POJOs-Lightweight-Development-Hibernate/dp/1590595963/ref=pd_bbs_sr_1/105-4060228-7518846?ie=UTF8&amp;s=books&amp;qid=1173036748&amp;sr=8-1">Beginning POJOs</a> and Brian's personal recommendation of <a href="http://tapestry.apache.org">Tapestry</a>.</p>

<p>There are two types of web frameworks: request-based and component-based. </p>

<p>Request-based frameworks like, Struts, WebWorks (now Struts 2), SpringMVC and others expose the HTTP request/response cycle directly and only map that to actions or controllers where you code something to do the work. These frameworks expect you to code the action and provide the view with some other technology. Common view technologies are JSP, Velocity, FreeMarker and others. These view technologies combine HTML tags from a template with values that are injected by the framework and carry your output information.</p>

<p>Component-based frameworks don't expose the HTTP request/response cycle and they don't use a separate view technology. Instead they let you create your application in Java without thinking too much about the web. Sun's JSF (Java Server Faces), Apache MyFaces (an implementation of JSF) and Tapestry are component-based frameworks.</p>

<p><strong>Everything is a component</strong></p>

<p>With Tapestry everything is a component starting with the web page itself. Instead of a lot of XML files Tapestry 4.1 comes with annotation support. Add an extension to support Acegi Security and you can use the following code to create a secured page accessible by authenticated users with the role ROLE_USER only. The HTML comes from a file SomePage.html.</p>

<pre class="codeSample">@org.acegisecurity.annotation.Secured("ROLE_USER")
public abstract class SomePage extends BasePage {
}</pre>

<p><strong>Links</strong></p>

<p>If you want to link to <code>SomePage</code>, you write:</p>

<pre class="codeSample">&lt;a href="#" jwcid="@PageLink" page="SomePage"&gt;Some page&lt;/a&gt;</pre>

<p><strong>Form handling</strong></p>

<p>Let's say you want to code a page with a search form. You create an HTML template called Find.html (formatting details omitted for clarity):</p>

<pre class="codeSample">&lt;form jwcid="form@Form" listener="listener:doSumit"&gt;
&lt;input jwcid="search@TextField"	value="ognl:idNumber"/&gt;
&lt;input type="submit" jwcid="@Submit" value="ognl:messages.getMessage('submit')"/&gt;
&lt;/form&gt;</pre>

<p>Tapestry makes use of the fact that web browsers ignore tags and attributes they don't know. <code>jwcid</code> is used to refer to a component and the other non-HTML attributes are passed on to the component referred to by <code>jwcid</code>. This template creates a form with an text input field and a submit button. Further you can see Tapestry's support for internationalization. <code>ognl:messages.getMessage('submit')</code> reads the value for the submit key from a Java resource bundle. So you can create properties files Find.properties (default), Find_es.properties and Find_de.properties to support English (en) and Spanish (es) specifically and leave everything to the values in the default file Find.properties. Quite easy - isn't it?</p>

<p>Next is the code for the Find page:</p>

<pre class="codeSample">@org.acegisecurity.annotation.Secured("ROLE_USER")
public abstract class Find extends BasePage implements PageBeginRenderListener {

	public abstract void setIdNumber(String idNumber);
	public abstract String getIdNumber();

	@InjectPage("EditUserStory")
	public abstract EditUserStory getEditUserStory();

	@InjectPage("UserStoryDoNotExist")
	public abstract UserStoryDoNotExist getUserStoryDoNotExist();

	@InjectObject("spring:repository")
	public abstract FileBasedIssueRepository getFileBasedIssueRepository();

[...]
	public IPage doSubmit() {
		if (getIdNumber() != null) {
			Long id = Long.parseLong(getIdNumber());
			UserStory userStory = getFileBasedIssueRepository().find(id);

			if (userStory != null) {
				EditUserStory editUserStory = getEditUserStory();
				editUserStory.setUserStory(userStory);
				return editUserStory;
			}
		}
		return getUserStoryDoNotExist();
	}
}</pre>

<p>The @InjectPage annotation lets the Find class know about other pages. With @InjectObject you can inject into your class references to HiveMind services. Tapestry 4.x uses HiveMind and IoC container. With @InjectObject("spring:repository") we inject a Spring bean called repository. So you can see there is an easy way to combine Tapestry and Spring although Tapestry doesn't use Spring.</p>

<p>Further down in the doSubmit method the return value represents the page Tapestry should show to the user. To us as Java developers this is just a page object and has nothing to do with any kind of HTTP redirect. That's nice, because we can stay within the world we know.</p>

<p><strong>Learning curve</strong></p>

<p>One might expect that Tapestry's learning curve is high. But to my surprise it isn't. Fidel had never worked on a web application, but has worked on Swing applications before. It took him 3 days to set up his work environment (Eclipse, Maven), read about Tapestry, check out the samples from Tapestry's tutorial. After that warmup he got productive and created a useable application with business logic and even some nice design in CSS within a week.</p>

<p>So in my conclusion Tapestry is a very productive framework. Of course there is more to explore. On the 3rd day we started to explore how to create custom components and in that area is most of the stuff to learn more about.</p>
