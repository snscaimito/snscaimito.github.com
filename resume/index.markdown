---
layout: special
title: Professional experience of Stephan Schwab
---
Based on my first lines of code written in the early 1980s and first publication in <a href="https://de.wikipedia.org/wiki/Computer_Persönlich">Computer Persönlich</a> I've been honing my skills in software development and business since then.

My passion is software development in multiple programming languages and thanks to my demanding clients I keep up with current technologies being languages, frameworks and also networking, operating systems or operations topics.

Unlike some of my peers in Agile Coaching I have never stopped programming personally and so I can do for real what I talk about. In every engagement that ability earns me quickly respect and people like to take my advice as it comes from the trenches and not from books or lectures.

I help CEOs and Department Leaders to improve value creation and cohesion within their organization. The outcome will be higher quality, customer delight and more revenue. 

Agility and self-organization require technical competence. Scrum, Kanban and other frameworks and concepts do not work without technical abilities. I help everybody involved to acquire or grow these abilities.

My contributions help the organization to become more adaptable and more resilient so that it can prevail in global dynamic markets that are constantly changing.

My work, on an international level, gets me in touch with many different national and corporate cultures. That allows me to see the bigger picture, provides me a large arsenal of tools and therefore makes me able to solve difficult situations in a way that is new to the particular client I’m working with.

A good example illustrating some of my more special experiences is this story:

<blockquote>
I taught a young developer in China at Huawei Behavior-Driven Development in Python using the framework <a href="https://github.com/behave/behave">Behave</a>. She did not speak a lot of English and we were communicating through a translator who was sitting between us. As I was able to show in code what I was explaining in English - the translator turning my words into Mandarin - my coachee quickly understood the concepts and we were able to deliver a valuable service to her team.
</blockquote>

**Phone +49 151 6162 3277**

**sns@caimito.net**

