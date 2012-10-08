---
layout: special
title: Software Design
---
Unlike the work done by engineers when building a bridge, a large skyscraper or some machine software development is almost <strong>entirely a design activity</strong>. Why is that?

<strong>There is no construction in software development</strong>

We say we <em>build</em> software but in fact there is really no construction in software development. The closest to construction would be to compile the source code written in a language just as Java, C/C++ or another into bytecode or machine code and then link it, package it so that it can be executed. This piece of the work is fully automated and even most programmers don't think much about it anymore.

<strong>The old way: Analysis, Design, Programming, Test, Deploy</strong>

It is still very common to do software development in a way that resembles closely what happens when building physical things. First needs and requirements are analyzed. Then the object that should fulfill the needs and meet the requirements gets designed, which is what engineers usually do. After the design has been completed and the blueprints exist a contractor is brought in to actually build the thing. If the thing is intended for mass production and to be sold to many customers, first a few are built and then tested. If all is ok, then the product reaches the market and will be sold. 

That is precisely what <em>Analysis, Design, Programming, Test, Deploy</em> is. But does it make sense for a non-physical object such as software?

<strong>Programming and testing are design activities</strong>

<img style="display:block;margin-left:auto;margin-right:auto;" src="/img/design-dictionary.png" alt="Design dictionary" title="design-dictionary.png" border="0" width="511" height="390" />

According to the dictionary design is a plan that reveals intention. Isn't code in a programming language not exactly that same thing? Code is a different way of expressing intent but it is not that far away from the arrows and boxes of a blueprint for a physical building.

Similar as to what an architect does when he designs a building or what an engineer does when he designs a new automatic transmission a software developer (or should I say designer) crafts code that will meet requirements and is fit for the intended purpose.

Hence in software there is only analysis, design and deploy. Because once the code is complete the design is complete and the non-physical thing that software is exists and is working.

<strong>What about the roles of software architect, programmer, tester, analyst?</strong>

According to the dictionary an architect is someone who designs buildings and in many cases also supervises their construction. As in software we don't have construction, there is really no need for a special architect role. Instead a team needs to be comprised by enough senior software developers who are able to come up with a good design for the software.

The roles of programmer, tester and analyst are just roles anyone on the team can hold <strong>temporarily</strong>. There may be people who have very developed skills that makes them a better fit for one role instead of another, but in the end they all are software developers and designers. That also means that any of them can act well in any role.

<strong>Note:</strong> I said "events" and not "phases" because all three certainly occur multiple times throughout a project. A phase is something that starts and finishes and then another phase usually follows or the whole activity stops.