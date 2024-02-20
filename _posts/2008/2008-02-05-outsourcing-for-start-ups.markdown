---
layout: post
title: Outsourcing for start-ups?
tags:
- en
categories:
- software_development
- business
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>This is a re-post of something I wrote earlier on the old blog of my company. I just read a discussion about the topic <a href="http://www.linkedin.com/answers/startups-small-businesses/starting-up/STR_STP/168156-2371260?searchIdx=4&amp;sik=1204670846333&amp;goback=%2Easr_1_1204670846333">Outsourcing for start-ups</a> on LinkedIn and although the text is written to attract and convince prospective clients, I think it may spark some interesting comments.</p>

<p>What seems to be the prevailing point of view seen in the LinkedIn discussion is that, if the start-up is a technology - read software - company, you should not outsource your R&amp;D. That's kind of obvious. ;-)</p>

<p>On the other hand some seem to think about outsource in terms of offshore to some cheap labor country and fear the loss of IP rights. Isn't there a difference between offshore and outsource? You can outsource to a team located just down the street and that may make a lot of sense.</p>

<p>I really like the comment Peter Nguyen gives:</p>

<blockquote>I teach strategic business design to entrepreneurs, and one thing I stress is to be clear on what your business model is. Unless your startup does software development, it's a good idea to outsource. However, keep in mind that IT is such a central part of any business organization that, as I mentioned before, it's important to outsource to the best IT companies, regardless of where on the planet they come from. </blockquote>

<p>Here is the re-post about <em>New Product Development</em>:</p>

<blockquote><p><strong>Traditional Software Development does not work</strong></p>
<p>Software Development is not an easy task. In over 20 years many projects have failed and a lot of money and opportunities have been lost due to wrong expectations and bad project management. Unlike common belief development of a software system is not an exact science. Although the term &ldquo;software engineering&rdquo; is commonly used, it&rsquo;s more a union between art and engineering. Good software engineers have developed a feeling for good systems design due to their long-term experience. What we do is more comparable to the art of playing a violin than the work of an engineer who can leverage norms, standards and mathematical models. Such clear rules do not exist in software development to the same extend. Further teams frequently struggle to deal with a great number of unknown factors, such as unclear specifications, changing requirements, and simply unforeseeable requirements, while being expected to deliver functionality on time, on budget, and with high quality.</p>

<p><strong>Agile Development is a dialog with the client</strong></p>
<p>In recent years a new idea is getting more and more adapted by forward thinking software developers and companies. Instead of following the failed &ldquo;Waterfall&rdquo; development model, which made us belief that we can design a huge system upfront and then have programmers write the code according to the specification, &ldquo;Agile&rdquo; teaches that it&rsquo;s better to develop in short iterations and embrace change with each iteration completed. Instead of big upfront design, we design enough to produce working code for a limited set of functionality and have the user see and try it to give us more guidance. Instead of working out of sight, we enter into a process of continuous conversation with our users and learn more and more about their business while we build software for them.

<p><strong>Calculating development costs</strong></p>
<p>Clients want to know/need to know when the new software will be ready and how much it is going to cost. Agile Development allows us to answer both questions more honestly. We can only estimate something we know and understand. So instead of promising all and everything to our client, we calculate the price for the product iterations. Neither the client nor we can possibly know how many iterations will be needed to development the new product the client is looking for. Instead of exposing the client to a huge risk or accepting the full risk ourselves, we lower the total risk and allow for corrective measures from the beginning.</p>

<p><strong>Scrum Sprints</strong></p>
<p>Caimito uses the Scrum methodology for all projects. Development in Scrum is done in sprints of a fixed length. The duration of a sprint can be one week or up to four weeks. Each sprint will deliver a new product increment, which is running code that could be used. Before a sprint starts the development team plans the work it wants to do and commits to the goal it defines for the sprint. After the sprint the team conducts a meeting with the client to demo the new product increment and gathers feedback.</p>
<p>Before a sprint starts team and client know exactly what the product increment will be. There will be no surprises in terms of unexpected results, lack of features or raising costs.</p>
<p>Depending on the size of the team and the complexity of the project we suggest short sprints and small team sizes to further lower the risk. Misconceptions can easily be handled when detected after one week, while the same problem will get costly after four weeks.</p>

<p><strong>Client Representative</strong></p>
<p>We understand that our clients are busy with their own business and frequently can&rsquo;t afford to dedicate too many resources to the much-needed dialog with the development team. Usually agile practices ask for a client on-site who works with the team each day. Unfortunately that doesn&rsquo;t work for all clients and we&rsquo;ve come up with an alternative.</p>
<p>In our adaptation of Scrum there is the client, a client representative and the team. Facing the team the client representative acts as Scrum Product Owner and is responsible to administer the product backlog, which is the list of requirements for the product in the form of user stories, change requests and bug reports. Facing the client the same person represents the team and communicates to the client the achievements of a sprint and gathers new requirements.</p>
<p>The skill set of this person includes that of a business analyst with experience in the client&rsquo;s industry or at least the ability to learn quickly, but as well languages, as clients not necessarily speak the same language as the development team.</p>
<p>Currently Caimito supports clients in English, German and Spanish.</p>

<p><strong>Domain Driven Design and Unit Tests</strong></p>
<p>Software developers are experts in software engineering, but can&rsquo;t be experts in the client&rsquo;s domain. The challenge we face is to create a working solution that optimizes processes in the client&rsquo;s business without fully understanding a business foreign to us. Domain Driven Design (DDD) is a relatively new technique, which allows us to model the important parts of a client&rsquo;s business with objects in code and shape the solution by adding functionality incrementally. Backed by automated tests we can assure that things that have worked before keep working while we add or modify code to build or extend the system.</p>

<p><strong>Continuous Integration, Integration Tests and test coverage</strong></p>
<p>Some programmers crank out code at high speed and leave testing to a QA (quality assurance) department. We don&rsquo;t believe in this approach. Instead we perform continuous integration using an automated build and test environment where all tests that were ever written for the project are executed with each hourly build of the entire code base of the solution. That way we will know immediately, if new code breaks something and can fix it, before more valuable time has been wasted following the wrong track.</p>
<p>Our Integration Tests are end-to-end tests that span from the presentation layer down to the infrastructure layer and further down to a real SQL database, if such a data storage technology is part of the solution. Tests on the presentation layer are performed with automated testing tools that simulate users working with the user interface of the application and are part of the automated tests run with each build hourly.</p>
<p>Tests do not serve any purpose, if they don&rsquo;t cover enough scenarios. As part of the automated build we run a tool that reports on test coverage per package, per class and per method. We make sure that we have a coverage of more than 90% on a per method level.</p>
<p>A code base with very good test coverage, an easy to run automated build process and good integration tests is easy to maintain and extend in the future. Even a new development team can work successfully with little ramp-up time. The investment in extra time to improve test coverage or maintain it high pays off fast in the form of reduced costs and greater stability of the overall solution.</p></blockquote>
