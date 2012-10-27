---
layout: post
title: Use of a Walking Skeleton in Acceptance Test Driven Development
tags:
- en
- Software-Development
- atdd
- quality
status: publish
type: post
published: true
meta:
  jabber_published: '1306161220'
  _wpas_done_twitter: '1'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1306183352";}
  _edit_last: '6384953'
---
One of the main benefits of Acceptance Test Driven Development is that you have your customer involved and can share executable specifications written in human language with all team members including the customer. That's a major point in favor of ATDD.

Still these creations are just written words. Yes, you can run them against the application once you have built it and it will you that everything is ok. Which is another main benefit. People tend to need some kind of visual to fully feel comfortable with abstract things. Some use wireframes to describe the user interface and then do a walk-through on paper using these drawings. That works but only if the application has a regular user interface where a human user can type and click on UI widgets.

A good while back software developers came up with the idea of a walking skeleton. This has been described in the Crystal Clear book by Alistair Cockburn and in a <a href="http://alistair.cockburn.us/Walking+skeleton">blog post</a>. Alistair says he found this pattern or strategy around 1994 so it is really not a new idea - but as I find a very good one.

Not only when doing ATDD but in every situation of software development I would like to receive early and quick feedback (in no particular order) on:

<ul>
<li>An end to end scenario of some important business action</li>
<li>The quality of then development team</li>
<li>Choices for the initial architecture and tools</li>
<li>Customer's reaction to a very early version of the product</li>
</ul>

<strong>An end to end scenario of some important business action</strong>

Every software program has a number of flows that either a human user or another system interacting with the program under development will use. I'd like to call that a <em>business action</em> because it is an activity to perform some kind of business with a clear goal in mind. The actual implementation of a single business action undoubtedly has a lot of value and may be just enough to deploy the application to production and start using it for real.

When doing ATDD I like to use Cucumber to run scenarios written in Given/When/Then form. After I have identified a valuable business action which appears to be simple enough to be a good candidate for a walking skeleton, I will then look at the expected result. Looking at the result is important. After all that's why the application is being developed in the first place. So once I know what the outcome should be I write a Cucumber "Then" step.

With the expected result in mind I then figure out what is needed in order to produce said result. This will lead to maybe a number of "When" steps, a few preconditions as "Given" steps and likely I will learn that I need to describe the whole business action in multiple Cucumber scenarios.

Important is to develop these scenarios in collaboration with the customer.

<strong>The quality of the development team</strong>

Throughout the project the quality of the development team will have a strong impact on the ability to deliver well written software in a reasonable timeframe. The sooner it is known how good the team is, the less disruptive it will be to make changes.

The only way to find out about the actual quality of the team is to do some real work with a clearly defined goal. Building a walking skeleton as an implementation of the business action expressed in Cucumber scenarios is that goal.

<strong>Choices for the initial architecture and tools</strong>

Whatever my choices are for the (initial) architecture for the application it is a fact that I will never know whether these choices are good or bad until I actually write the code. The goal of producing a walking skeleton puts all my assumptions and decisions to a test. The sooner I find out that I made bad choices the less disruptive it will be to correct them.

I may also find that my choices are ok but I've gone overboard with the architecture and thought about implementing a lot of things that I don't need (a violation of <a href="http://c2.com/xp/YouArentGonnaNeedIt.html">YAGNI</a> - You Ain't Gonna Need It). Again by putting it to a test I have an early opportunity to find something simpler (simpler - not less capable) that requires less effort.

Speaking about effort... Sometimes tools can be a problem too. Tools may be libraries, frameworks or the programs used to write, compile, package and deploy the code. Trying to produce a walking skeleton in short timeframe and bring it in front of the eyes of the customer will quickly show whether the tools are supportive or hindering the team's progress.

<strong>Customer's reaction to a very early version of the product</strong>

Finally once I have achieved my goal of producing the walking skeleton and my customer can use it for the first time we all will know whether we are on the right track or need to make major changes to our initial assumptions.

Not every customer is the same. Some customers are more willing to collaborate than others. A good opportunity to get an indication of the customer's willingness to work with the team is by simply watching their reaction to a bare-bones walking skeleton. Do they recognize the business action that was described in the Cucumber scenarios? Can they see the value of the achievement for the project? Are they forthcoming with details to now add flesh the skeleton or are they disappointed?

The sooner I know how the customer really "ticks", the sooner I can either try to educate and help the customer to better collaborate with the team or - for example as a vendor - decide to abandon the project before getting too deep into an unhealthy relationship.

As this is getting fairly long the next piece will talk about how to actually create a walking skeleton together with Cucumber scenarios.
