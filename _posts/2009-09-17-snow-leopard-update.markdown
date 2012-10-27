---
layout: post
title: Snow Leopard update
tags:
- en
- Software Development
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>A few days back I updated my Mac Pro to Snow Leopard. I did a clean install and then restored my data from Time Machine. Somehow the restore encountered permission problems and restored only a small amount of data. I don't know what caused it but after copying the data over on the command line everything works fine.</p>

<p>Now a few days later I can say that Snow Leopard (10.6) feels faster than Leopard (10.5). Except for the different desktop background and the different menus in the dock it doesn't look different or new. As far as I remember 10.6 wasn't meant as a feature release but some kind of overall improvement.</p>

<p>Java lives in two places. One for 1.5 and the other for 1.6 but it's the same binary:</p>

<pre class="codeSample">sol-2:bin sns$ pwd
/System/Library/Frameworks/JavaVM.framework/Versions/1.5/Home/bin
sol-2:bin sns$ ./java -version
java version "1.6.0_15"
Java(TM) SE Runtime Environment (build 1.6.0_15-b03-219)
Java HotSpot(TM) 64-Bit Server VM (build 14.1-b02-90, mixed mode)

sol-2:bin sns$ pwd
/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home/bin
sol-2:bin sns$ ./java -version
java version "1.6.0_15"
Java(TM) SE Runtime Environment (build 1.6.0_15-b03-219)
Java HotSpot(TM) 64-Bit Server VM (build 14.1-b02-90, mixed mode)
</pre>

<p>From eclipse.org I downloaded the latest 64 bit Cocoa based build. It is not available as bundled Eclipse, such as "Eclipse IDE for Java Developers", but instead one has to choose "Eclipse Classic". I downloaded from this URL: <a href="http://www.eclipse.org/downloads/download.php?file=/eclipse/downloads/drops/R-3.5-200906111540/eclipse-SDK-3.5-macosx-cocoa-x86_64.tar.gz">http://www.eclipse.org/downloads/download.php?file=/eclipse/downloads/drops/R-3.5-200906111540/eclipse-SDK-3.5-macosx-cocoa-x86_64.tar.gz</a> and then added</p>

<pre class="codeSample">EPP Packages Repository - http://download.eclipse.org/technology/epp/packages/galileo</pre>

<p>to the package manager. From there on it was an easy select, wait a little and restart Eclipse to get a functional - and fast - IDE for Java development. After adding Subversion and M2Eclipse (Maven plugin) I was back in business.</p>
