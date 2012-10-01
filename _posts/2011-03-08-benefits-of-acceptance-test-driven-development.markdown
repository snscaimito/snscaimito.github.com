---
layout: post
title: Benefits of Acceptance Test Driven Development
tags:
- Software-Development
- atdd
- quality
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
  jabber_published: '1299619007'
  _wpas_mess: ! 'Benefits of Acceptance Test Driven Development: http://wp.me/pKfoa-al'
  _wpas_done_twitter: '1'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1300183781";}
---
Traditionally testing has been an activity after development was done. It seems logically correct to test something after it exists and so the cycle has always been write a specification of some sort, then program it and once a programmer says "I'm done" a tester will verify that the code does what is expected.

With Acceptance Test Driven Development that cycle changes.

Similar to what you do when practicing TDD (Test Driven Development) by using Acceptance Test Driven Development you write the tests before the code. Instead of writing a specification as a static document, you create an executable specification that will run the code to be written and that can be refactored and refined.

Acceptance Test Driven Development changes the work of testers. Not longer are they at the end of the cycle but they are moved to the beginning and in fact they can lead it or at least be of great help. If your team is small and you can't afford dedicated business analysts, a good idea might be to have smart testers help out as analysts and work closely with end users or those in your organization who own the vision for the product being developed.

<strong>It is not about testing at all</strong>

Although the word "test" appears in the name the practice of Acceptance Test Driven Development is not at all about testing. ATDD is another tool in the box to facilitate goal oriented communication and get everybody on the same page. It is about defining in a non-ambiguous way what is desired. 

By using a tool such as Cucumber there is a living document - the feature file - which is shared and used by every member of the team. As this document is written in human language (Cucumber supports features written in English, German, Spanish and many more) there is no barrier of access for anyone.

<strong>Focus is on the problem not how the solution looks like</strong>

To really reap that main benefit of Acceptance Test Driven Development it is important to write features in a way that they really describe the business problem to be solved and not how the user interface of the application will be used. That is usually the hardest part of using Acceptance Test Driven Development and it takes time to learn that important skill. Teams new to this should consider bringing in outside help and retain a consultant for some time.

<strong>No more outdated documents</strong>

Another benefit is that there are less documents in the true sense of the word. Cucumber feature files are source code and they live right next to the other source code in your version control system. And there are definitely no dead, outdated documents that are dragged around but nobody really cares about them.

<strong>Smaller team size and no more throwing artifacts over the wall</strong>

When practicing Acceptance Test Driven Development the whole team collaborates and communicates. That prevents silos from building up and teams may also be smaller. In small teams there is no culture neither a need to hand over artifacts with ceremony attached to it. People just work together naturally.

Teams can be smaller because there are only two important things. The executable specification (the Cucumber feature file) and the working software that passes that specification. To create both you only need a very limited number of people. It needs one person to describe what she wants, another person to put that into an executable specification (a tester writing Cucumber feature and step definitions), and then a programmer or a pair of programmers to make it happen.
