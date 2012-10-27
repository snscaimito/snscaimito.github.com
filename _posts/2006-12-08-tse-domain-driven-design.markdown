---
layout: post
title: ! '[TSE] Domain Driven Design'
tags:
- en
- Miscellaneous
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>I'm sitting in Eric Evans' talk "Introduction to Domain Driven Design" at The Spring Experience. The first question he is asking is whether your problem really is a technical problem. Technical people tend to see everything as a technical problem and seek technical solutions to solve it.</p>

<p>Understanding the problem domain better is key he is saying. I agree, but let's see how DDD can help with that.</p>

<p>Be careful not to mix your opinion or perception into the creation of your model. Be precise in your model. Avoid shortcuts and don't assume that details are already well-known.</p>

<p>Probably even very small projects will use multiple data models to help in the implementation of the solution. Objects created to deal with one model should not be taken out of context. This raises the need to convert information between the models.</p>

<p>Eric goes on saying that one should not try to come up with a big, every encompassing enterprise domain model, but instead a model for each part of the system. Frequently great object designs get modified so many times that in the end the original architecture will not be there anymore. It seems he proposes to isolate concerns, create the best model for a well defined part of the system and then find a way to interface those parts with each other.</p>

<p>Interesting: modeling does not drive an upfront design phase. In fact it would be wrong, because at the beginning of a project the team is ignorant about the problem domain. Trying to come up with a model at that stage will create the wrong thing.</p>

<p>Not tools like visual programming, UML diagrams and so on help to raise the needed level of abstraction. Instead proper use of language as the primary abstraction tool is important. Eric's favorite modeling tools are: whiteboard, IDE, unit tests to explore the model itself and, again, our mouths and ears.</p>

