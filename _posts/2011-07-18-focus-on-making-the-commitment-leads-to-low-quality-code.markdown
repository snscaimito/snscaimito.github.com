---
layout: post
title: Focus on making the commitment leads to low quality code
tags:
- Coaching
status: publish
type: post
published: true
meta:
  jabber_published: '1311042331'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1311412940";}
  _wpas_done_twitter: '1'
---
<strong>Background</strong>

There is a team of 4 programmer pairs, 4 testers and 3 analysts. The organization expects production code to be written in pairs. They do a three amigo practice which requires the three amigos (analyst, tester, programmer) to talk about each user story before and after the implementation. User stories are reasonably sized. Most are about 2 or 3 points which in this organization translates to 2 or 3 days of work for the programmer pair and tester.

The organization standardized on a modified Scrum process. They expect the project team to provide a fully estimated and fine grained backlog for the scope of the whole project before actual development work begins. The detailed backlog is shared with the contracting entity within the same organization.

Before each iteration the team performs an iteration planning meeting and re-estimates the user stories that have been scheduled for the iteration. The iteration manager together with the analysts, the test lead and the technical lead on the team selects the stories from the backlog that should go into the iteration. During the iteration planning meeting each story is presented by the analysts, discussed and estimated using planning poker.

At the end of the iteration planning meeting the iteration manager looks at the capacity the team has and asks the team whether they want to commit to the points assigned to the scheduled stories. The capacity is determined by how many team members are available during the iteration.

The organization has made it clear that missing the commitment will affect the performance review for each team member.

<strong>Observation</strong>

During the iteration planning meeting analysts present story after story to the rest of the team. Programmers and testers have a brief conversation about each story and then present their estimate. During the three amigos meeting before the implementation of a story the three participants discuss the story briefly and then the programmers go off to implement it while the tester prepares or refines Cucumber scenarios and writes Ruby step definitions to automate the scenario.

Programmers do some limited modeling. There is communication between all three roles during the implementation of a story. Programmers are focused on delivering all the  stories scheduled for the iteration. 

Code quality as measured by Sonar is deteriorating. 

<strong>Conclusion</strong>

In my opinion the extreme focus on making the points leads to less focus on code quality. There is fear. From the perspective of each team member not making the points is far worse than code of low quality.

User stories are not being used to enhance a system step by step with new features. They are used to form some kind of project plan in the form of a story backlog. Then an attempt is made to follow that plan. The programmers treat user stories similar to tasks. Because of the focus on making the points the team does not want to engage in too much mutual problem solving but instead time-boxes this in order to make their commitment.

</hr>
PS: I wrote this post in this format as part of an experiment. All comments are greatly appreciated.
