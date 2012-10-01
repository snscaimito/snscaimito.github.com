---
layout: post
title: Estimation creates silos and prevents teams from developing solutions
tags:
- Software-Development
- Management
status: publish
type: post
published: true
meta:
  jabber_published: '1309228076'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1310366590";}
  _wpas_done_twitter: '1'
  _edit_last: '6384953'
---
Allow me to put you in a real life situation. The following is from an iteration planning meeting.

<em>"We have prepared the following 20 stories for this iteration" says the analyst Sarah.

The iteration manager Joe speaking to the programmers and testers gathered in front of them adds "We want you to estimate them all so that we can determine what our commitment for this iteration will be".

Everybody takes a seat and Sarah starts reading the first story. She explains what the story asks for and uses a wireframe to illustrate what the user experience person Hanna has already created.

"Are the scrollbars supposed to show up all the time?" Peter wants to know. Tom, another programmer, adds "we can simply make them hide, if we have enough space".

"Yes, they should always be there. I have created this layout according to our enterprise design guide" responds Hanna.

"Ok, so we will figure out how to show them all the time" says Peter and Tom mumbles "we should show a scrollbar, if there is nothing to scroll ..."

"I don't know how to test for scrollbars" says Cindy who is a tester on the team. "If you are making them a requirement, then I would have to fail our acceptance tests if the scrollbars are not there."

Sarah then asks the team to show their votes. Some of the team think the story is 3 points while others think it is just a 2. Cindy votes for 5 points as she think it will cost some extra time to figure out how to test for presence/absence of scrollbars in a web application. 

Sarah has them vote again and as there are still a few 2s amongst the majority of the 3s, she makes the story a 3 point card.

"Ok. So next story" Sarah moves on to the next card. She repeats explaining what the story is about. This time the product owner Lisa explains a few additional details and the team votes again.</em>

I see a few issues with the situation.

<strong>Silos within the same team</strong>

It appears that analysts, product owner and user experience person have formed a sub team and figured it out all on their own <strong>without</strong> much <strong>involvement</strong> of the other team members. That is basically a silo within the team and in consequence the team isn't a team anymore.

On the other side the group of testers and programmers can be considered another silo. It may even be that they refer to themselves as the <em>technical part</em> of the team which is equally problematic.

<strong>There is no collaborative problem solving</strong>

The whole approach is very <strong>prescriptive</strong>. Testers and programmers are not asked to develop a solution to a problem. Instead <strong>the solution is being presented</strong> to them and they are simply asked for an estimate. If you look closer at what Cindy the tester said, you will also find that apparently the team estimates in time, as she is worried that it may take longer to figure out how to test for scrollbars.

In the situation presented here analysts, product owner and UX person have basically <strong>turned themselves into software developers</strong> although they have <strong>no experience</strong> in writing code of any sort. They view the software from the outside. The UX person is mostly concerned with how information is being presented and how the user interacts with it. The product owner may like Hanna's user interface design but then the software is not the user interface. The UI is an important part but it is just the surface. The analysts probably believe they are doing a good job and are helping the programmers to create a lot of small and well defined stories so that their teammates can focus on writing the  code without being too distracted with other things.

The <em>technical side</em> of the team has let the others <strong>seize their job</strong>

<strong>Why are they doing it this way?</strong>

It might be that the team is using Scrum or a modified version of it. The iteration manager Joe tells them at the beginning of the estimation session that he needs the estimates to determine the team's commitment.

In my opinion there are several hidden issues here. The first one is that the team is expected to tell how long the work will take. They are using points but as you can learn from Cindy's question she is worried about the time needed to research how to test for scrollbars. So somewhere there is a notion of estimating how long it's going to take with this team.

The second issue is that they all <strong>assume</strong> everything is <strong>totally clear</strong> and can now be <strong>constructed</strong>. Based on that assumption the team has split into those who define what should be build and those who build it. The team has not come to the realization that during the so called construction the programmers actually <strong>discover</strong> a lot of additional detail nobody has ever thought about. But they don't make these discoveries because they probably <strong>do not model</strong> in code. So it may further be that the programmers on the team are <strong>not experienced</strong> enough to practice <strong>TDD</strong> and modeling (think of Domain-Driven Development) well. The programmers like small stories that are easy to implement and just write the code to match 1:1 what the analysts have asked for.

