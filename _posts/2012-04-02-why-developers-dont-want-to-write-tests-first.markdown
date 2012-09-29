---
layout: post
title: Why Developers Don't Want to Write Tests First
tags:
- Coaching
- Thoughts
status: publish
type: post
published: true
meta:
  _edit_last: '33781372'
  jabber_published: '1333378870'
  email_notification: '1333378873'
  _wpas_done_linkedin: '1'
  publicize_results: a:1:{s:7:"twitter";a:1:{i:13640102;a:2:{s:7:"user_id";s:10:"snscaimito";s:7:"post_id";s:18:"186830643953537025";}}}
  _wpas_done_twitter: '1'
---
This is an experimental attempt to finding an explanation of why programmers don't want to write tests first using <a href="http://activitycentereddesign.com">Activity Theory</a>.

The programmer is the subject and writing tests is the object. The outcome of this activity is well tested software.

According to Activity Theory there are rules, community, the division of labor, as well as the mediating artifacts that influence an activity. They themselves, are also influenced by the activity.

Let's go through rules, community and division of labor first.

If there are no rules in place that demand writing tests, then nobody is being forced to do it. In the case of an organization with a traditional test approach (QA after the fact) there might be a rule that requires the team to deliver something that works or else the team will get back a report with a huge number of defects from the QA people. The rule may come in the form of bad performance reports or similar. If that's the case, then there would be an incentive to writing tests to prevent defects.

In the case of the organization with the traditional test approach the community within the organization does not promote writing tests first. There may be a few people here and there but the community at large does not do it. So there is no good example for doing it. "Others don't, why should I?" may be the question some programmers ask themselves in silence.

A huge influencer is the existing way of how labor is divided within the organization. If there are strongly separated groups and membership in these groups is static - based on job description -, then a programmer will not want to do the job of testers. He may be actively prevented from doing someone else's job. In an extreme case he may do work outside of his job description and, who knows, could be accused of violating his work contract. How far this goes is also dependent on the rules and the community factors within the organization.

The fourth element that influences subject and object and is influenced by them is the mediating artifact. For a programmer this refers to the tools he uses to perform his work but also to things like the runtime environment or where software gets deployed too. Things like the version control system, how a build runs, etc. - all that is a mediating artefact. It's basically everything that he uses to make software. Those artifacts are also influenced by the community within the organization and what is being used to make software does shape the community.

If at some point important decisions about tools were made and those tools don't make testing easy, then a community will have evolved where testing first is seen as too difficult and not worth to pursue. A change of those tools might be very difficult, because the community is heavily invested into those tools, as the tools have influence onto rules and the division of labor within the organization.

I will stop here exploring this any further, as this is meant only as a little experiment. However, I hope that it shows how Activity Theory can be used to explain observed behavior. I believe that it can further be used to identify those factors that stand most in the way of making changes that allow the desired activity to happen.

As Activity Theory also takes into account for which reason, the motive, people perform an activity and helps to identify goal-based actions that contribute to the activity, there seems to be another handle for change.