## Engagement Overview
<dl class="resume">
	<dt>Product Designer and Developer</dt>
	<dd>
		<p class="client">2022 - 2023, Caimito Agile Life, Spain</p>
		<img src="../img/granjaEU-menu.jpg" style="width: 8em; float: right; margin-left: 2em"/>
		<p>This is a solo project with no other people involved.</p>
		<p><a target="_blank" href="https://www.caimito.eu">CaimitoEU</a> is a frontend application to promote an ecosystem restoration project in Andalusia, Spain. The application contains a shop for packaged products and also an innovative butcher shop to facilitate the sale of fresh Iberico meat.</p>
		<p>It is written in JavaScript with VueJS (version 3), HTML5 and CSS3 for styling. After a bad experience with TailwindCSS the styling was redone in pure CSS3. It is deployed as a Docker container with an NGINX reverse proxy in the front and for handling SSL encryption. CaimitoEU consumes an API provided by GranjaEU and does not have local data storage.</p>
		<p>Secured via Keycloak, CaimitoEU calls the backend API REST endpoints authenticating itself as a service account.</p>
		<p>To process payments PayPal is integrated. CaimitoEU displays information in English, German, Spanish languages via vue-i18n and some Vue Router tricks to redirect to language specific pages for larger content.</p>
		<p>Build and deploy happen via GitHub Actions to a staging and production environment. The multi-stage build includes Cypress UI tests and also Cypress smoke tests before a candidate container is marked as ready for deployment.</p>
		<p>More complex features that take longer in development are controlled via feature flags in order to make them visible in the staging but not in the production environment.</p>

		<p><a target="_blank" href="https://www.granja.eu">GranjaEU</a> is the backend API for CaimitoEU and also a small-scale ERP system for running a farm which is being used daily by the workers of Granja Caimito.</p>
		<p>The backend API is coded in Java with Spring Boot. It exposes REST endpoints to the GranjaEU webapp and also a secured public API, via Keycloak, for CaimitoEU (in the future, other farm applications as well).</p>
		<p>User management is done within Keycloak. Data is stored either structured in PostgreSQL or as documents in MongoDB.</p>
		<p>The user interface is made with Vuetify and supports English and Spanish languages via vue-i18n.</p>
		<p>GranjaEU also sends emails via JavaMail and the Google SMTP server to customers in response to shop actions and to notify customers about state changes for their orders.</p>

		<p>Test-driven development and rapid prototyping are two of the methods used. Actual farm workers use the application at a very early stage and provide feedback. Deployment to production - in the sense of trunk-based development - for both applications happens multiple times per day in small chunks.</p>

		<p>As with CaimitoEU build and deploy happen via GitHub Actions as a multi-stage build pipeline. Maven is building and running a large number of JUnit unit and integration tests. Cypress is used to test the GranjaEU web UI and also runs smoke tests of the deployed application for selected critical functionality. The output is several Docker containers which are stored at GitHub's container registry and deployed via SSH to a Docker Compose to staging and production environments.</p>

		<p>Technologies: VueJS, Vuetify, Cypress, Keycloak (OAuth2), Docker (compose), MongoDB, PostgreSQL, NGINX, Spring Boot (REST, Data, Mail, Thymeleaf, Security), Flyway, JUnit, Maven</p>
	</dd>

	<dt>Developer</dt>
	<dd>
		<p class="client">2021 - 2022, Mercedes-Benz, Germany</p>
		<p>Worked 100% remote with an international DevOps style group on an internal application to manage SonarQube in combination with GitHub Enterprise.</p>
		<p>Backend work with Java, Quarkus, Hibernate, Maven</p>
		<p>Frontend work with VueJS, Vuex Store, Typescript, Vuetify, Cypress automated testing</p>
		<p>Development environment was Docker, GitHub Actions. Production deployment to Azure Kubernetes cluster. Worked on Quarkus Native Executable on GraalVM as Docker container. Did minor changes to Helm charts and within Microsoft Azure.</p>
		<p>The application uses Keycloak for authentication and I also got to do some work with its API and manage local deployment for testing purposes.</p>
		<p>Worked on a demo setup for a different group to enable them to use Microsoft .NET on Kubernetes. Development with .NET on Mac OS and deployment to selfhosted Ubuntu MicroK8s.</p>
		<p>Did some limited coaching on Object-Oriented Programming and Test-Driven Development for the colleagues with a SysAdmin background.</p>
	</dd>

	<dt>Developer</dt>
	<dd>
		<p class="client">2020, PH7, Japan, USA, Europe</p>
		<p>Working on a NodeJS based API to orchestrate a number of external services.
      Functional programming style and use of Promise and lodash/fp.
      Unit testing with JEST, acceptance and smoke testing with Cucumber.js and Chai.
    </p>
    <p>Geographically distributed team with team members working from individual locations in Europe, Japan, and USA.
    </p>
	</dd>

	<dt>Consultant</dt>
	<dd>
		<p class="client">2019, Raiffeisen Bank, Pristina, Kosovo</p>
		<p>Performed an IT process and system assessment for the executive board.</p>
	</dd>

	<dt>Consultant</dt>
	<dd>
		<p class="client">2019, Raiffeisen Bank, Sarajevo, Bosnia-Herzegovina</p>
		<p>Performed an IT process and system assessment for the executive board.</p>
	</dd>

	<dt>Consultant</dt>
	<dd>
		<p class="client">2019, Raiffeisen Bank, Belgrade, Serbia</p>
		<p>Performed an IT process and system assessment for the executive board.</p>
	</dd>

	<dt>Agile Coach</dt>
	<dd>
		<p class="client">2018, Alfa Insurance, Moscow, Russia</p>
		<p>Continued the work from 2017. Worked with several teams and senior management on improving engineering practices. Advised on network security and information security practices. Introduced a former coachee to the teams to support XP style testing practices at the team level. Consulted on <a href="/2018/04/07/draft-of-a-roca-and-scs-style-application.html">Self-Contained Systems (SCS)</a> based on Docker containers to improve application architecture.</p>
	</dd>

	<dt>Agile Coach</dt>
	<dd>
		<p class="client">2017, Alfa Insurance, Moscow, Russia</p>
		<p>Performed an audit of the software development and operations groups in preparation of a larger engagement to uplift skills and create a DevOps structure. Did some initial coaching on two teams to lay the foundation for future coaching work with these two teams and additional groups to follow.</p>
	</dd>

	<dt>Agile Coach <em>in cooperation with other Agile Coaches</em></dt>
	<dd>
		<p class="client">2017, Alfa Bank, Moscow, Russia</p>
		<p>Continuation of the 2016 engagement. Objective is to create a DevOps culture inside the bank and restructure the whole organization accordingly.</p>
	</dd>

	<dt>Agile Coach</dt>
	<dd>
		<p class="client">2016, Thales, Stuttgart, Germany</p>
		<p>Within the axle counter group of Thales Transportation Systems I coached project manager and solution architect on their new roles of Scrum Master and Product Owner. Introduced technical team members to Test-Driven Development in C using the tool <a href="http://www.qa-systems.com/tools/cantata/" target="_blank">Cantata</a>.</p>
	</dd>

	<dt>Agile Coach</dt>
	<dd>
		<p class="client">2016, Versandhaus Walz, Bad Waldsee, Germany</p>
		<p>The engagement started as a group of three coaches for their main office and an external development partner. Initially I trained and coached on technical matters in a Java J2EE environment with IBM Websphere Commerce. Over time I became the main coach for the main office and worked with a larger group developing the new eCommerce shop for Walz. Coaching topics included product development vs service delivery, information visualization, integration of non-developers, restructuring a traditional retailer to become an eCommerce company, new roles and skills. For 2017 Walz wants to bring all shop development inhouse and I started in 2016 to train newly hired developers on microservices architecture and the DevOps model.</p>
	</dd>

	<dt>Agile Coach <em>in cooperation with other Agile Coaches</em></dt>
	<dd>
		<p class="client">2016, Alfa Bank, Moscow, Russia</p>
		<p>Did anamesis with a number of several development groups over the course of a whole week and created a proposal about creating a DevOps culture within a division for management. Received approval to proceed in 2017.</p>
	</dd>

	<dt>Agile Coach</dt>
	<dd>
		<p class="client">2016, Deutsche Bank, Frankfurt, Germany</p>
		<p>Tought Product Owners and team members from different vendors the basics of Scrum. Introduced User Story Mapping. Performed a three day learning week to introduce kanban elements and the concept of 3 Amigos via paper prototypes amongst others. Consulted on team size and shape and what Scrum can do for the organization.</p>
	</dd>
	
	<dt>Agile Coach <em>in cooperation with other Agile Coaches</em></dt>
	<dd>
		<p class="client">2015, Bank Otkritie, Moscow, Russia</p>
		<p>Performed initial workshops about team formation, team coaching with management. Did organizational anamnesis and proposed potential solutions to populate first version of Coaching Map as a guiding tool going forward.</p>
	</dd>
	
	<dt>Agile Coach <em>in cooperation with resident Scrum Master</em></dt>
	<dd>
		<p class="client">2015, AXA Groupsolutions, Cologne, Germany</p>
		<p>Performed introductory workshops about Acceptance Test-Driven Development for project leaders and team members.</p>
	</dd>
	
	<dt>Consultant / Trainer <em>with resident Scrum Master</em></dt>
	<dd>
		<p class="client">2015, Virtual Solution, Munich, Germany</p>
		<p>Performed workshops, in the form of code retreats, with two teams on test automation, clean code and architecture, intra-team collaboration and Specification by Example for IOS and Android platforms.</p>
	</dd>
	
	<dt>Consultant <em>working with Department Leader</em></dt>
	<dd>
		<p class="client">2015, Huawei Technologies, Munich, Germany</p>
		<p>Management report on organizational and human factors for dealing with complexity in software product development.</p>
	</dd>

	<dt>Agile Coach / Scrum Coach <em>working with Project Managers and Department Leaders</em></dt>
	<dd>
		<p class="client">2014, Huawei Technologies, several cities, China</p>
		<p>Introduced ATDD and situational kanban after client’s failed attempt to do so to several teams and coached middle management on agile principles.</p>
	</dd>
	
	<dt>Agile Coach / Scrum Coach <em>pairing with resident Scrum Masters</em></dt>
	<dd>
		<p class="client">2013 - 2014, Webtrekk, Berlin, Germany</p>
		<p>Coached the CTO on agile principles and testing. Introduced Acceptance Test-Driven Development and coached Scrum Masters.</p>
	</dd>
	
	<dt>Interim Scrum Master <em>for development group</em></br>
		Agile Coach / Scrum Coach <em>working with Department Heads</em></dt>
	<dd>
		<p class="client">2013 - 2014, OBI Smart Technologies, Wermelskirchen, Germany</p>
		<p>Led a Scrum team. Added testers to the team. Improved requirements gathering and intra-departmental collaboration. Coached department heads on agile values &amp; principles. </p>
	</dd>
	
	<dt>Agile Coach / Scrum Coach <em>working with team leaders</em></dt>
	<dd>
		<p class="client">2012, Independent Health, Buffalo, New York, USA</p>
		<p>Coached SOA teams on Acceptance Test-Driven Development and created a technical tool for doing it.</p>
	</dd>
	
	<dt>Agile Coach / Scrum Coach <em>working with Iteration Managers and Application Development Leaders</em></dt>
	<dd>
		<p class="client">2009 - 2011, Nationwide Insurance, Columbus, Ohio, USA</p>
		<p>Participated in an agile transformation spanning 23 teams and personally provided technical and organizational coaching to 6+ teams and about 80 individuals.</p>
	</dd>

	<dt>Software Developer <em>on a self-organizing geographically distributed international team</em></dt>
	<dd>
		<p class="client">2008 - 2009, Serials Solutions, Seattle, Washington, USA</p>
		<p>As part of a 6 person team I co-created the Summon product.</p>
	</dd>
	
	<dt>Agile Coach / Scrum Coach <em>working with Software Architects</em></dt>
	<dd>
		<p class="client">2008, Nationwide Insurance, Columbus, Ohio, USA</p>
		<p>Coached software architects and team members on agile development practices including test-driven development and continuous integration.</p>
	</dd>

	<dt>Project Manager, Scrum Master</dt>
	<dd>
		<p class="client">2007 - 2009, Caimito Development, Panama City, Panama</p>
		<p>Developed the agile lifecycle management tool Caimito One Team, which was aimed at distributed Scrum teams.</p>
	</dd>
	
	<dt>Software Developer</br>
		Agile Coach / Scrum Coach <em>working with Project Manager and CEO</em></dt>
	<dd>
		<p class="client">2007, Cloud9 Analytics, San Mateo, California, USA</p>
		<p>Built Cloud9's Messenger product (webapp) (from inception to deployment to production) using Scrum as methodology.</p>
	</dd>
	
	<dt>Agile Coach / Scrum Coach <em>working with team members and CEO</em></dt>
	<dd>
		<p class="client">2006 - 2007, RealWorld Systems, Panama City, Panama</p>
		<p>Coached team on Scrum and XP practices.</p>
	</dd>
