---
layout: post
title: Telling real stories in Acceptance Test Driven Development
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
  jabber_published: '1298069966'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1299685661";}
  _wpas_done_twitter: '1'
---
Recently I was able to influence the way user stories and Cucumber features are written at one of my clients. They are not yet a fully agile organization. People in many different departments produce a large number of documents that range from verbal descriptions of expected behavior to very detailed "blueprints" for the user interface. These documents go from a very high level (kind of "here is what we want") over several layers down to a very detailed description of every single button, checkbox etc. The "blueprints" for the user interface are drawings that show the expected real user interface with fonts, sizes, colors and even distances between elements in pixels.

In this organization they create a Word document for each user story which contains a narrative based on the other documents that were created, discussed, and approved before followed by a drawing of the screen based on the "blueprints" from the user experience group. At the end of the "story document" the business analyst puts the acceptance criteria written in Gherkin format.

A tester started to work on a Cucumber feature for a story that was about getting into the application, choose between two different types of business and then start the process of gathering more information that the application under development will require. When I joined him for a pairing session the scenario he had written so far looked like the following example:

[sourcecode language="text"]
Scenario: Start new business
	Given the application has been started
	And the radio button for new business is selected
	And the effective date has been set to &quot;02/15/2011&quot;
	And the state is &quot;KY&quot;
	When the user clicks the start button
	Then the framework for the new business screen appears
[/sourcecode]

A Cucumber scenario like the one shown here is basically a scripted version of record and play back used in more traditional testing tools. The steps prescribe precisely what a user would do using mouse and keyboard. 

The last line of the example reveals another interesting detail too. As the team had just started to build this application, there is not much there yet. So here and there they just want to build a framework for something which in this case is basically an empty window or in some cases a window with a few text labels in it.

Here is what I suggested:

[sourcecode language="text"]
Scenario: Start new business
	Given &quot;Joe Kentucky&quot; is using the application
	And the quote is for &quot;Sam Smith&quot; who lives in &quot;Kentucky&quot;
	And &quot;Sam Smith&quot; has not been a customer before
	And the insurance policy should provide coverage by &quot;02/15/2011&quot;
	When &quot;Joe Kentucky&quot; starts a new quote
	Then the framework for the new business screen appears
[/sourcecode]

So what's the difference?

By using personas in my steps the story told is much richer. With a few key personas defined the whole team can talk about what these people do and what they expect and when referring to them by name all that background knowledge is always present in the minds of the team members. There is a technical advantage as well. The name of a persona can be used as a key into data structures for <a href="http://www.cheezyworld.com/2010/11/21/ui-tests-default-dat/">default data</a>. So by referring to "Sam Smith" I automatically get access to eg. that person's address or whatever the application needs. I don't have to write all these details in each and every scenario which would make my scenarios much more brittle and hard to read.

Then the second scenario clearly tells what this is about from the perspective of someone who is preparing a quote for an insurance product. No end user wants to click buttons. They use a computer and the software it runs on it for a purpose which is not playing with the UI.

As the whole point of Acceptance Test Driven Development is that I am able to discuss scenarios with a real end user - my customer - I have to speak their language. If I talk about something else every time we meet, they will never trust my ability to deliver a solution. Some may simply shop elsewhere while others - in a larger organization - will happily support any effort towards a heavy process where seemingly clearly written step-by-step instructions get handed over to these programmers who don't understand the business. "Just code it" ...

But still, a tester would now say, when running the Cucumber scenario it is necessary to click on the radio button, populate a date field with the effective date and click that start button.

That can be done quite easily.

[sourcecode language="ruby"]
Given /^&quot;([^\&quot;]*)&quot; is using the application$/ do |persona|
  @current_agent = DefaultDataHelper::load(persona)
  @pid = LaunchHelper::launchApp
end

When /^the quote is for &quot;([^\&quot;]*)&quot; who lives in &quot;([^\&quot;]*)&quot;$/ do |persona, state|
  persona_default_data = DefaultDataHelper::load(persona)
  persona_default_data[:residency_state].should == state

  @current_customer  = { :customer_name =&gt; persona }.merge persona_default_data
end

When /^&quot;([^\&quot;]*)&quot; has not been a customer before$/ do |persona|
  @current_customer[:new_customer] = true
end

When /^the insurance policy should provide coverage by &quot;([^\&quot;]*)&quot;$/ do |coverage_start_date|
  @current_customer[:coverage_start_date] = coverage_start_date
end

When /^&quot;([^\&quot;]*)&quot; starts a new quote$/ do |persona|
  @current_agent[:agent_name].should == persona

  screen = PolicySalesScreen.new
  screen.start_quote @current_agent, @current_customer
end
[/sourcecode]

Run the feature and you will get:

[sourcecode language="text"]
In PolicySalesScreen.start_quote we will use automation to control the UI
{:agent_name=&gt;&quot;Joe Kentucky&quot;, :office_state=&gt;&quot;KY&quot;}
{:new_customer=&gt;true, :coverage_start_date=&gt;&quot;02/15/2011&quot;, :customer_name=&gt;&quot;Sam Smith&quot;, :residency_state=&gt;&quot;Kentucky&quot;}
 
You can implement step definitions for undefined steps with these snippets:
Then /^the framework for the new business screen appears$/ do
  pending # express the regexp above with the code you wish you had
end
1 scenario (1 undefined)
6 steps (1 undefined, 5 passed)
[/sourcecode]

So now you have a failing test and can start development. The programmer working on the story will know the context and intent and hence write better code that will reveal the same intent as the story does.
