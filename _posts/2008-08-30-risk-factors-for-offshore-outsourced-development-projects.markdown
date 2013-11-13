---
layout: post
title: Risk Factors for Offshore-Outsourced Development Projects
tags:
- en
categories:
- software-development
- management
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>Reading blogs tonight brought me to the following post. I would have left a comment on Larry's blog but as this topic is related to the <a href="http://www.caimito.net">product we are developing</a>, I thought I should create a post of my own here. The highlights are Larry's as in his original post.</p>

<blockquote><a href="http://www.knowing.net">Larry O'Brien</a> in <a href="http://www.knowing.net/PermaLink,guid,3fe68f89-af8a-434c-a54d-95ff63eea36a.aspx#disqus_thread&amp;with_comments=true">Knowing.NET - Risk Factors for Offshore-Outsourced Development Projects</a>:<br>
<p>[...] Since this is a common profile, I thought I'd reproduce the Top 10 Risks. Some of these are universal across all project profiles ("Lack of top management commitment"), but others are definitely more problematic for offshored projects. I've highlighted those I think are notably different. All of these should be addressed in your project planning...</p>
<ol><li>Lack of top management commitment</li>
<li>Original set of requirements is miscommunicated</li>
<li>Language barriers in project communication</li>
<li><strong>Inadequate user involvement</strong></li>
<li><strong>Lack of offshore project management know-how by client</strong></li>
<li>Failure to manage end-user expectations</li>
<li><strong>Poor change controls</strong></li>
<li>Lack of business known-how by offshore teams</li>
<li><strong>Lack of required technical know-how by offshore team</strong></li>
<li>Failure to consider all costs</li>
</ol>
<p>That's not to say that I think the ones I did not highlight are unimportant, it's just that I think you can run into those issues onshore (if you replace "language barriers" with "poor communication skills").
</p>
<p>Inadequate user involvement and poor change controls are, I think, more acute risks with offshore-outsourced projects because there's a certain amount of "out of site, out of mind" to these projects. It's not like people are hearing programmers talk around the watercooler or at lunch; offshore projects have a greater risk of 'going dark' for long periods of time. Similarly, with different working hours, different holiday schedules, etc., I think it's considerably more common for offshore work to get off the change-control rails. You really need to do daily check-ins with offshore teams, just like you do with local teams. It's harder and slower than a standup meeting, but I think it's definitely a necessary part of the daily routine.</p>
</blockquote>

<p>Does <cite>Inadequate user involvement and poor change controls are [...] more acute risks with offshore-outsourced projects because there's a certain amount of "out of site, out of mind" to these projects.</cite> have to be true? What is the difference between an off-site and an on-site team? Sure, with an on-site team the manager, internal customers, and others can easily walk to the team members - if they are in the same building. Larger companies tend to have developers in the IT building(s) and the internal customers are from business units located probably across town or in another state. That makes it off-site by all definitions.</p>

<p><strong>Root cause for lack of involvement</strong></p>

<p>I believe the underlying problem is not involvement but the very issue the <a href="http://agilemanifesto.org/">Agile Manifesto</a> wants to address with the sentence <cite>Customer collaboration over contract negotiation</cite>. The problem is created by two legal entities doing business together without trusting each other. Once there is trust true involvement is easier.</p>

<p>The interesting question is of course how to create trust. I believe the key is to hold promises. Wouldn't you start trusting someone who always keeps his promises? I guess you would. You will certainly perceive such a person or vendor as reliable and step by step through the experience collaborate more than control.</p>

<p><strong>Change control is dangerous</strong></p>

<p>In the second part Larry talks about getting off the change control rails. It certainly depends on the type of project. If it's about new product development, then change control doesn't apply at all. By new product development I mean all kinds of activities that contribute to the development of some software that hasn't existed before the off-site team was contracted. If the project is about maintenance of an existing software, then I would rather insist on very good test coverage and good QA than change control. Fixing bugs might require some heavy refactoring and change control simply gets in the way of that. If the codebase doesn't have enough test coverage, then the first step would have to be writing those tests so that a safetynet exists before changes are made.</p>

<p><strong>Daily check-ins don't help</strong></p>

<p>I've learned over time that standups, daily scrums and other forms of daily check-ins do not provide much value. During a classic daily scrum each team member gives his status (did X yesterday, will do Y today, no impediments) but who listens? It's unfortunate but most of the times it seems to be the project manager only. And I can understand that. Such a Scrum is really a check-in with the project manager and doesn't provide value to the team.</p>

<p>In classic Scrum you are not supposed to talk about anything else but coordinate. Team members are expected to say "I'm working on X and I need some help with ..." and another will say "I can help with that". Unfortunately it rarely happens, if the "team" is more a group of people working together than a team. On a real team the members communicate constantly and don't need to check-in once a day - they do it many times with eachother throughout the whole day.</p>

<p>What's left is provide off-site stakeholders or customers a means to see what's going on and - hopefully - a channel to collaborate with the team. For that you don't have to interrupt the team but instead allow the stakeholders to access some kind of information radiator where the current status of all user stories or bug reports can be seen. With our product <a href="http://www.caimito.net">Caimito One Team</a> everybody can look at the issues assigned to the current iteration, see the progress and leave comments. Combine that with daily deployments to a test system and your stakeholders can try new features as they are being developed. Add a good product owner who keeps in touch with stakeholders - not the whole team - and does little private demos for stakeholders and the out of sight - out of mind issue should go away and trust will build simply by being honest, pro-active and delivering things.</p>

