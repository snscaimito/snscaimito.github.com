---
layout: post
title: Sun Java VM on Ubuntu Linux
tags:
- en
categories:
- software_development
status: publish
type: post
published: true
meta:
  _wpas_done_twitter: '1'
  _edit_last: '6384953'
---
<p>The newly released Ubuntu 6.06 Dapper includes support for Sun's JVM. It is available in the multiverse repository. In order to access multiverse one has to add these two lines to <code>/etc/apt/sources.list</code>:</p>

<p><pre class="codeSample">deb http://pa.archive.ubuntu.com/ubuntu/ dapper multiverse
deb-src http://pa.archive.ubuntu.com/ubuntu/ dapper multiverse</pre></p>

<p>After <code>sudo apt-get update</code> one can install the Sun Java5 JDK</p>

<p><pre class="codeSample">sudo apt-get install sun-java5-jdk</pre></p>

<p>That was quite easy and painless. It definitely makes deployment of new servers easier than before.</p>

<p><strong>But</strong> unfortunately when you try to install Java applications from the Ubuntu repository you will get the GNU JVM and a bunch of GNU provided jar libraries added to your system. At least for my taste I'd like to stick with Sun's JVM for production use for a while. Usually I install Tomcat manually in <code>/opt</code></p>

