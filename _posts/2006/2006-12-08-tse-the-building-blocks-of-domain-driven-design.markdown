---
layout: post
title: ! '[TSE] The Building Blocks of Domain Driven Design'
tags:
- en
categories:
- miscellaneous
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>Keith Donald's talk at The Spring Experience has started. Right now he's summarizing what <a href="/2006/12/08/1165587482609.html">Eric</a> told us before.</p>

<p>A domain model does not capture every aspect of the real world. Instead it's a simplistic view of the world to serve a purpose. Discoveries during the implementation feed back into the model design.</p>

<p>Isolate the domain by using a layered architecture. Do not mix UI, database, external services and business objects all together. The very same isolation allows unit testing and Spring helps in the wiring of the units.</p>

<p>Keith shows a diagram with the user interface on top of the application and the application on top of the domain and everything on top of the infrastructure. The application layer delegates tasks to the domain layer for complex solutions.</p>

<p>The domain layer represents business rules and states.</p>

<p>The infrastructure layer interacts with the database, constructs UI widgets and deal with everything technical.</p>

<p>The domain layer is to isolate the domain objects from other functions in the system to avoid mixing technical and domain concepts. One should bind the model the implementation early. Implement the behavior of the application within the domain model classes without thinking about the technical infrastructure. The resulting artifact is a unit test.</p>

<p>In the beginning map domain entities literally to Java objects. Some of these mappings may be wrong in the end and you will need to refactor, but it's a start. Then start writing unit tests using those classes. Keith is now showing actual code of unit tests for his reward dining example.</p>

<p>Organize domain behaviors into coarse-grain, high-level user operations. Make user operations part of the application layer. Unit tests in the domain layer are a good place to look for application layer use-cases. The application layer encapsulates complex domain layer objects and rules and allows for freedom in the implementation. After defining the boundaries of the application layer focus on streamlining the domain model implementation.</p>

<p>Streamline associations between model objects. If you don't understand why an association is needed, avoid it. Association create coupling, which is generally to be avoided. Impose a traversal direction on associations.</p>

<p>Entities, value objects and services. Often entities are persisted to a database. Entities maintain their identity that never changes. Entities may be used by other applications and need to be tracked. They have a life cycle and the model needs to define what it means to be the same thing. String entity objects down to the most intrinsic characteristics and only add required behavior and attributes needed for that behavior. For everything else add associated objects.</p>

<p>Value objects are identified by their attributes and often they are interchangeable and transient. Value objects can be shared and are good candidates for immutability. They reduce bugs by avoiding invariants.</p>

<p>Services are activities or actions, not a thing. A service is something that makes it happen and is stateless. Services should be thin coordinators and one should resist the urge to develop fat services that attempt to solve the problem all on their own. Look for natural opportunities to encapsulate behavior in services that doesn't make sense within Entities or Value Objects. The main responsibility of a service is to orchestrate things, to coordinate. It delegates to entities to do the work.</p>

<p>The creation of Entities should be done using factories and repositories that restore an entity object from a persistent form. Services control and coordinate the life cycle of entities.</p>

<p>Someone asked whether a repository isn't a service. Keith answers is that a repository is a DAO service, but with a very simple job. It doesn't coordinate work and therefore it wouldn't be justified to call it a service.</p>

<p>Make sure that your factories and repositories return fully initialized objects to their callers.</p>

