---
layout: post
title: Validation rules for form input in Acceptance Test Driven Development
tags:
- en
- Software-Development
- atdd
- quality
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
  jabber_published: '1300727167'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1304615667";}
---
A lot of business applications present forms to the user and there is always the need to validate user input into these forms. Should we test validation of form input in a Cucumber feature when practicing Acceptance Test Driven Development?

To me Acceptance Test Driven Development is not about testing. Based on that testing validation rules is doing the wrong thing for the right reason. Of course you need to specify your validation rules somewhere and test them. However, there are many different tools in a team's toolbox. Some are for a very similar purpose but as in the physical world there is a reason why you keep all of them in your toolbox and not rely on a single tool for every job.

<strong>Unit testing a validator class</strong>

Regardless of the programming language you are using you can probably create something like a validator class - basically some piece of code where you keep all the validation rules. It should be easy to test drive that and then you just have to make sure you reuse it in all the places where you need validation of input.

<strong>Tell a good story and still show that input is being validated</strong>

In your Cucumber features you should always tell a good story based on what your customers tell you. You should use their language and not say that a first name in a form cannot have special characters like $%^&amp; or similar. Real end users don't care about that kind of detail. They care about that the application works and doesn't crash.

Still there may be a need to prohibit the input of those special characters for some valid reason. If that is the case, then it becomes part of your acceptance criteria and it should be shown in a Cucumber feature. After all Cucumber features are our primary means of communication and these .feature files are also documentation that may be required for regulatory reasons.

On the other hand you should not repeat in your Cucumber feature what the unit tests are already doing. Keep it short and keep it to the point. You may tell a good story in the happy path scenario and then show that input gets validated in another scenario. I think it is enough to say that "invalid input will be rejected" in most cases. If you are required to show explicitly what "invalid input" is, then you may show an example in a "When" step.
