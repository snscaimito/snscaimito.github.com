---
layout: post
title: Busy, busy, busy
tags:
- en
categories:
- Software-Development
- Miscellaneous
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>It's been a bit quite here on my blog lately. I've been just too busy with work and family to write about interesting things. So I'm now trying to catch up and tell what has been going on.</p>

<p>We <a href="/2008/12/28/left-the-city-behind-and-went-4x4.html">moved</a> to a house in the mountains and are learning every day a few new things. Living in a house instead of an apartment is quite different and has a few challenges. You simply have to take care of things yourself or hire someone. In an apartment building you can call the building administration and they will take of it.</p>

<p>Living outside Panama City, which is not very different from other big cities in the world, is different in multiple ways. It's not like living in a small town in Europe. You can't walk to the neighborhood grocery store. From where we are it takes a 30 minutes drive down the hill to the beach community of <a href="http://maps.google.com/maps/ms?msa=0&amp;msid=108172307514406683037.00000111bff470fe699e2">Coronado</a> to find a real supermarket. That one there is El Rey. We've shopping in another branch of the same chain while living in the city. El Rey in Coronado still is different. As Coronado fills up on weekends and empties out for the week El Rey there carries mostly party food and beverages. While they have a good asortment of vegetables and other fresh produce in the city, they don't have that in Coronado. Which is quite astonishing, because a lot of fresh produce grows not far away from where we are. So we've started to figure out from who we can buy it directly. No real results as of yet - too busy with other things ... but at least we've found some little sweet peppers growing wild in the backyard. So that's a nice surprise.</p>

<p>In my work many things happened. Not only did we finish our own product Caimito One Team. We've got a new client as well and that project has grown and allowed me to use a number of interesting technologies in short time.</p>

<p>For that project I created a piece that allows different components to communicate with eachother using Apache ActiveMQ and Camel. Camel is an implementation of Enterprise Integration Patterns and quite an interesting piece of software technology.</p>

<p>Later on we discovered that our demands cannot be met using Hibernate. It is an application that processes a very huge number of documents and maxes out a lot of expensive hardware. I tried to optimize and cache as best possible, but as we have a lot of writes to the database I ended up implementing batching with pure JDBC. While doing so I drew a number of conclusions about that whole ORM topic. Another post ...</p>

<p>In the beginning we used the Spring Framework as IoC container and to interface with other technologies such as Hibernate. Seemed a good choice given the fact that Camel is built using Spring as well. As we moved away from JMS and Camel to a more simplistic approach due to performance reasons we abandoned Spring Framework as well. I did not miss IoC so I opted to use Tapestry IoC. Tapestry IoC is a very lightweight IoC container and very fast to wire up the application. It's being used inside the web framework Tapestry 5. There is nothing preventing one from using it in standalone applications and so far I'm not disappointed by its abilities.</p>

<p>Although I'm not the expert on the team for search technologies the project so far allowed me to learn something about Apache Solr, which is a search server implemented on top of Apache Lucene. In my spare time I was able to play a bit with Solr and tried bit around the "this document is related to" feature. This is similar to what you see on Google when it says "did you mean". I've got some ideas for future development tools as extension to Caimito One Team - but of course I have to think more that. When time comes, I'll tell more about it here.</p>

<p>Hopefully there is time to share a few of the experiences made with the technologies I just mentioned in future posts.</p>

