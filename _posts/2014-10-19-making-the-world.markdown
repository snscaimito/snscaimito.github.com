---
layout: post
title: Making the world
tags:
- en
- ale-news-service
categories:
- atdd
- software-development
---
So far I've managed to create a simple skeleton of an IOS share extension using a template that ships with Xcode. I'm still learning how that all works and I'm pretty much a complete novice at the topic.

{% include ale-news-post-header.html %}

One thing that I still want to get right from the start is my fully automated build. I'm a big fan of the idea that you run a single command and that creates the whole software product in one go. That process may take a few minutes or a few hours. I expect it to get started with a single command and produce fully tested working software at the end that potentially can be shipped to a customer.

So I wrote a simple shell script called <code>make-world.sh</code> that first runs the already existing Maven build to produce the RESTful Article Service and the associated web client and then continues to build the IOS share extension using the Xcode tool chain on the command line.

At the very end it prints a summary.

	[INFO] ------------------------------------------------------------------------
	[INFO] Reactor Summary:
	[INFO] 
	[INFO] ALE News ........................................... SUCCESS [  0.277 s]
	[INFO] common ............................................. SUCCESS [  0.867 s]
	[INFO] ALE News Article Service Webapp .................... SUCCESS [ 44.078 s]
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD SUCCESS
	[INFO] ------------------------------------------------------------------------
	[INFO] Total time: 45.367 s
	[INFO] Finished at: 2014-10-19T13:23:44+08:00
	[INFO] Final Memory: 26M/736M
	[INFO] ------------------------------------------------------------------------
	[INFO] Making IOS Application
	=== BUILD TARGET ScoopArticles OF PROJECT ALE-News WITH CONFIGURATION Debug ===

	Check dependencies
	Code Sign error: No code signing identities found: No valid signing identities (i.e. certificate and private key pair) matching the team ID “(null)” were found.
	CodeSign error: code signing is required for product type 'App Extension' in SDK 'iOS 8.0'

	** BUILD FAILED **


	The following build commands failed:
		Check dependencies
	(1 failure)
	[INFO] ------------------------------------------------------------------------
	[INFO] Web Services & Application ..... SUCCESS
	[INFO] IOS Application ................ FAILURE
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD FAILED
	[INFO] ------------------------------------------------------------------------

Although the build fails at the moment that doesn't matter as the point is to have it automated.

{% include ale-news-post-footer.html %}
