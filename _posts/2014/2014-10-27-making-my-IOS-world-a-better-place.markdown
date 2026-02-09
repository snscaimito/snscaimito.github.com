---
layout: post
title: Making my IOS world a better place
tags:
- en
- ale-news-service
categories:
- atdd
- software_development
---
My little IOS world just became a slightly better place. I figured out a problem that was bugging me for a while and had stopped my attempts of moving forward with ALE News.

IOS applications have to be signed when you want to run them on a real device. That makes sense for applications that are released and are supposed to be run on other people's devices. However, at the moment I'm just starting out with all of that and I only want to run my application on the IOS simulator.

{% include ale-news-post-header.html %}

Because I don't yet have a developer certificate from Apple due to some issues with my Apple ID after an international relocation, I was unable to simple get the right certificate. xcodebuild didn't work for me as it wanted to sign the code.

Just now I found the solution.

	xcodebuild build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO

The two arguments at the end stop Xcode from looking for a certificate and now I can run <code>make-world.sh</code> successfully:

	[INFO] ------------------------------------------------------------------------
	[INFO] Reactor Summary:
	[INFO] 
	[INFO] ALE News ........................................... SUCCESS [  0.324 s]
	[INFO] common ............................................. SUCCESS [  1.208 s]
	[INFO] ALE News Article Service Webapp .................... SUCCESS [ 44.274 s]
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD SUCCESS
	[INFO] ------------------------------------------------------------------------
	[INFO] Total time: 45.969 s
	[INFO] Finished at: 2014-10-27T16:47:33+08:00
	[INFO] Final Memory: 26M/624M
	[INFO] ------------------------------------------------------------------------
	[INFO] Making IOS Application
	Build settings from command line:
	    CODE_SIGN_IDENTITY = 
	    CODE_SIGNING_REQUIRED = NO

	=== BUILD TARGET ScoopArticles OF PROJECT ALE-News WITH THE DEFAULT CONFIGURATION (Release) ===

	Check dependencies

	=== BUILD TARGET ALE-News OF PROJECT ALE-News WITH THE DEFAULT CONFIGURATION (Release) ===

	Check dependencies

	Validate build/Release-iphoneos/ALE-News.app
	    cd /Users/sns/Documents/dev/ale-news-atdd/source/ios/ALE-News
	    export PATH="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin:/Applications/Xcode.app/Contents/Developer/usr/bin:/Users/sns/.rbenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/sns/bin"
	    export PRODUCT_TYPE=com.apple.product-type.application
	    /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/Validation /Users/sns/Documents/dev/ale-news-atdd/source/ios/ALE-News/build/Release-iphoneos/ALE-News.app

	** BUILD SUCCEEDED **

	[INFO] ------------------------------------------------------------------------
	[INFO] Web Services & Application ..... SUCCESS
	[INFO] IOS Application ................ SUCCESS
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD SUCCESS
	[INFO] ------------------------------------------------------------------------

That produces a tested RESTful web service, a web client and an IOS application with share extension in one go.

Next step is now to spin up a web server with the web service deployed to it and run the IOS application on the simulator so that I can interact with the IOS application from a test script and have the IOS application talk to the web service on the local machine.

{% include ale-news-post-footer.html %}
