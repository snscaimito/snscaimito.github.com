---
layout: post
title: Setting a specific HTTP return code in Tapestry event handlers
tags:
- en
- Software-Development
status: publish
type: post
published: true
meta:
  delicious: a:3:{s:5:"count";s:1:"0";s:9:"post_tags";s:0:"";s:4:"time";s:10:"1267879890";}
  _wpas_done_twitter: '1'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1267879893";}
  _edit_last: '6384953'
---
Java web frameworks help a lot in creating web applications. They abstract away a of the details of the HTTP protocol and if you use a component based framework, you get even more abstraction and pre-canned solutions for many tasks. As these frameworks are created to help in application development these employ a subset of HTTP features and sometimes do things that are contradictory or at least not very helpful to SEO (Search Engine Optimization) efforts. I've come across such a little detail and had to do some research to figure out how to solve the issue.

SEO is about creating HTML pages that are likely to appear high in the search results for many queries. SEO can be seen as some kind of black magic and in fact there appears to exist some kind of race or competition between search engine developers and SEO agencies. The people behind search engines try to figure out a way to show the most meaningful pages first in the result for query while SEO folks have a monetary interest in making sure that their client's site gets listed first although it may not hold the most important or authoritative content for a given topic. Once you want to sell something that a lot of other people sell too, it is no longer about the content of your site. It is simply about exposure to more potential customers than others. That is why search engine ranking can have a significant impact on the bottom line.

Little details can make a huge different. One of those little details is how you do an HTTP redirect.

The HTTP protocol knows two status codes for redirects. One is 302 which means the page has been moved temporarily. The other is 301 which means the page has been moved permanently to a different location. You can see that the Web and thus the HTTP protocol was invented as a means to distribute documents. It wasn't meant as a client-server protocol for applications. A URL defines the location of a document so that you can refer to it in a hyperlink or in another medium such as in an email. Now that we create interactive applications that resemble desktop applications we are stretching all this a bit and new challenges arise.

Search engines still think about the pages of an application as documents. They crawl everything they have access to and build an index of all the textual content. I guess they don't care whether a page is an article about a product or is a product details page in some kind of product catalog with an order button.

Some search engines highly respect the difference between 302 (moved temporarily) and 301 (moved permanently). If you redirect from http://www.domain.com/app/mypage.html to http://www.domain.com/another/place/mypage.html with a 302 return code, the old URL will stay in their index. You might remove the old document and change other links so that after this is done only the new URL will be indexed. While both documents are available you may get punished for having duplicate content online. If you tell the search engine with a 301 return code (moved permanently) that the old URL won't come back, it will delete the old URL from its index and no punishment for duplicate content can occur.

So that's the background of why it is important to be able to set a specific HTTP return code. I had this issue during the development of a web application with the <a href="http://tapestry.apache.org">Tapestry</a> web framework and needed to find a clean solution that goes well along with the ideas of a component based framework. Although you can simply resort back to HTTP servlet programming in <a href="http://tapestry.apache.org">Tapestry</a> pages it is not really the best idea. It violates separation of concern because doing such stuff in a page class mixes application logic and HTTP protocol handling, may violate Don't Repeat Yourself (you may need that in more places) and makes testing harder because suddently tests need to deal with all the servlet stuff as well.

After <a href="http://old.nabble.com/301-vs-302-redirects-due-to-SEO-ts27165953.html">a post on the <a href="http://tapestry.apache.org">Tapestry</a> mailing list</a> I got a very helpful reply by Lutz Hühnken who suggested to contribute to <a href="http://tapestry.apache.org">Tapestry</a>'s ComponentEventResultProcessor a new HttpStatusCode class. With that in place one can return an instance of HttpStatusCode from event handlers instead of just strings with the name of a page or a page class object.

Now a line like

<code>return new HttpStatusCode(HttpServletResponse.SC_MOVED_PERMANENTLY, link) ;</code>

solves the problem described above. This redirects the user agent to the URL link with a 301 return code instead of the usual 302 (moved temporarily).

Here is the snippet to contribute to the ComponentEventResultProcessor:

[sourcecode language="java"]
public static void contributeComponentEventResultProcessor(
    MappedConfiguration&amp;lt;Class, ComponentEventResultProcessor&amp;gt; configuration, 
    final Response response) {
  configuration.add(HttpStatusCode.class, new ComponentEventResultProcessor() {
    public void processResultValue(HttpStatusCode value) throws IOException {
	  if (!value.getLocation().isEmpty())
	    response.setHeader(&quot;Location&quot;, value.getLocation());

	  response.sendError(value.getStatusCode(), &quot;&quot;);
    }
  });
}
[/sourcecode]
