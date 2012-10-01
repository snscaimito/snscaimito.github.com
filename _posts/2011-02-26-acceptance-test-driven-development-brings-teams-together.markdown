---
layout: post
title: Acceptance Test Driven Development brings teams together
tags:
- Software-Development
- atdd
- quality
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
  jabber_published: '1298740503'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1299824230";}
  _wpas_done_twitter: '1'
---
On Twitter there have been a number of tweets and retweets about ATDD these days. And then there is Elisabeth Hendrickson's post about <a href="http://testobsessed.com/2011/02/25/the-atdd-arch/">The ATDD Arch</a> which I like very much. The arch metaphor fits very well. ATDD is about bringing teams together. It is another tool in the box to prevent silos or, if you happen to have them already, can break them up.

Building a solution in software to a business problem or the process of creating a new business entirely driven by software is simply not the same as manufacture or construct a physical thing based on a blueprint.

In the case of software the point is never that drawing a blue circle will work every time the program needs to do it. Instead it is about that the program be fit for a specific purpose. Software may have no defects and still the whole effort of building the software is one big failure. Not because the programmers failed to write good code. Not because the testers missed bugs. But instead because stuff has been built that is clumsy to use, creates a complicated and inflexible business process, or simply is a bright solution to a problem that really did not exist in the first place.

The good thing about software is that even at a very early stage software can be useful. I remember when I built <a href="http://www.caimito.net">Caimito One Team</a> (an agile collaboration and project management tool) we were using it ourselves only a few iterations in the project. Software does not need to be feature complete to be useful. In fact some say that software never is done.

The trick to achieve an early return on investment is to focus on the really important features first and then build these right. By "right" I mean to meet user expectations. There is no way to meet the expectations of your users, if you don't collaborate with them. It is not enough to give a 30 minutes presentation where you show some highlights. You need constant feedback and involvement from all members of the team. The customer or the user or stakeholder is an integral part of the team and because of that we need a tool that allow these business experts to work with us.

When we built <a href="http://www.caimito.net">Caimito One Team</a> we the programmers were the experts ourselves. That's not a typical situation and we were able to get away with not using ATDD tools like Cucumber, Fitnesse or others. Still we did some kind of ATDD in regular JUnit. That was enough as everybody on the team could work on that level of abstraction.

Tools like Cucumber are great for actual collaboration with users and stakeholders. Instead of pseudo-scientific documents that pretend to capture every little detail we have simple text files written in human language (<a href="https://github.com/aslakhellesoy/cucumber/wiki/Spoken-languages">English or a large number of other languages</a>). We can store these text files in version control and the only tool for users and stakeholders needed to collaborate with us programmers is a text editor. Something as simple as Windows Notepad can do, if you want to.

The true beauty and the real proof for how ATDD brings teams together is that we can execute those Cucumber feature files as if they were real programs. Now for the first time we have something that serves both as textual documentation for non-programmers, can be used as an executable specification to tell programmers which behavior is required and when a particular feature is done, and for QA it serves as a fully automated suite of regression tests. All these benefits are provided by a simple tool and with little effort. One would certainly be foolish not to use that.

But then it is not all that bright.

Software development is still hard and expensive. The pipe dreams of CASE tools that would allow end users to build their own software by drawing boxes and arrows are long gone and ATDD is not a reincarnation of that.

First and foremost the success or failure of ATDD lies in the willingness to collaborate and to  invest significant amounts of time into that. A customer who is not willing to work with the team on each and every Cucumber feature file and the scenarios contained is jeopardizing the effort and basically says to the team "just build it and don't ask me questions". That sends several clear messages. "I don't care much about my own business", "We can burn any amount of money", "I am more important than you and have no time for the project" ... and maybe a few more. All in all such a customer should not wonder to be delivered something that does not meet his expectations - he never made an effort to articulate them.

Testers and business analysts can mitigate the problem of a customer unwilling to collaborate a bit. They can work hard to come up with good features and scenarios by guessing and interpreting the sporadic uttering of the real customer. Unfortunately in the end that leads to more contract negotiating instead of collaboration and basically causes that things on the right of the Agile Manifesto suddenly become more important than those on the left.

And then there is another issue. Testers on a team practicing ATDD need to know how to code. At least enough to write some light Ruby code so that in step definitions the program under test can be controlled and behavior verified. Some testers may simply refuse to learn that. These are not a good fit for an agile team anyways. For those willing to learn new things it should not be too hard to write a bit of code and there are always programmers on the team who can help with more complex things. After all we want to bring the team together and what better opportunity for that is there than to have a tester and programmer pair.
