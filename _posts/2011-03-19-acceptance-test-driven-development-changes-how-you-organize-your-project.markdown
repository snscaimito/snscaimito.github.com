---
layout: post
title: Acceptance Test Driven Development changes how you organize your project
tags:
- Software-Development
status: publish
type: post
published: true
meta:
  jabber_published: '1300568659'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1306161979";}
  _edit_last: '6384953'
---
Anyone who sets out to develop software does so with a specific motivation. Common motivations are to reduce the cost of some business process, to increase revenue by being able to serve more customers or to create something to sell in the case where the software itself is the product. 

Software development is expensive and it takes quite some time to create something meaningful. Some people see how fast you can use software to solve a problem, but rarely have an opportunity to see what it takes to build that software in the first place. That frequently leads to wrong expectations.

<strong>Risk, Return on Investment</strong>

Because of the cost and time it takes to develop software it seems a good idea to look at the risk involved and understand when there is a return on the investment being made. Whenever some activity takes a long time the risk increases because more and more things can change. If something takes just two weeks, then you will likely be done before something changes. If it takes four months or a year, then almost everything can change. It is simply more likely, because  people have new ideas, competitors are not standing still, new things get discovered, etc.

That means the earlier your investment into software provides something in return, the less risk you have. You may also have covered potential losses to some extend, if you need to stop unexpectedly.

At least that's the theory. Let's see what we as software developers can do to make it work.

<strong>Take on first: High Risk, High Value</strong>

Let's assume you want to build an application that is a provider of data for an established backend system. Let's further assume that your main motivation for building said application is to provide end users a better experience than what they are used to.

Where would you start?

Would you start to work on the user experience, as this is why you are starting the project in the first place?

Or would you start with the integration to the existing backend system?

To answer the question we need to look at risk and value. The motivation we have for doing the work and spending money may not be our best guide here.

If we were starting our project with the user interface, we would certainly be working on the item with the highest value to our stakeholders. After all our stakeholders are paying for precisely that and we want to please them and provide as fast as possible something they can use.

But then if we were starting our project with the user interface, we would incur the risk that we will get to the integration to the existing backend system very late in the project and it may not work very well or not at all, because we assumed a few things that led to a certain design in code - and then it may turn out that these assumptions were wrong. If that happens, there would be the user interface our stakeholders had be waiting for but the application cannot be put into production until the integration to the backend system has been fixed.

So the item with the highest risk is clearly the integration to the backend system. There will be no return on investment at all, if that part does not work. After a 6 months project that produced the perfect user interface the pressure on the team will be extreme and probably the same stakeholders who have been very happy so far will be extremely upset once it turns out that the whole investment is likely to be a total loss unless the integration gets fixed.

What about the value?

After considering the all or nothing nature of the integration to an existing system the value of the integration story is probably much higher than the story about the user interface.

<strong>How Acceptance Test Driven Development helps</strong>

Whenever you start a software project the first question should be:

<blockquote>What is the criteria used by the stakeholders to accept the result of the project?</blockquote>

In my example that leads to a generic Given/When/Then like this:

{% highlight Gherkin %}
Scenario: Our ultimate goal for the project
	Given an application with a well designed user interface
	When the end user enters all the data needed by the backend system
	Then the backend system will receive all the data
{% endhighlight %}

As we want our Given/When/Then steps to be executable, we now have to find out what is the smallest thing that could possibly work and allow the application to pass the test.

For the Given this is relatively easy. We just need an application with some user interface. It does not matter at this point that we do not really build something specific.

For the When we can start out with a simple form with just one element (say a text field) so that we can enter some data and trigger some simplistic code that creates a file, calls a web service, opens up a TCP/IP socket or whatever the interface to the backend system happens to be. At this point we are not interested in completing the work but instead we want to figure out the details. Instead of relying on guesses - as educated they may be - we write some real code and run it.

For the Then we use the backend system to find out about the data that we sent to it during execution of the When step. Maybe there is a user interface we can access using some automation tool. Maybe there is a database we can connect to and run a query. There might be a web service or something else.

So to complete our very first story we need to do as much as is needed to get some data from our application into the backend system and be able to verify the successful reception of that data.

<strong>Make it richer</strong>

Now that we have a "walking skeleton" we can work on making the application do more and more and become more feature complete. Each step of the way we want to prioritize our work based on value and risk. Always think about which story enhances the application's usefulness more when you have to decide which one of two stories is more valuable.

In the case of the application that captures data and provides it to a backend system your nice to have stories are clearly those that enhance the user experience. At least as long as you have gaps in the data you send to the backend system. It does not really matter how your stakeholders perceive this. As a development team you need to educate and explain how you use their money in a responsible and goal oriented way. Everybody needs to understand that we will get to everything - some day - but we need to work based on the real acceptance criteria. The one and only criteria that really counts at the end of the day is working software.

So in the example there is nothing wrong in building a front end application that is nothing more than a bunch of text fields but does send the right data in the right format to the backend system. Next iterations the team can enhance the user experience by using drop-down lists to choose from a range of valid inputs instead of typing in the value and so on.

<strong>Dependencies and interaction in the user interface</strong>

In many applications the user gets asked a few things and the answers determine what he will see on some screens later on. A web site to buy car insurance may want to ask details about the spouse, if the customer has indicated that he is married. Such behavior is simply an enhancement to some other story and it does not prevent the team from building a "working skeleton" that works from end to end.

<strong>Backend systems that want all or nothing</strong>

Say your existing backend system absolutely needs a lot of data and will not accept the input from the "walking skeleton" until it is complete. Instead of going to all the trouble to build all the stuff you need to provide that data, you can simply fake it.

There is nothing wrong in picking one example of valid data and another example of invalid data and simply hardcode whatever is needed to pass it along. Just make sure you have stories for the real thing and put them into your backlog so you won't forget.