</dl>

## Founder and CEO of various ventures
<dl class="resume">
		<dt>Founder Caimito Development S.A.</dt>
		<dd><p>2006 - 2009, Panama</p>
			<p>Outsourcing projects for customers in USA.</p>
			<p>Development of the agile lifecycle management tool Caimito One Team from idea to market introduction.</p>
		</dd>

		<dt>Founder Caimito Technologies LLC</dt>
		<dd><p>2003 - 2006, Florida, USA</p>
			<p>Professional services in the areas systems operation, networking, software development.</p>
		</dd>
	
		<dt>Founder, CEO at DINX GmbH</dt>
		<dd><p>1999 - 2003, Germany</p>
			<p>Hosting of Application Servers</p>
			<p>Operations of IP Backbone and access concentrators</p>
			<p>Web development</p>
		</dd>

		<dt>Co-Founder, CEO at Farside Communications</dt>
		<dd><p>1997 - 2001, Germany</p>
			<p>Regional Internet Access Provider for the region Rhein-Neckar in the southern part of Germany.</p>
			<p>IP backbone network with of 4 intra-city distribution hubs for DSLAMs and several BGP connections to other carriers.</p>
			<p>Security systems including firewalls, intrusion detection systems, virtual private networks on a national and international scale.</p>
			<p></p>
		</dd>

		<dt>Co-Founder, CEO at VentureNET</dt>
		<dd><p>1995 - 1996, Germany</p>
			<p>Co-Founded VentureNET GmbH in Heidelberg, Germany, together with Heidelberg based consulting company OSS Consulting GmbH and two partners. Served as member of the board and was responsible for the company's Internet division.</p>
		</dd>

		<dt>Co-Owner, Software Architect at SoftStream Development</dt>
		<dd><p>1989 - 1996, Germany</p>
			<p>Convince, an illustration and presentation graphics program was developed from 1989-1990 and marketed in Germany. It was written in Modula-2 for the GEM/3 environment on DR-DOS and MS-DOS.</p>
			<p>DEO - Documents of Embedded Objects - was a software technology in C/C++ on Windows 3.0 that is a little bit comparable to OLE 2 from Microsoft. The product knew a container application with software components running inside. Available software components were a spreadsheet, illustration graphics, presentation graphics and a word-processing component from a third party.</p>
		</dd>
</dl>
