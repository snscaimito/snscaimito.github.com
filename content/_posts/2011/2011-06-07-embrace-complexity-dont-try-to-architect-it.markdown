---
layout: post
title: Embrace complexity - Don't try to architect it
tags:
- en
categories:
- software_development
- management
- business
status: publish
type: post
published: true
meta:
  jabber_published: '1307502761'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1307743960";}
  _edit_last: '6384953'
  _wpas_skip_twitter: '1'
---
My article about <a href="/software-design.html">Software Design</a> has sparked some mixed feedback amongst the people who have read it early on. Part of the feedback was about what I said about the role of the software architect. I was saying that there is no need for a special software architect but instead it needs a team of enough senior developers who can come up with good design for the software.

Note that I may have changed the article about <a href="">Software Design</a> since writing this blog post.

I still think that the term architect in software does not really fit well. It seems to lead to a lot of misunderstandings and unnecessary tension in conversations. The software industry should get rid of that term.

Many people seem to think that an architect is responsible for the big picture and that it needs that role especially in larger enterprises to make sure that all the different systems and components work well together.

But then maybe that is just a human shortcoming. It appears that we humans are awfully bad at managing and dealing with complexity. We seem to like linear and easy to understand things and approaches to what we do. We also seem to like predictability and are not feeling really comfortable with - well ... - complex systems that - even worse - self-organize and adapt.

That may be the driver behind the desire to have someone in charge for the big picture aka the overall architecture. Even more so in the context of large enterprises.

<strong>What other very big systems are out there</strong>

Let's look around. Software systems are not really the biggest systems out there.

What about the <strong>electrical grid</strong>? There are essentially two big electric grids on this planet. The one that runs on 220/240V which spans from Europe to all places that can be reached over land. And the one that runs on 120V and spans all of the Americas. In both cases the grid spans multiple countries, each with its own independent government, and multiple operating companies, each with their own independent management. They all sell and buy electricity from each other and the whole thing is a <strong>network</strong>. Has there been an architect or a group of architects that designed this? Many people have certainly contributed over the years but other than using certain standards on the basis of <em>we use it because it works</em> I very much doubt that there is any central oversight over such a vast system. There are certainly attempts to control the structure, the architecture, but there is so much politics involved that it would probably not right to assume that someone is responsible for the big picture.

What about the <strong>European railway system</strong>? In Europe the same train can drive from one country to another. That has not been the case all the time. There have been many different railway systems with different technical specifications. Because there were a benefit in interconnecting the different railway organizations got together and agreed upon a standard so that trains can drive on all the tracks. Was there central oversight by an architect? I think it's more likely that mutual economic interests brought companies together and made them <strong>collaborate</strong>.

What about about the <strong>Internet</strong>? Before the Internet got so popular there have been wide-area computer networks but they were expensive and access to these networks was difficult. It was common that you could only connect devices that were certified and allowed to be used. All that oversight and control <strong>crippled innovation</strong> and in the end these earlier networks are now just a fading memory. The Internet is based on the, in comparison, simplistic TCP/IP transport protocol and anyone can create a new application and a new application protocol. No centralized architecture body designed HTTP and nobody controls the main protocol that is used to move the majority of all content on the Internet.

Instead very early in the development of the Internet people came up with the idea of Request for Comments (<a href="http://www.ietf.org/rfc.html">RFC</a>). RFCs are not standards defined and maintained by some standards body. They are simply memorandums that describe a technical concept/proposed standard and then people are free to pick it up and use it. If enough people like it, there will be many applications using it and because of its usefulness it becomes an industry standard. Common sense makes a network of people with similar interests adhere to such a "standard" described in an RFC. Not because someone forces them to or made it a rule.

<strong>Do we still need a Software Architect or even an Enterprise Software Architect?</strong>

What has worked well for the Internet with RFCs since 1969 might be a model for large enterprises and companies of all other sizes as well. Instead of being afraid of the inherent complexity of software based systems, it would be wise to embrace the complexity and let smart software and system designers figure it out amongst themselves. All they probably need is a platform to share similar to what happens with RFCs for the very big system The Internet.

Good ideas, good protocols, good systems, good libraries, etc. will be picked and become more popular while others will be superseded by smarter solutions. That's how evolution in nature works as well. There is no architect involved either.
