---
layout: post
title: Smells in Cucumber features
tags:
- Software-Development
- atdd
- quality
status: publish
type: post
published: true
meta:
  jabber_published: '1299685819'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1300792829";}
  _wpas_done_twitter: '1'
  _edit_last: '6384953'
---
As with other forms of source code there are code smells in Cucumber feature. They should be avoided.

<strong>Clicking, filling out forms, detailed handling of the user interface</strong>

Creating a Cucumber scenario where you describe in detail how the application's user interface will be used is missing the point. Acceptance Test Driven Development is not about testing how something works. It is about creating a specification of expected behavior and outcomes from the outside in before the application's code is written. You should express in a Cucumber scenario <strong>what</strong> the application should do and not <strong>how</strong> it will do it.

In some cases the existence of such prescriptive scenarios may even point to some organizational dysfunction as the root cause. Maybe the team gets handed very detailed descriptions of how the application should look like and work by a group outside the team and the team is expected to create exactly what has been handed to them on paper. The team will want to test well and so they end up writing Cucumber scenarios that test the user interface as it were record and play back.

The danger here is that the whole organization misses an opportunity and spends a lot of money on a wasteful activity. Designers say that form should follow function. If you create the form before you clear on the desired function, you limit your options too early. In the end smarter or simpler solutions cannot be found because the how has already been defined. Even worse. The how has been defined by people who probably don't know much about what it takes to write the code for it. So instead of working on a solution to the original business problem the team is working on implementing a very specific user interface and is likely to take shortcuts elsewhere because time runs out. A likely candidate that may be neglected is the business logic. It may take quite a while for someone to notice that because the applications looks as expected and asked for, everybody is happy and only after the application is in production the shortcomings and missed opportunities will be seen.

<strong>Scenarios without a "When" step</strong>

There may be cases where a scenario without a "When" step is justified and valid but in general a missing "When" means that there is no action. Rarely applications just sit there.

I've seen this smell in combination with stories that only ask for a specific user interface to be present. The story does not ask for any action to happen but merely says that x, y, and z should be on the screen. That leads to a scenario with a number of "Then" steps immediately after one or multiple "Given".

Again this may highlight the same organizational dysfunction as mentioned above. The team should ask the product owner and stakeholders what the real business value is and if necessary educate them about the opportunities that everybody will miss out on.

Another possible root cause for such scenarios and stories may be that in the organization there is little trust in the abilities of the development team so business experts try to be very specific and prescriptive.
