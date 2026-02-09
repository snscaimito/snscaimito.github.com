---
layout: post
title: It doesn't matter whether it works
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
  _edit_last: '6384953'
---
<p>Imagine this. You develop some software that</p>

<ul><li>works</li>
<li>solves the business problem</li>
<li>development time is short</li>
<li>future maintenance is easy</li>
<li>changes can be done quickly and safely</li>
</ul>

<p>Still you are being told "It doesn't matter whether it works" followed by "It is more important that it adheres to IT governance standards".</p>

<p>I'm pretty sure that only the naive mind of a passionate software developer will find that confusing. Certainly there must be more elevated minds who can really understand the wisdom behind such rationale.</p>

<p>So let's try the ridiculous attempt as a mere mortal and try to explore this further. Maybe we can get closer to understanding it. Probably the first thing to look at would be "IT governance". What is that?</p>

<p>Here is a quote from <a href="http://en.wikipedia.org/wiki/Information_technology_governance">Wikipedia</a>:</p>

<blockquote>Information Technology Governance, IT Governance or ICT (Information &amp; Communications Technology) Governance, is a subset discipline of Corporate Governance focused on information technology (IT) systems and their performance and risk management. The rising interest in IT governance is partly due to compliance initiatives (e.g. Sarbanes-Oxley (USA) and Basel II (Europe)), as well as the acknowledgment that IT projects can easily get out of control and profoundly affect the performance of an organization.</blockquote>

<p>To me it is a bit hard to see the relationship between software <strong>development</strong> and IT governance. Yes, the citation mentions <em>IT projects</em>, but I would like to think that those projects are not software development projects, but projects such as setting up new networking infrastructure, building a new data center or maybe switching from release X to release Y of any software product. Those things need governance, because they need to be done in a consistent fashion and risk and the impact of errors on the business need to be managed.</p>

<p>When you develop a new software product, then governance is probably not the right approach at all. After all you are <em>developing</em> something, which means that you have to figure out a solution to a given problem and you can't possibly follow a certain pattern in doing so.</p>

<p>Now let's assume for a moment you find yourself in an organization where you are tasked with the development of a new web application that should save a significant amount of revenue for the business, hit the market before competitors do it, or maybe open a new market. It is the year 2008 and you know the pros and cons of several Java web frameworks. Your stakeholders expect a modern, almost desktop-like behavior - what's usually called a web 2.0 experience -, and you want to develop fast, because much is at stake. Further you know that stakeholders can change their mind quickly - that's not their fault, they simply react to market forces - and you want to be able to give them what they need in time.</p>

<p>Sounds good - doesn't it? So you experiment a bit and choose the framework and other tools that allow you to develop fast, cover all levels of the application easily with unit tests and you are willing to do some automated QA using Selenium. Then you go ahead and do a spike of some portion of the new system and you find that you can do this much faster than with older technologies. There has been some progress in the area of web frameworks and other web related technologies between the first servlets and today's tools.</p>

<p>So you do this spike and demo the results. And you get the answer that it is more important to adhere to IT governance standards than that the new product works. </p>

<p>Does it make sense for a company to restrict developers of new software products to outdated technologies? Isn't the prevailing meta everywhere faster time to market? What about maintenance costs? Why ignore software technologies that allow to build something that's easier to extend and maintain? The counter argument will usually be that the company needs to be able to find developers who know the technology. COBOL was big in the past. Today it is not easy to find people who can maintain COBOL code. But it is possible to train people on new technology, which can be considered a smart move, because constant training of a company's workforce ensures it is able to compete better with others.</p>

<p>Or maybe preserving a status quo by enforcing IT standards creates better products faster and I simply don't get it.</p>
