---
layout: post
title: Maven2, Eclipse Callisto with WTP and Subclipse working together
tags:
- en
categories:
- software-development
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>A dream has come true. With the Eclipse Callisto release the Web Tools Project (WTP) finally works as one expected it to work. It's the most comfortable environment for developing web application that I've seen so far. The only drawback has been the lack of dependency management for the ever growing number of additional jar files every serious web application requires.</p>

<p>When one talks about dependency management the answer is usually Maven. Maven is a great tool, but apparently it is mainly used by fans of the command line, who don't use any kind of IDE frequently, or as a build tool on the continuous integration server where <a href="http://cruisecontrol.sourceforge.net/">CruiseControl</a> or <a href="http://luntbuild.javaforge.com/">Luntbuild</a> call Maven to perform the build.</p>

<p>But what when you literally live within Eclipse? There is the <a href="http://m2eclipse.codehaus.org/">M2Eclipse</a> plugin that works very well, but it still lacks direct support of WTP. There is a <a href="http://jira.codehaus.org/browse/MNGECLIPSE-105">JIRA entry</a> though that reports about the problem and at the end you will find a very valuable hint to another plugin which links the <em>Maven2 Dependencies</em> classpath container provided by <a href="http://m2eclipse.codehaus.org/">M2Eclipse</a> to the <em>Web App Libraries</em> container provided by WTP.</p>

<p>This plugin is provided by <a href="http://blogs.unixage.com/blojsom/blog/adam.kruszewski/">Adam Kruszewski</a> and is called <a href="http://blogs.unixage.com/blojsom/blog/adam.kruszewski/eclipse/2006/05/02/Maven2-Eclipse-plugin-with-latest-WTP-from-callisto-update-site.html">LibCopy</a>.

<p>If you happen to use it with projects stored in a Subversion repository you probably run into the same problem as did I. Version 1.0.x of the Subclipse plugin doesn't support linked resources. To solve that you have to upgrade to the version <a href="http://subclipse.tigris.org/callisto.html">1.1.x branch for Eclipse Callisto</a>. I got Subclipse 1.1.4 by doing so and now I can use Eclipse and <a href="http://maven.apache.org">Maven2</a> for my web application projects in the most comfortable way.</p>

