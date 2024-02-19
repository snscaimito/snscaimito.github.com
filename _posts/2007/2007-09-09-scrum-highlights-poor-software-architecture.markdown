---
layout: post
title: Scrum highlights poor software architecture
tags:
- en
categories:
- software_development
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>How do you find out whether your software architecture is flexible and can keep up with evolving requirements? Try to deliver and deploy new working software in short iterations.</p>

<blockquote><a href="http://www.lostechies.com/blogs/joe_ocampo/default.aspx">Joe Ocampo</a> in <a href="http://www.lostechies.com/blogs/joe_ocampo/archive/2007/09/08/scrum-the-gateway-drug-to-true-agility.aspx#comments">SCRUM The gateway drug to true Agility</a>:<br>
[...] Scrum focus on process eventually brings forth the impediments of poor software standards and poor testing. Because it is still taking an iterative approach to building software, the culture has to adapt on how they are going to deliver software in 2 weeks in a working state. It doesn&rsquo;t tell you how it just says make it happen. Let&rsquo;s think about this&#8230;Leadership is (coughing) challenging the development group to develop working software in 2 week cycles. How on earth are we going to do that? Leadership is challenging the testing group on how they are going to constantly keep up with these 2 week development cycles? How are they going to do that? Hopefully you read between the lines and see why Scrum is successful it empowers leadership to cultivate a team to deliver software.
</blockquote>

<p>But it's not only the software architecture that gets challenged. It's the whole way of developing including not only the code itself, but the tools used for doing it, the way you run a build, how you do QA and more.</p>

<p>Corporate developers might face a bigger challenge with Agile than those with the mindset of those who develop shrinked-wrapped software. It makes a big difference when you develop something that will be shipped to millions of customers instead of something that you deploy to a set of machines you control. If the latter is the case, you may even have the developer do the deployment the first time and accept a long list of steps to do be done to allow someone else to repeat it. When you ship the product to customers you can't do that. Besides a clean way of installing it, you have to think about upgrade paths without putting your customer's data at risk.</p>

<p>Probably some corporate developers think at this point that their product doesn't require those extra steps. There is only one customer and why spend extra development cycles on something that's not needed. My point is that you do need it. It's a wrong perception, if you think you don't. And it's not expensive to do so. Just keep things simple and don't try to complicate things.</p>

<p>Now when you have to deliver and deploy a new version of your product every two weeks, there is no big difference between this and a someone upgrading a shrinked-wrapper consumer software. You want a one step deployment process that doesn't require anyone to read a manual.</p>

<p>During the development of our agile project management tool, <a href="http://www.caimito.net/caimitoEnglish/categories/Savila/">Savila</a>, we make sure that all we have to do is to upload the new WAR file to the Tomcat servlet container and everything else has to be handled by the new code. So, if we had to upgrade the database schema (we use Hibernate's auto DDL feature), the new code has to know how to work with old data and convert it on the fly. If there are new configuration settings, the new code has to know sensible defaults.</p>

<p>This is just a little example of the kind of backwards compatibility required when you develop software in short iterations. The simpler you keep everything, the easier that task is.</p>
