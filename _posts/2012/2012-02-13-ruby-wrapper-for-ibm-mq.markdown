---
layout: post
title: Ruby Wrapper for IBM MQ
tags:
- en
categories:
- software_development
status: publish
type: post
published: true
meta:
  jabber_published: '1329186294'
  publicize_results: a:1:{s:7:"twitter";a:1:{i:13640102;a:2:{s:7:"user_id";s:10:"snscaimito";s:7:"post_id";s:18:"169245702512328704";}}}
  _wpas_done_twitter: '1'
  email_notification: '1329186295'
---
<p>Currently I'm working on a Ruby gem called "rmq". It is a wrapper library to make the C language API of IBM's MQ product available to Ruby programmers. There has been another gem "ruby-wmq" but it was a C extension and only works with MRI Ruby. That leaves people using other Rubies like JRuby without support. Plus it appears that "ruby-wmq" is no longer supported.</p>
<p>As part of a current client engagement I was doing some experiments about how to best test message flows created with IBM MQ Message Broker. For that I wrote a few helper classes for JUnit that use the Java API for the MQ product. Another experiment was to use SOAP to call into flows exposed as web services. And then I did a sample using the C API.</p>
<p>Eventually it appeared to be best to wrap the C API which also exposes all administrative functions that are not available via any other API. In the end I want to use test message flows via Cucumber and for that I need the ability to create, find, clean and destroy queues on a local queue manager so that every scenario can run completely independent.</p>
<p>I hope that I can make "rmq" and maybe a few other pieces open source and release it all as a gems.</p>
<p> </p>
