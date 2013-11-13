---
layout: post
title: Thoughts on the ideal project team
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
<p><strong>Update:</strong></p>

<p>When I posted <a href="http://www.stephan-schwab.com/2008/02/05/1202245415689.html">Thoughts on the ideal project team</a> a few days ago I received a comment to which I'd like to respond in more detail here. I really appreciate that kind of comment. Who ever is xcosyns: Thank you!</p>

<blockquote>Commenter xcosyns in <a href="http://www.stephan-schwab.com/2008/02/05/1202245415689.html">Thoughts on the ideal project team</a> at my blog:<br>
Often you will need someone handling the infrastructure, uat, itt should match the real production environment. And from experience this is not always the case, and not that easy to achieve when multiple applications have to interact, one way or the other, together? And we are not yet talking about backups, db replication, san drives, authentification systems, load balancing&#8230; 
</blockquote>

<p>Development infrastructure should be as simply as it makes sense. And it's the developers who should have control over it. For example in our case mostly I do that and when you have some experience it's not that hard to do. I encourage my fellow team members to not limit themselves to the "code monkey" role, but learn how to administer their own systems and team systems. My belief is that every software developer needs to be able to do sysadmin duties - at the very least for those systems he works with on a daily basis.</p>

<p>By that I don't mean to say that SAN drives and load balancing in a production environment should be maintained by the developers of a system. That's the job of an operations group. But developers who can do this for their little development environment have a much better understanding of these things and know what to do and what not to do when creating an application for such an environment.</p>

<blockquote>
Also, developers can really benefit of a DB expert, often java developers really sucks when it comes to db performance, and most developers are rarely aware about what their db can really do. A good DB expert can speed up legacy applications with no or minor changes.
</blockquote> 

<p>You are right. Often Java developers really suck when it comes to DB performance. Why is that? Probably because their education is too shallow. One thing is to merely understand the language and a few common libraries/frameworks. And another thing is to understand software development in a holistic way. That's the result of experience and natural curiosity. For example in my own case I have been forced to learn Unix system administration, networking (up to managing a larger network for an ISP I co-founded; think of the whole zoo of routers, access concentrators and the various protocols such as BGP, OSPF, etc.) plus several high and low level programming languages including all the, literally, zillions of libraries and frameworks for those. It took a while, but I consider this the difference between an apprentice and a master. The ideal project team practicing agile development should be comprised of masters. There is a room for apprentices. You can easily assign to each master an apprentice and delegate some tasks to those.</p>

<blockquote>
Some documentation should be written, the business analysts can do the functional part, developers or the architect can do the technical part. But when the project/projects/teams scales up it becomes a time-consuming task and it can partially be delegated. 
</blockquote> 

<p>Agreed. If you have a need for more extensive documentation, then you certainly can add a tech writer. I see one question that remains. If you make the tech writer part of the team and follow the very good practice of "done done" for your user stories, that would mean that a story is only "done done" when the documention related to the story is completed as well. In this case you add another constraint besides the programmers. Probably it depends on the type of application and the target market whether that makes sense.</p>

<blockquote>
Also someone needs to follow up the development process, a project manager or a team leader. Someone that can prioritize the tasks in function of the business needs and business gains, someone that has a global view of the project and the company. And managing the budget, logistics, recruiting, etc&#8230; 
</blockquote>

<p>For that there is the role of the Product Owner. His job is to prioritize stories based on business value. The customer is the only one who can really know the business value of stories so he should be the only one providing that indicator. Budgeting, logistics and recruiting are unrelated to the work the team is supposed to perform. You form the team before you get started - obviously ;-) - and then that's your team. I would not move people in and out of a team, because that negatively affects the accumulated domain knowledge and slows down.</p>

<p><strong>The original post:</strong></p>
<hr>

<p>As I'm preparing some material for an upcoming event, I thought I could as well share this little piece here on the blog. Basically it is about the ideal software development team, the roles people play and the skills each team member needs to possess to be able to make meaningful contributions.</p>

<p align="center"><img src="images/ProjectTeam.png" border="0" height="399" width="452"></p>

<p><strong>Customer</strong></p>
<p>The customer is not that company or that guy who pays. The customer actually drives the project and is part of the team. It is important to engage the customer in a constant dialog or at the very least to give him a means to collaborate and respond to questions easily.</p>

<p><strong>Programmer</strong></p>
<p>Programmers write the code and are supported by Testing Programmers. The programmers are the constraint on the team. Their number needs to grow in order to be able to handle a larger project. I share the common opinion that when you add two programmers, you should add one testing programmer as well. It seems to be a good idea to add programmers in pairs, because that allows them to pair on difficult tasks.</p>

<em>Skills required:</em> Expert knowledge in the choosen programming language, tools and other technologies used for the project.

<p><strong>Testing Programmer</strong></p>
<p>The Testing Programmer is just an ordinary programmer, but in that role he looks out of test coverage, performs manual and automated tests of the integrated software system and checks for completenes of the implemented solution based on user stories and in cooperation with the Business Analyst acting as Product Owner.</p>

<em>Skills required:</em> Expert knowledge in the choosen programming language, tools and other technologies used for the project plus strong testing skills and expert knowledge in test automation.

<p><strong>Information Architect</strong></p>
<p>Almost every system has some kind of user interface. The Information Architect designs the user interface, creates wireframe models for communication purposes, works with the Business Analytics and the Customer and helps the programmers when they implemented the user interface. He creates graphical elements for the user interface.</p>

<em>Skills required:</em> feeling for good user interface design, graphic design, communication abilities

<p><strong>Business Analyst</strong></p>
<p>The Business Analytics acts as Scrum Product Owner for the team and maintains a constant dialog with the customer. His job is to understand the customer's goal and expectations for the project. He collaborates with the customer to create user stories.</p>

<em>Skills required:</em> Strong analytical skills and ability to gain expert knowledge in the customer's business in short time. Very good communication skills oral and in writing. Expert in writing user stories.

