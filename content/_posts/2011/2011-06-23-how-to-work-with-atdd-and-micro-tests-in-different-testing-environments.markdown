---
layout: post
title: How to work with ATDD and micro-tests in different testing environments
tags:
- en
categories:
- software_development
- atdd
- quality
status: publish
type: post
published: true
meta:
  jabber_published: '1308886729'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1311001676";}
  _wpas_done_twitter: '1'
  _edit_last: '6384953'
---
Based on conversations at a client organization this article is about the options a team has for performing tests using multiple testing environments.

Let's say there is an organization where they use the following testing environments:

<strong>DEV environment</strong>

This environment is used for local development and for demos until the product is deemed production ready. The product then enters the <em>IT environment</em>.

<strong>IT (integration test) environment</strong>

In the IT environment it's all about testing the integration with external services. Everything that is not an integral part of the application being tested. That may be web-services, connections to mainframe services, to some sort of data warehouse and even includes databases that are not under the control of the application development team.

The main purpose of the testing in the IT environment is to verify that all the interaction with those external systems is working properly. If no issues have been detected, the product moves to the <em>ST environment</em>.

<strong>ST (system test) environment</strong>

The ST environment differs from the IT environment in that the data available to the application is different. In the DEV and IT environments the data available may be stale, outdated and inconsistent due to a lot of activities by potentially faulty applications that all use shared systems offering the plethora of external services available in the enterprise.

The ST environment has good data that is regularly taken and updated from production. The purpose of testing in the ST environment is to see whether the application can handle the real data correctly. So the focus changes from integration to data. After no issues have been found the product moves to the final <em>PT environment</em>.

<strong>PT (performance test) environment</strong>

The application works well with all the external services it talks to and can also handle production data. But will the performance be acceptable? The purpose of testing in the PT environment is to put a huge load onto the application and see how it holds up.

<strong>Where to run Cucumber scenarios</strong>

We should run our Cucumber scenarios in all environments except the one for performance testing. Cucumber scenarios touch every piece of the application so it is likely that issues that may exist will show up.

<strong>Specification by example</strong>

When using the <em>specification by example</em> approach we don't treat the Cucumber scenarios as tests to verify behavior. Instead we use the scenarios to document what the application does and are grateful that we also get a pretty good regression test suite for free (free as in beer that is).

<strong>But then we don't test enough in IT and ST - do we?</strong>

It is true that by using <em>specification by example</em> our Cucumber scenarios will not cover each and every permutation of invalid input data neither each and every permutation of all the different paths through the code. 

Cucumber is foremost a tool to specify what the application should do from a business perspective. It is a communication tool and we should use it to speak the same language between stakeholders and team. It helps to bring out the mental image everybody has in their head and put it in a less or non-ambiguous form. By using Cucumber we get tests for free but we don't use Cucumber because we want to test.

<blockquote>
If the only tool you have is a hammer, then everything looks like a nail.
</blockquote>

A software development team has many different tools they can use. A good craftsman knows when to use one tool and not another and why. It is experience that lets him make the right choices. The differences between the tools may be very small and they may all seem to be very similar but to the experienced craftsman the purpose of each tool is very clear and he does not use them just so.

In the year 2011 it can be safely said that for all programming languages there is some kind of unit testing framework available. The purpose of these tools is two-fold. When writing new code these frameworks are used to craft code that is well designed and testable. This is achieved by writing the test before the code. Less code will be written, because one only writes enough code to pass the test. The test becomes the first user of the production code.

The second purpose of unit testing frameworks is actual testing. After the production code has been designed following the happy path testers and programmers look for things that could go wrong. There can be tests that send permutations of invalid data through the production code and prompt improvements to handle it. There are even ways to test timing and race conditions. The development community constantly finds new ways to use unit testing frameworks for more and more special cases.

Therefore some have started to no longer talk about <strong>unit testing</strong> but instead call these tests <strong>micro-tests</strong> to make clear that we are no longer interested in only testing a single class or other small unit of code.

<strong>What should be covered in micro-tests</strong>

Micro-tests should be used to do the bulk of the testing that can be automated. Some will just test a building block such as a validator class. Others will test all the code through several layers from the user interface down to the database. Again others will test communication to external systems like web-services or a mainframe integration.

<strong>But ... How can I test a web-service in a micro-test?</strong>

Well... There are two ways.

You could write a micro-test that actually calls the real web-service offered by some test system. That seems to be a straight-forward approach and is pretty much in line what many pure testers may think should be done. But if you do that, then you depend on the external service. If you run all your micro-tests as part of your build, then you will not be able to build the deployable artifact in the case the external system is down. And it could be down for days. So that's probably not the best solution.

Instead you define a boundary around your application and document that you are only going to test up to that boundary. The boundary is represented by a model for the web-service. To create the model you capture what the web-service has sent back for a given request and then use these captured responses in your micro-tests instead of calling the actual web-service.

<strong>Don't pretend to have control over things that are not yours</strong>

This solves the dependency problem but it leaves you with an uncertainty. From the perspective of your future users your application is broken, if the web-service it relies upon is broken. That's kind of unfair, as you have no control over that web-service.

But then is testing everything that your application relies upon part of your duty as the developer of said application? I think, if you made this your duty, then you were basically pretending you can control these other things. Unless you are really in charge this would be a lie and unprofessional to let others believe it.

<strong>Define and verify the runtime environment for your application</strong>

Many makers of physical products define the environment their products are made for. An example: Widget X is to be used in places where the temperature is between 10 and 40 degrees Celsius and a humidity of no more than 85%.

Why should software products be any different? It is totally normal to say "this program runs on Windows version X" and in that case the program will check the version of the operating system when started. If the program relies on a SQL server, then this will usually be checked too.

Why not simply check out the environment a bit further? Once you have a clear definition of the dependencies for your application and have created the boundary I mentioned above, then it should be easy to check that these constraints are met during startup. If they are not, the application would log or display errors and refuse to do anything else. As the developer of an application you cannot do anything, if the runtime environment is not right. But you can and should verify that environment. That is part of the quality of your product.

If it appears to be impractical to perform these checks each and every time the application starts, you can ship an environment checker program along with it. However, I think that if possible, you should always opt for checking the environment at application start. This will lead to less support calls of any kind.

<strong>"But then I cannot run micro-tests in IT, ST, PT. So my testing is not complete."</strong>

No, you cannot run your micro-tests in these environments. You can run them only at the time your build scripts create the deployable artifact(s).

But then, if you application checks your environment at startup, then you do test. The application checks it environment every time. Something is broken? The application will not start and point out where the issue really is.

That way you can focus on testing the things you control but you still have acted responsibly by making sure that the application's expectation for the runtime environment have been met. If it still breaks, the ball is in your court.
