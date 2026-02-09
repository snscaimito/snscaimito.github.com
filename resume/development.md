---
layout: special
title: Stephan Schwab - Software Developer
---
<button class="print-button" onclick="window.print()">Print this resume (as PDF)</button>

<div class="overview">
	<div>
		<span style="color: green">Programming languages</span>: proficient in Java (J2EE, JBoss, WebSphere, Tomcat, Jetty, Spring Framework family, Spring Boot), JavaScript (ECMAscript) (browser and NodeJS) and JS frontend frameworks (VueJS, React, Angular and similar). Can do Ruby (Ruby on Rails), C, C++ and Objective-C. Used BASIC, Pascal, Perl, Python, Modula-2, TypeScript, VisualBasic (and developed extensions), x86/68000 Assembler. <em>Can still read COBOL.</em>
	</div>
	<div>
		<span style="color: green">Databases</span>: SQL, stored procedures (MS SQL, MySQL, MariaDB, PostgreSQL, Oracle), NoSQL (MongoDB)<br/>
		<br/>
		<span style="color: green">Search engines</span>: Apache Solr, Lucene, full-text search in databases<br/>
		<br/>
		<span style="color: green">World Wide Web</span>: Hypertext (HATEOAS), HTML, CSS, able to create a website with no framework
	</div>
	<div>
		<span style="color: green">Concepts</span>: messaging (Pub/Sub, IBM MQ, RabbitMQ, ActiveMQ, MQTT); Event-Based Architecture; Object-Oriented Programming (OOP); Domain-Driven Design (DDD); Clean Code; functional, procedural, structured, declarative programming paradigms. Familiar with UML, state/flow diagrams.
	</div>
	<div>
		Networking: Ethernet, TCP/IP, DNS, application protocols (HTTP/HTTPS, SMTP, NNTP, other RFCs), routing protocols (BGP, OSPF), DHCP, Firewalls, Cisco routers, LoRa, Internet of Things, LoRaWAN, built and ran an ISP (xDSL) and datacenter
	</div>
	<div>
		Industrial and agricultural automation: sensors, solenoid valves, actuators, MQTT, Home Assistant, event/rules engines
	</div>
	<div>
		Working knowledge of <span style="color: brown">Lean (inkl. TPS), Kanban, Scrum (since 2006)</span>, <span style="color: green">DevOps</span>, and the original <span style="color: green">Waterfall model</span> by W. Royce, mob and <span style="color: green">pair programming</span>
	</div>
	<div>
    <span style="color: blue">Test-Driven Development</span> (TDD, BDD, ATDD with Cucumber, Behave) and <span style="color: blue">CI/CD (trunk based)</span> advocate.
	</div>
	<div>
		Development on Linux since 1993 (v0.98), Windows since 1989 (v2.11), Windows NT since 1993 (v3.1), MacOS since 2001; Infrastructure as Code (Ansible, Chef, Terraform); Virtualization (Docker, Kubernetes, Linux KVM, Vagrant, VirtualPC, VMware)
	</div>
	<div>
		Conceptually familiar with machine learning, artificial intelligence, neural networks. Heavy user of GitHub Co-Pilot and ChatGPT as assistants.
	</div>
</div>

{% include_relative trustedBy.html %}

## Project History
Software development is typically a "team sport". Highlighting individual contributions and personal performance is actually a negative sign. Therefore I avoid saying "I did X" but prefer to mention what "we did". That does not take away any credit from my own contributions to that team effort. Due to my extensive experience, I happen to be in a leading role for a topic frequently and people like to follow my advise or recommendations.

Client contacts and further details for the projects listed are available on request.

<style>
DIV.history {
  display: flex;
  flex-direction: column;
  gap: 2em;
}

DIV.history > DIV {
  display: grid;
  grid-template-columns: 10em auto;
  gap: 2em; 
}

DIV.history > DIV > DIV:first-child {
  background-color: #f0f0f0;
  border-radius: 10px;
  padding: 1em;
  font-size: larger;
  font-weight: bold;
}
</style>

