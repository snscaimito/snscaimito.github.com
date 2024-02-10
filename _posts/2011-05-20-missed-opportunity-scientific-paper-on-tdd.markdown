---
layout: post
title: ! 'Missed Opportunity: Scientific Paper on TDD'
tags:
- en
categories:
- software_development
- quality
status: publish
type: post
published: true
meta:
  jabber_published: '1305952960'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1306027305";}
  _edit_last: '6384953'
---
On Twitter someone linked to a scientific paper titled "<a href="http://www.ipd.uka.de/mitarbeiter/muellerm/publications/edser03.pdf">About the Return on Investment of Test-Driven Development</a>". The abstract reads:

<blockquote>
Test-driven development is one of the central techniques of Extreme Programming. However, the impact of test-driven development on the business value of a project has not been studied so far. We present an economic model for the return on investment when using test-driven development instead of the conventional development process. Two factors contribute to the return on investment of test-driven development: the productivity difference between test-driven development, and the conventional process and the ability of test-driven development to deliver higher quality code. Furthermore, we can identify when TDD breaks even with conventional development.
</blockquote>

I would like to call this a missed opportunity.

The authors set out to compare the economic impact of TDD with traditional development that is not based on a test-first approach and try to present an economic model for the return on investment of TDD.

The paper then is filled with many impressive calculations and graphs but basically only talks about the cost of doing TDD vs not doing it and which approach is faster. That is not really helpful and in my understanding just demonstrates a lack of understanding <strong>why</strong> programmers use TDD in the first place.

Benefits are analyzed by looking at what they call the defect-removal-efficiency as that were the goal of practicing TDD.

Here is a quote of their conclusions:

<blockquote>
We propose an economic model for the return on investment of test-driven development. Our analysis of the break-even leads, all other parameters are kept constant, to the following conclusions:

<ul>
<li>The return on investment of TDD depends to a large extend on the slower development of TDD and the higher quality code of TDD.</li>
<li>Other factors like the effort for fixing a faulty line of code, or, the productivity of a developer using the conventional development process, have only minor impact on the return on investment of TDD.</li>
<li>The calculation of the return on investment is independent of the project size, the number of developers, and the developer salary.</li>
</ul>

Our model assumes an experienced TDD team. The additional cost for training which is necessary when first introducing TDD is ignored so far.

Finally, our model strengthens the need for actual empirical figures (or ranges) for the quality advantage and the loss of productivity of TDD, in order to get a comprehensive evaluation of the cost and benefit of TDD.
</blockquote>

This is precisely the very same bad idea as trying to introduce scientific management to software development. See <a href="/2011/05/20/pseudo-scientific-management-kills-innovation-and-creativity.html">my own article</a> and the one from <a href="http://alistair.cockburn.us/Taylorism+strikes+software+development">Alistair Cockburn</a>.

The benefit of doing TDD is in better and cleaner code that is testable. It is a misconception that simply by doing TDD a team can create code faster. Speed is not the concern here.

Code that is developed without doing TDD is more coupled and changing it is much more risky simply because one never can know what breaks until someone actually tries to test the application. Then the next question is how do you test all the code, if the only means of testing is <em>using</em> the application? It is obvious that you cannot test the <strong>whole</strong> application right after you made a change. So you will test after a while and by then many changes have been done and it becomes hard to find out which one broke it. That is a long feedback loop and inherently dangerous.

Managers know that risk is bad and they usually try to mitigate it. So if changing old code that has no tests is risky business, they may play it save and not ask programmers to change it at all. That then either leads to inflexibility, loss market opportunities or the big rewrite project many years later. If the application is somehow important, not doing TDD is by factors more expensive than any expense incurred while doing it. Not doing TDD may lead to loosing the software asset completely or to lost business. Both losses are usually higher than the cost of even a few thousand hours of programming.
