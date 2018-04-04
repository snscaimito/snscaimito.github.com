---
layout: post
title: Considerations for a farm following the principles of Lean Startup
tags:
- en
- farm-it
categories:
- software-development
---
Now that I've aquired a farm in rural Spain I'm thinking about how to create a business around it. At the moment the farm is not producing anything. The former owner used to raise a few pigs and some cattle but it was mostly a huge place for the animals to roam around. That means I have no market, I have no customers, and no idea who might be interested in buying anything from the farm. I basically have a nice piece of land with a lot of potential but nothing else.

The concept of [Lean Startup](http://theleanstartup.com/principles) is based around going through the *build-measure-learn* loop continuously and as quickly as sensible and possible. This is based upon the technique of [Customer Development](https://en.wikipedia.org/wiki/Customer_development) which is about figuring out who might be a customer and what that person or organization might find useful and compensate me for providing a service or product.

Making money is really not a concern at this point but learning is. The money might show up eventually.

A farm is all about food and humans cook their food and like to share how they do it. My thought is that if I knew what people are cooking, then I might be able to produce and deliver them the ingredients for their dishes.

I came up with a first draft of a few customer touch points together with some other pieces of a customer journey map.

{% include image.html name="touchpoints.jpg" %}

There might be three starting points for a customer journey:

* People who look for recipes so that they can cook them or be inspired
* People who want to maintain their own personal cookbook with private recipes or shared recipes
* People who want to buy their ingredients from a farm instead of going to a supermarket

Only the last starting point has the potential of leading to a sale where money is paid for a product. The other two starting points could lead to the sale of a product but mostly provide an opportunity to learn about what people **might** be looking to buy.

I have to embrace the fact that probably a lot of people will not buy anything from me although they are using my recipe service. I might discover other revenue streams at some point but should not get distracted at the moment.

When I look at the picture above I see a number of applications that I will have to develop and maintain as well as other applications/services made by someone else.

I also discovered a few notifications paths:

{% include image.html name="notifications.jpg" %}

## The traditional approach
Several years ago I might have started to develop an application for external users - people who are not affiliated with the farm - and another one for all the internal users. Likely I would have used my then favorite Java web framework or one that looks like the next cool thing to use. Then I would have stored all the data in two big SQL database for each of those two applications.

## A different approach
As of now I don't have a development team. I also don't intent to employ a large number of people. Plus I have some doubts about ever having the economical ability to do so. That means I have a strong reason for keeping things as simple as possible up to the point that I can do most of the things on my own. It might be slow and here and there progress will come to a halt but then it should be easy to pick up and get going again.

Over time I've learned that there is a lot of tools and products out there that turn out to be great traps for [vendor lock-in](https://en.wikipedia.org/wiki/Vendor_lock-in). The vendor might also be an open source community - it's not only about money. I cannot afford that. I need to be as free as possible and as a person I also don't want to learn something that I cannot use outside of a context defined by someone else.

My research led me back to the basics of the Internet and what is called *The Web*:

* Open standards based on [RFCs](https://en.wikipedia.org/wiki/Request_for_Comments)
* [Resource-Oriented Client Architecture (ROCA)](http://roca-style.org)

Frameworks and libraries, I learned, should not be confused with each other. 

A framework tries to make a common task simple and is an implementation of someone's best practice for doing so. A framework is an opinion coded in a programming language. It's essentially a way to standarize something so that regular workers and do it quickly at a reasonable high quality. That's good but on the other hand doing something different becomes hard and requires special knowledge. That again leads to [vendor lock-in](https://en.wikipedia.org/wiki/Vendor_lock-in) and it doesn't matter if the framework happens to be free of cost and open source.

A library provides a number of tools to perform common tasks without coding an opinion or being a best practice for something. The scope of functionality covered by a library is much smaller.

Further I came across an article about [Self-Contained Systems and ROCA](https://blog.codecentric.de/en/2015/01/self-contained-systems-roca-complete-example-using-spring-boot-thymeleaf-bootstrap/). That inspired me to explore this concept and see how it might help me.


{% include series-footer.html seriesTag = "farm-it" %}
