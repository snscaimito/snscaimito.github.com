---
layout: post
title: Quality control in software development
tags:
- Software-Development
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>When it comes to software testing a number of terms are used. You hear the simple term testing, then some talk about QA and others call for QE. </p>

<p>In common language test refers to the act of trying something out, checking on knowledge or behavior and other forms of comparing expected results/behavior to what can be observed. In the case of software testing you expect certain results/behavior from a software system. So you enter some values, perform a number of activities in the user interface and then compare what the systems shows or provides you with what you expected. If it matches, the software passes the test. If it doesn't match, it is deemed faulty and you write a report about the problem. Those reports are usually called defect or bug reports.</p>

<p>I looked up the terms QA and QE on Wikipedia and for QA I found:</p>

<blockquote><a href="http://en.wikipedia.org/wiki/Quality_assurance">Quality assurance - Wikipedia.org</a>:<br>
Quality assurance, or QA for short, is the activity of providing evidence needed to establish quality in work, and that activities that require good quality are being performed effectively. All those planned or systematic actions necessary to provide enough confidence that a product or service will satisfy the given requirements for quality.
</blockquote>

<p>For Quality Engineering (QE) it has been a bit hard to find a good definition. Wikipedia thinks it's just a synonym for Quality Assurance (QA) and if you use Google, you will find links to people calling themselves Quality Engineer as well as companies offering courses in Quality Engineering.</p>

<p>So I'd like to look closer at the terms and try to define them myself for the purpose of this blog post.</p>

<p>Quality Assurance (QA) and Quality Engineering (QE) have two different notions. These terms refer to quality and in the case of QA people want to assure quality and in the case of QE quality is being engineered. That prompts to ask how can we assure or engineer quality in software. But before we can answer that question we need to understand what quality in itself is. Here are a few quotes from an article about quality on Wikipedia:</p>

<blockquote><a href="http://en.wikipedia.org/wiki/Quality">Quality - Wikipedia.org</a>:<br>
<p>Quality in everyday life and business, engineering and manufacturing has a pragmatic interpretation as the non-inferiority, superiority or usefulness of something. This is the most common interpretation of the term.</p>
<p>[...]</p>
<p>One key distinction to make is there are two common applications of the term Quality as form of activity or function within a business. One is Quality Assurance which is the "prevention of defects", such as the deployment of a Quality Management System and preventative activities like FMEA. The other is Quality Control which is the "detection of defects", most commonly associated with testing which takes place within a Quality Management System typically referred to as Verification and Validation.</p>
</blockquote>

<p>So there we have it. Quality means that something is fit for a specific purpose and is not bad or faulty. And we can have people ensuring that a product doesn't get shipped with defects (Quality Assurance) while others control the level of quality by detecting and counting defects in shipped products.</p>

<p>Those definitions apply very well to manufactured goods. In a factory you can take every nth product from the assembly line and check it for defects. Then you create some statistics about the defects you find and in the end you may use those numbers to prompt some action, if the quality drops below a certain level you have defined as unacceptable. Then some people in the quality assurance department get asked to come up with solutions to prevent these manufacturing defects. They may talk to product engineers and change something in the product to make production easier in some way. My knowledge about manufactoring processes is kind of non-existent but apparently it works well in that industry. Where does that leave us for software?</p>

<p>A lot of software development practices are inspired by other industries. There is a lot of people who perceive the act of creating software as some kind of engineering and call programmers software engineers. Probably to distinguish what they do from what a programmer perceivably does. An engineers takes on more complex tasks, creates something new or enhances a machine or building while a programmer writes a sequence of instructions to tell a machine what to do in which order. That implies as well that a programmer usually does not come up with something on her own but instead gets told what the machine should do.</p>

<p>Now, if you have software engineers who create software, then you may want quality engineers to work on the quality of the software before it gets used by people outside of your engineering organization. One team of quality engineers may control the quality of the product before it gets shipped. Another team of quality engineers may assure that less defects make it into the product being shipped. Just as in manufacturing - isn't it?</p>

<p><strong>Ways of controlling and assuring software quality</strong></p>

<p><em>Black box testing</em> and <em>white box testing</em> describe two distinctive approaches of controling software quality. A black box doesn't reveal much details to the observer. You can tell its size, maybe it's weight and then there is the fact that the box is black. That's about it. Software without access to the source code is quite similar to such a black mysterious box. A white box is viewed as one that reveals its inner workings to the observer.</p>

<p>When we do <em>black box testing</em> we explore the functionality of the software, verify its behavior and the results by comparing it to a description of what should happen. Basically the quality engineer executes the software and does what a regular user would do. Whatever goes wrong he reports as a defect. When black box testing a software the only way of performing tests is by means of the user interface provided by the software. If the software uses a database, the quality engineer can compare before and after values in the DB. But most of the times the only way of knowing whether the software does what was expected is by looking at the user interface again. Does the report show the correct values? Got the selected element highlighted? Does it print and the output looks as expected?</p>

<p>That requires a lot of manual work and is per se error prone. A smart quality engineer wants to automate tests to create a number of baseline tests. When he gets a new version of the software he's testing, he simply runs his test suite and can concentrate on what's new instead of manually testing the same stuff over and over again. There is a number of tools - commercial and open-source - available for programmatically drive the UI of Windows, Java and web applications. Quite famous is the open-source tool <a href="http://selenium.openqa.org/">Selenium</a> for web applications. On <a href="http://www.openqa.org/">OpenQA</a>, a place for open-source QA tools, you can find as well tools to automate Java Swing or Windows GUI testing. For more tools, including commercial ones, look <a href="http://www.java2s.com/Product/Java/Testing/UI-Test.htm">here</a>.</p>

<p>My personal opinion about black box testing is that it appears to be a good way to control the quality of a finished software product and provides information to decide whether it is safe to ship it. But it is extremely important to keep in mind that this kind of testing is based on the user interface and you still might miss hundreds of defects just because you don't execute the software in the way that makes them show up. Astonishingly a lot of organizations view this kind of testing as the most important form of testing. Probably because most people perceive software as the user interface. So what they can see and touch that must be the thing they call software.</p>

<p>In the beginning of this post I was talking about quality assurance and quality control. So far we have identified a tool to control the quality of the user interface. I think it's safe to say it that way. What about controlling or even assuring the quality of the software's functions? To achieve that we need to look on the inside.</p>

<p><em>White box testing</em> requires us to work with the source code, which allows us to perform tests on internal mechanisms instead of just the user interface. The keywords that come to mind now are TDD (Test-Driven Development), unit tests and tools like those from the <a href="http://www.junit.org/">JUnit family</a>. This is going to be a complex topic, as it is not only about controlling quality by measuring things. To assure quality you have to start with the process from the very beginning, which is when you analyze the problem you want to solve with software. It touches the way you develop (your development process) and essentially is not any more a matter of the QA/QE team. I think it makes sense to cover white box testing in a second post.</p>
