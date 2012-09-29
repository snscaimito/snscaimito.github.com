---
layout: post
title: How to deal with sending email in Acceptance Test Driven Development with Cucumber
tags:
- Software-Development
status: publish
type: post
published: true
meta:
  jabber_published: '1300245232'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1306161978";}
  _wpas_done_twitter: '1'
  _edit_last: '6384953'
---
At times one needs to think a bit harder about how to test something when it goes beyond interacting with web pages or other types of user interfaces. That is usually the case when one system interacts with another. I'd like to share one such case and explain my solution to the problem.

Given there is an application that allows users to register and then they get an email that contains a link that needs to be followed to confirm the reception of said email.

So that states the problem. There are several ways to solve it.

a) use some external mail service and access it via POP3 or IMAP from your Cucumber scripts

b) configure your own internal mail service with mailboxes and then access it via POP3 or IMAP from your Cucumber scripts

c) make the application under test be test-aware and have it write emails to a file instead of using the SMTP transport

Originally I was using MRI Ruby and used approach a). My external mail server was GMail and I accessed it via secure IMAP. For that I had written a simple class that logs into GMail, finds the email of interest, reads the body to find the URL for the link to be followed and then cleaned up by deleting the email. That was little effort and worked very well.

A while later I switched to JRuby because I wanted to use the Maven plugin for Cucumber to run all my acceptance tests as part of the Maven build. The application under test is written in Java. My ultimate goal was to deploy a well tested artifact directly from Maven so that I can start doing continuous deployment to production.

After switching from MRI Ruby to JRuby I noticed that I was now unable to connect to GMail due an issue with the validation of SSL certificates. I tried shortly to tell JRuby to accept whatever the other site presents but then I started to rethink my whole approach.

Why should my acceptance test depend on an external service like GMail? A service I don't control. A service that can be down in the middle of something important and urgent.

<strong>Sure I can turn my laptop into a mail server - but do I need to?</strong>

I'm working on Mac OS X and there is already Postfix as MTA (message transfer agent) installed. I was using it already to send email from the application. As I have extensive experience in running mail servers from "a former life" (I used to run an Internet Service Provider in the late 1990s) that should not be problem. Quickly I typed <code>sudo ports install cyrus-imapd</code> and then it dawned me that there has to be an easier way than to set up a full-blown email service on my laptop.

<strong>No need to test external systems</strong>

There is no law that says your application always needs to do the real thing or talk to any external system for real. All we want is the acceptance criteria to be met and do that in a test that is reasonable enough to show that the application is behaving correctly. In my case it was not at all about proving the ability to actually deliver an email to a place beyond my laptop.

<strong>What I did</strong>

In the Java code a <code>MimeMessage</code> gets prepared and then handed over to JavaMail for delivery. The delivery takes place by calling <code>Transport.send(message)</code>. That was my opportunity. It is a simple method call and who said I can't call something I created and in there I can either send the email by calling <code>Transport.send(message)</code> or write the full email to a file ...

Luckily JavaMail already has the ability to print a message to an OutputStream. So with a simple <code>message.writeTo(new FileOutputStream(messageFile))</code> it ends up in a text file.

On the Ruby side in my Cucumber script I use <code>filename = "/tmp/test-#{expected_recipient}"</code> to look for emails in files. Under test my application writes files like <code>/tmp/test-sns@caimito.net</code>. The rest of my already existing Ruby code that looks for the confirmation link in those emails works unchanged.

Further I was able to remove a wait period from my script. That wait period was necessary because the delivery of an email to an actual mail service (much so when using an external service) can take a while. Now all my scenarios that deal with email run as fast as possible without any delay.

<strong>Build applications that are test aware</strong>

As this example shows sometimes it is necessary that the application under test cooperates and is aware of the fact that it runs under test. As I mentioned I am using the Cucumber plugin for Maven. This runs Cucumbers during the integration test phase. In the pre integration test phase Maven starts up Tomcat and deploys the application to it. I let the application know that it now runs under test and that tells my IoC container to use different implementations at the edges. One is the one described here.

In production nothing gets changed at the edges and the application talks to the real external systems.

<strong>But isn't it dangerous to change the application while under test?</strong>

Yes, it can be. But in my opinion it is much more dangerous not to have clear acceptance criteria and not test enough. There is some remaining risk which can be mitigated by not deploying new code to a large server cluster all at once but instead roll out new code gradually. There have been articles about large web sites where such a gradual rollout is being used successfully.