<div class="history">
  <div>
    <div>2024</div>
    <div>
      <p>Development of an agroforestry planning and design tool. ChatGPT is used extensively for research about plant species and their properties as well as a means to speed up development tasks.</p>
      <ul>
        <li>Fully automated build and deployment (CI/CD)</li>
        <li>Trunk-based development</li>
        <li>Java</li>
        <li>Spring Boot (MVC, REST, Data)</li>
        <li>Thymeleaf</li>
        <li>htmx for HTML5/CSS3 frontend instead of a framework</li>
        <li>HTML5, CSS3</li>
        <li>MongoDB</li>
        <li>ChatGPT for subject matter research</li>
      </ul>
      <p>Client: Caimito Services, USA</p>
      <p>Industry: Agriculture</p>
    </div>
  </div>

  <div>
    <div>2024</div>
    <div>
      <p>Evaluated, planned and installed IoT gateway and end nodes to monitor soil humidity, temperature and conductivity to provide automated irrigation to a Miyawaki style forest co-financed by the European Union's LIFE program (via LifeTerra foundation).</p>
      <ul>
        <li>Created dashboards and automations for power monitoring, to control water pumps and other devices</li>
        <li>Did the electrical installation and software. The system is solar powered and off the utility grid.</li>
        <li>Internet of Things Network</li>
        <li>LoRaWAN</li>
        <li>NPC</li>
        <li>BLE</li>
        <li>Home Assistant</li>
        <li>Dragino, Milesight, Shelly, and SMA devices</li>
        <li>Docker, Docker Compose</li>
      </ul>
      <p>Client: Caimito Agile Life, Spain</p>
      <p>Industry: Agriculture</p>
    </div>
  </div>

  <div>
    <div>2021 - 2022</div>
    <div>
      <p>Worked 100% remote with an international DevOps style group on an internal application to manage SonarQube in combination with GitHub Enterprise.</p>
      <ul>
        <li>Backend development in Java</li>
        <li>Frontend development in JavaScript with Vuetify</li>
        <li>Maintenance of Terraform scripts and Helm charts for Kubernetes deployment</li>
        <li>Fully automated build and deployment (CI/CD)</li>
        <li>Code reviews and use of Pull Requests (PR) via GitHub Enterprise</li>
        <li>Developer support for .NET group</li>
        <li>Coaching of Junior Developers</li>
        <li>Java</li>
        <li>Quarkus</li>
        <li>Quarkus Native, GraalVM</li>
        <li>Hibernate</li>
        <li>Maven</li>
        <li>VueJS</li>
        <li>Vuex Store</li>
        <li>TypeScript</li>
        <li>Vuetify</li>
        <li>SonarQube</li>
        <li>Cypress</li>
        <li>Docker</li>
        <li>Microsoft Azure</li>
        <li>Kubernetes on Azure, Ubuntu Micro K8s</li>
        <li>Terraform</li>
        <li>Helm charts</li>
        <li>Keycloak</li>
        <li>Microsoft .NET</li>
        <li>Microsoft C#</li>
      </ul>
      <p>Client: Mercedes-Benz Bank, Germany</p>
      <p>Industry: Financial Services</p>
    </div>
  </div>

  <div>
    <div>2021 - 2023</div>
    <div>
      <p>Development of frontend application and marketing website CaimitoEU</p>
      <ul>
        <li>JavaScript</li>
        <li>VueJS, VueRouter</li>
        <li>HTML5, CSS3</li>
        <li>TailwindCSS</li>
        <li>Consumption of RESTful APIs</li>
        <li>PayPal integration for payment processing</li>
        <li>Web shop with shopping cart and product listing (overview, details)</li>
        <li>Internationalization (i18n) in English, German, Spanish</li>
        <li>Trunk-Based Development with feature flags and Continuous Deployment</li>
        <li>Cypress</li>
        <li>Keycloak (OAuth2)</li>
        <li>Docker, Docker Compose</li>
        <li>NGINX</li>      
        <li>Multiple GitHub Actions workflows for automated build and deployment (CI/CD)</li>
        <li>Set up and maintenance of production, staging and test environments via Ansible (Debian based virtual servers)</li>        
      </ul>
      <p>Client: Caimito Agile Life, Spain</p>
      <p>Industry: Agriculture</p>
    </div>
  </div>

  <div>
    <div>2021 - 2023</div>
    <div>
      <p>Development of ERP system GranjaEU for smallholdings</p>
      <ul>
        <li>Product design, software development and UX design</li>
        <li>Restful API development for external users</li>
        <li>Internationalization (i18n) in English, German, Spanish</li>
        <li>Test-Driven Development, Rapid Prototyping</li>
        <li>Trunk-Based Development with multiple daily deployments to production</li>
        <li>Delivery of emails via JavaMail via Google SMTP services</li>
        <li>Multiple GitHub Actions workflows for automated build and deployment (CI/CD)</li>
        <li>Set up and maintenance of production, staging and test environments via Ansible (Debian based virtual servers)</li>
        <li>Java</li>
        <li>Spring Boot (REST, Data, Mail, Thymeleaf, Security)</li>
        <li>Flyway</li>
        <li>JUnit</li>
        <li>Maven</li>
        <li>JavaScript</li>
        <li>VueJS</li>
        <li>Vuetify</li>
        <li>HTML, CSS</li>
        <li>Cypress</li>
        <li>Keycloak (OAuth2)</li>
        <li>Docker, Docker Compose</li>
        <li>MongoDB</li>
        <li>PostgreSQL</li>
        <li>NGINX</li>
      </ul>
      <p>Client: Caimito Agile Life, Spain</p>
      <p>Industry: Agriculture</p>
    </div>
  </div>

  <div>
    <div>2020</div>
    <div>
      <p>Backend for Social Network</p>
      <ul>
        <li>NodeJS</li>
        <li>JavaScript</li>
        <li>VueJS</li>
        <li>HTML, CSS</li>
        <li>Functional programming with promises and lodash/fp</li>
        <li>Coached Senior JavaScript Developers on test-driven development (TDD)</li>
        <li>Cucumber.js</li>
        <li>Chai</li>
        <li>JEST</li>
        <li>Integration of several external services like OneSignal, Firebase</li>
        <li>JSON Web Token Authentication</li>
        <li>Geographically distributed team with team members working from individual locations in Europe, Japan, and USA.</li>
        <li>Support for debugging an IOS application</li>
      </ul>
      <p>Client: PH7, Japan</p>
      <p>Industry: Social Networks</p>
    </div>
  </div>

  <div>
    <div>2011 - 2012</div>
    <div>
      <p>Created rmq - A Ruby Wrapper for the IBM MQ Series client API</p>
      <ul>
        <li>Ruby</li>
        <li>Cucumber</li>
        <li>IBM MQ Series Message Broker</li>
        <li>SOA based application in an integration project</li>
        <li>Coached a large group of developers and testers on Acceptance Test-Driven Development with Cucumber and my tool rmq</li>
      </ul>
      <p>Client: Independent Health, Buffalo, New York, USA</p>
      <p>Industry: Insurance</p>
    </div>
  </div>

  <div>
    <div>2011</div>
    <div>
      <p>Vastly extended RAutomation per client request. RAutomation is a tool to automated Windows desktop programs for testing purposes and enable to use of Cucumber in the context of Acceptance Test-Driven Development.</p>
      <ul>
        <li>C, C++</li>
        <li>Windows Win32 API</li>
        <li>DLL development with Visual Studio</li>
        <li>Ruby</li>
        <li>Cucumber</li>
        <li>Automation of desktop application via Win32 API calls and accessibility features of Windows</li>
      </ul>
      <p>Client: Nationwide Insurance, Columbus, Ohio, USA</p>
      <p>Industry: Insurance, Financial Services</p>
      <p><a href="https://github.com/snscaimito/RAutomation">Code on GitHub</a></p>
    </div>
  </div>

  <div>
    <div>2009 - 2011</div>
    <div>
      <p>In an embedded Senior Developer Advocate role participated in an agile transformation spanning 23 teams and personally provided technical and organizational coaching to 6+ teams and about 80 individuals.</p>
      <ul>
        <li>Java, J2EE</li>
        <li>IBM Rational Application Developer</li>
        <li>IBM Websphere</li>
        <li>Spring Framework</li>
        <li>Spring Batch</li>
        <li>Oracle SQL</li>
        <li>Ruby</li>
        <li>Cucumber</li>
        <li>Pair programming with Developers and Testers</li>
        <li>Mob / Ensemble programming</li>
        <li>Business Analysis</li>
        <li>Story Mapping</li>
        <li>Executable Specification (ATDD)</li>
      </ul>
      <p>Achieved to deliver to production a prototype application within weeks and in time for the first presentation to the internal customer.</p>
   		<p>Client: Nationwide Insurance, Columbus, Ohio, USA</p>
      <p>Industry: Insurance, Financial Services</p>
    </div>
  </div>

  <div>
    <div>2008 - 2009</div>
    <div>
      <p>As Senior Software Developer co-created the Summon product. The product ingests academic reference data from different sources, normalizes it and creates a search index for use by a frontend application.</p>
      <ul>
        <li>Java, standalone</li>
        <li>Apache Solr</li>
        <li>Apache Lucene</li>
        <li>Apache Camel</li>
        <li>XML</li>
        <li>Apache ActiveMQ</li>
        <li>Mentoring remote Chinese team members</li>
        <li>Remote work with an on-site week every 3 months for team coordination</li>
      </ul>
  		<p>Client: Serials Solutions, Seattle, Washington, USA</p>
      <p>Industry: Academic Publisher</p>
    </div>
  </div>

  <div>
    <div>2008</div>
    <div>
      <p>Contractor role to uplift technical skills of software architects and team members on agile development practices including test-driven development and continuous integration.</p>
      <ul>
        <li>Java</li>
        <li>Ruby</li>
        <li>Cucumber</li>
        <li>Spring Framework</li>
        <li>IBM Websphere</li>
        <li>Oracle SQL</li>
      </ul>
      <p>Client: Nationwide Insurance, Columbus, Ohio, USA</p>
      <p>Industry: Insurance, Financial Services</p>
    </div>
  </div>

  <div>
    <div>2007 - 2009</div>
    <div>
      <p>Developed the agile lifecycle management tool Caimito One Team for distributed Scrum teams.</p>
      <ul>
        <li>Java</li>
        <li>JavaScript</li>
        <li>HTML, CSS</li>
        <li>Thymeleaf</li>
        <li>MySQL</li>
        <li>Hibernate</li>
        <li>Spring Framework</li>
        <li>Software activation via cryptographic key</li>
        <li>Deployment as a on-premises software</li>
      </ul>
      <p>Client: Caimito Development, Panama City, Panama</p>
      <p>Industry: Software</p>
    </div>
  </div>

  <div>
    <div>2007</div>
    <div>
      <p>Built Cloud9's Messenger product (webapp) (from inception to deployment to production) using Scrum as methodology.</p>
      <ul>
        <li>Java</li>
        <li>JavaScript</li>
        <li>HTML, CSS</li>
      </ul>
      <p>Client: Cloud9, San Mateo, California, USA</p>
      <p>Industry: eCommerce</p>
    </div>
  </div>

  <div>
    <div>Previous work</div>
    <div>
      <p>I develop software since the early 1980s and have used numerous development tools and programming languages on many different operating systems and environments.</p>
      <p>In the 1990s I created one of Germany's early Internet Service Providers (my own company). Besides being co-founder I developed internal applications for provisioning and billing, deployed and configured routers and other devices to connect customers to our network.</p>
    </div>
  </div>
</div>
