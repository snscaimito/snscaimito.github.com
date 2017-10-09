---
layout: post
title: Building a walking skeleton with the help of Cucumber scenarios
tags:
- en
categories:
- software-development
- atdd
- quality
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
  jabber_published: '1306767750'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1306805785";}
  _wpas_done_twitter: '1'
---
This is the second part of a mini-series about the <a href="/2011/05/23/use-of-a-walking-skeleton-in-acceptance-test-driven-development.html">use of a walking skeleton in Acceptance Test Driven Development</a>. In this installment I want to show how a team can get started with the walking skeleton and what to expect.

The first order of business is to write at least one Cucumber scenario that describes one business action from end to end. It could be something like this or multiple scenarios depending on the application the team wants to build:

{% highlight Gherkin linenos %}
Scenario:
	Given I am a visitor to the pet clinic website
	And my pet &quot;Charley&quot; needs rabies shots
	When I make an appointment
	Then I receive a confirmation email
	And the appointment is known to the office of the pet clinic
{% endhighlight %}

With that the team can get started. The primary objective is to make this scenario pass and it does not matter how pretty the application will look nor should we think too much about any details just yet.

<strong>Deliver something useful in a couple of days</strong>

It is important to build the walking skeleton as fast as possible. It doesn't have to be pretty, but it needs to pass the test expressed in the Cucumber scenario(s). The faster the walking skeleton is delivered and presented to the customer, the sooner there is feedback and the customer sees some working software for the first time. That enables the customer to check his initial assumptions and may lead to a few dramatic changes. At this early stage any change, regardless how big it might be, is cheap. So again: the sooner the whole team can look at and play with actual software, the better.

<strong>The rubber hits the road</strong>

As I was saying in the first post of this mini-series the walking skeleton not only will deliver something to the customer to obtain his feedback but also will put the team to a test. The rubber hits the road and you will know what you can do and where you have deficiencies and need to learn or fix things.

<strong>No place to hide</strong>

Discovering early on where your problems are is healthy and helpful. But then I also made the experience that not everyone likes to be so exposed. For example there might be a programmer on the team who does not possess the skills required to actually deliver something lightweight in a couple of days. While building a walking skeleton there is no place to hide. If that happens an assessment should be done to figure out whether the skills of such a team member can be improved within a short timeframe, the project can afford to have someone learning or not, whether there is budget to bring in a coach, etc. If that is not an option, then at least there is a chance to remove the person from the team and find a replacement so that the remaining team can deliver.


<strong>Related:</strong> In his blog post <a href="http://blog.gdinwiddie.com/2011/05/25/avoiding-iteration-zero/">Avoiding Iteration Zero</a> George Dinwiddie writes about the same thing. He does not use the term walking skeleton but instead he suggest to get started with one obvious thing that is the main purpose of system being built but the intent is exactly the same.
