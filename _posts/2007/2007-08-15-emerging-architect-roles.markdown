---
layout: post
title: Emerging Architect Roles
tags:
- en
categories:
- software_development
status: publish
type: post
published: true
meta: {}
---
<p>A blog post on Microsoft's Developers Network (MSDN) caught my attention. I found it via InfoQ's article <a href="http://www.infoq.com/news/2007/08/what-is-an-architect"><em>What is an Architect anyway?</em></a>.</p>

<p>My own post about the topic was titled <a href="http://www.caimito.net/caimitoEnglish/2007/07/14/1184445803680.html"><em>The architect role in Agile Development</em></a> and appeared on <a href="http://www.caimito.net">my company's</a> blog. In it I was saying that there is no need for an architect in an agile team, but it makes sense to have a coach available. Now the members of the Microsoft Architecture Strategy Team propose three different architect roles in their own post:</p>

<blockquote><a href="http://blogs.msdn.com/diegumzone">DiegumZone</a> in <a href="http://blogs.msdn.com/diegumzone/archive/2006/11/10/software-architecture-past-present-and-future.aspx">Software Architecture: Past, Present and Future</a>:<br>
<p>What is exactly software architecture? Do we really need it? Why have we only recently been discussing it? Is there suddenly a contagious fever about software architecture infecting those who claim to be architects? Who are they actually: gurus, just senior developers, or maybe smooth-talkers?</p>

<p>[...]</p>

<p><strong>Emerging Architect Roles</strong></p>

<p>The considerations of economical changes like globalization and technological achievements like the Internet&rsquo;s impact on the digital economy, pressed for formalizing software architecture as a discipline.</p>

<p>Although there is not yet a definite agreement in the distinct roles, we can sketch three major personas:</p>

<ul>
<li><strong>Infrastructure Architect.</strong> These define the platform and other environments (hardware, basic software) to provide for business applications&rsquo; high availability. They must also work with developers to define mechanisms and standards that allow applications to achieve the security, reliability, manageability, transparency, and policy compliance essential to the modern business. It&rsquo;s expected that the natural evolution of a senior IT professional is an Infrastructure Architect.</li>

<li><strong>Solutions Architect.</strong> These are responsible for the design of one or more applications or services within an organization, usually within the scope of a division (and for that reason also known as Application Architect). Examples of such applications are: Internet banking, companywide knowledge sharing portal, and distributed point of sales applications. A senior developer is a good candidate to become Solutions Architect.</li>

<li><strong>Enterprise Architect.</strong> Their job is to keep the business and its IT systems in alignment. They strive to maximize the return on IT investment by making sure that IT spending is prioritized towards business opportunity, and by optimizing the impact of investments across the organization&rsquo;s portfolios of services, resources, projects, and processes. They must be a bridge between business leaders, development, and operations to ensure that mutual understanding is achieved, goals are realistic, and expectations are properly managed. Enterprise Architecture is about the big picture &mdash; how people and technology work together to produce world-class, long-term results. For that reason, this persona is also referred as Strategic Architect. What is expected is that a Solutions Architect or Infrastructure Architect becomes Enterprise Architect.</li>
</ul>
</blockquote>

<p>These job descriptions, essentially that's what it is, sound like calling for another manager role. It awfully sounds like creating unchangeable rules and mandating platforms and technologies from a defined set of vendors. Let's look at these job descriptions in more detail.</p>

<p><strong>Infrastructure Architect.</strong></p>

<p>The proposal calls for a senior IT professional to evolve into an Infrastructure Architect. It doesn't mention a developer who can evolve into that role. So what is an "IT professional"? To me that sounds like someone from the corporate MIS department who has been installing and maintaining desktops, servers and networks with lots of help from the vendors. Those who work in MIS department are smart folks. But in my experience their view is limited to an experienced user's view. They usually don't have time to fully understand networking or operating systems concepts. They have to follow the manual and best practice articles. To me, given that my job is to develop a software, such a senior IT professional would be a great source of input to learn more about the technical difficulties the organization faced in the past. But I would not put such a person in a position to define implementation details for the developers. The risk is too high that in the end it will be a decision pro or contra a certain vendor's platform (e.g. Windows vs. Unix) and not something that can be considered architecture.</p>

<p>Instead it's the job of a developer - we are not talking about programmers who simply implement a specification - to be well versed in questions of security, reliability, manageability, transparency, and policy compliance.</p>

<p><strong>Solutions Architect.</strong></p>

<p>To me the design of applications is not something that a single person might be able to accomplish. Instead it's a process comprised of a dialog with the stakeholders to learn their business, their ideas, and their requirements in combination with a team of experienced developers creating software in iterations and actively proposing solutions. What the Microsoft team writes sounds more like someone who creates Product Requirements Documents, UML diagrams or another kind of formal instructions for the implementers.</p>

<p><strong>Enterprise Architect.</strong></p>

<p>In my opinion that Enterprise Architect simply should be the CTO of the company. A large organization needs someone providing oversight to all the different projects going on. Not to mandate certain technologies or to prefer a certain vendor, but instead to make sure everything that gets deployed can interoperate with each-other. This person should be able to leverage the specialized knowledge of technology consultants without following a single one blindly. His job is to avoid vendor lock-in and silos, but not to limit the use of anything upfront.</p>