The team is <strong>loosing</strong> out on a lot of <strong>opportunities</strong>. The programmers can give valuable feedback and find <strong>discrepancies</strong> when they truly <strong>model</strong> in code. If something is hard to program, takes a long time to code, then that should be understood as a message. The message means that the model isn't right or maybe even that there isn't a model in the first place. Unfortunately less experienced programmers don't know much about modeling in code so they just work hard and don't understand said message. So the issue never gets noticed.

<strong>Consequences of the described behavior</strong>

The prescriptive approach leads to <strong>poor quality code</strong>. That is a serious one but without outside help (meaning a coach) it is rarely detected until it is already too late. When it is the team's ability to deliver and implement new features has already diminished quite a lot.

With the prescriptive approach people may think that all the analysis is already done. After all there are analysts on the team and they have figured out what needs to be done. But then what are the programmers good for? "Well, they have to code it" you may say. Yes, sure that's what programmers do but good code is the one that you can modify easily, bend and twist it in many ways without breaking. And that same good code relies heavily on a good model.

Without a model expressed in code the code may easily become just a bunch of scripts to read and write simple integers and strings from/to the database. Such a code base usually shows a low number of true unit tests simply because there is not a lot of logic to test.

<strong>What creates prescriptive behavior</strong>

Imagine an organization where teams are expected to have a <strong>fully estimated backlog</strong> in order to determine the cost for the project. At first glance such an approach seems to be a good idea. The people who will do the work will provide the estimate and thus based on what they say the true cost of the work will be known.

But then is the true cost of the project really known? What about all the discoveries that will be made once a team of smart people starts solving a problem? It seems unlikely that a few analysts will be able to analyze a problem and create a good solution expressed in small story cards for a <strong>6 months project within a few weeks</strong>. They may be able to create 500 story cards over a few weeks but I think that will be all based on <strong>early assumptions</strong>. If the problem can be solved in a few weeks, then there were no need to pay whole team over 6 months.

So to me it seems more like the attempt of <strong>predicting the future</strong>, create a plan and then manage to plan.

The fact that a team is asked to provide a fully estimated backlog - and a <strong>detailed one!</strong> - creates the prescriptive behavior and discourages the technical team members from developing a solution using the input from analysts, user experience person and product owner. In the end it should be no surprise, if the <strong>quality</strong> of the resulting "solution" is <strong>lower than expected</strong>. The team has been prevented from doing a good job.

Quality has been traded for <strong>false predictability</strong> and it is likely that this happened based on requests from the very same stakeholders who expect a high quality product.

<strong>But wasn't one of the core ideas in Scrum to maintain a fully estimated backlog?</strong>

Yes, it is. But there is a big difference between having 500 stories that are very detailed and having maybe 50 ideas written as stories. There is also a difference between estimating how long the coding and testing may take and sizing the complexity of a story.

The cost of the typical project is usually fully known. It is simply the sum of all salaries, facility costs, etc. times the duration of the project in months. There is usually a budget made available too. So the money runs out after the budget has been spent. There is really no need to recalculate that. Good business people know that and the team doesn't have to explain it to them.

What is much more important than to "calculate" cost is to <strong>build</strong> something of <strong>value</strong>. Something that can be used and in the end makes the stakeholders to want come back to the same people for extensions or with new ideas.

I once built a project management and collaboration tool called Caimito One Team. It was based on Scrum and of course there were a backlog. The tool only allows to estimate in points and in some parts of the user interface instead of a numeric value the words Trivial, Less Complex, Complex, Very Complex and Unknown are shown. The idea was to make it clear from the start that nobody should ever think about how long something may take. It is irrelevant. The tool will calculate velocity (yesterday's weather) using the average of the last three iterations and for that it will use the estimates in <strong>complexity</strong>. The resulting number is useful to the team and in the planning screen the tool advises to fill up or not overcommit. The idea is simply to <strong>manage expectations</strong> without destroying opportunities for good analysis and design.

The team that create Caimito One Team has been using it in the sense of <em>eating one's own dogfood</em> from very early on. There was never a need for very detailed story cards and "accurate" estimates. New story cards were merely ideas for features. Then closer to the iteration these ideas became analyzed further and split into smaller stories that were small enough to be sized up as being less complex.
