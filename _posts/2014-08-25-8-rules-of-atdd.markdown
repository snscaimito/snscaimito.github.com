---
layout: post
title: The eight rules of ATDD
tags:
- en
categories:
- ATDD
- software-development
---
Recently someone at my current client was asking me about what they should do when "doing" ATDD. As the request was about a simple answer, I came up with a number of _shoulds_ and one _should not_. After I wrote these eight rules down we had a good group conversation to clarify and understand what each rule means and calls for.

Intentionally I was trying to use language that is a bit vague in order to encourage thinking and discussion.

## 1 - You should learn the ways of your customer
Learn as much about your customer as you can.

Find out what the customer wants to do with the product you are creating. Find out how the customer usually works - without your product. Find out what he values, what preferences he has.

## 2 - You should learn your customer's expectations
At the very end it is the customer who either accepts or rejects your creation. As it is unlikely that you will deliver something that is completely broken, it is your customer's perception that makes or breaks the deal. Perception is connected to expectations. If you don't understand what your customer expects from your creation, then it will be difficult to make him accept it and be delighted.

## 3 - You should specify the behavior of your product
With a solid understanding of your customer's situation and expectations you should explain what your product will do. Share the specification of the future behavior of your product with the customer to collect further feedback to make sure that you truly understand his expectations.

## 4 - You should deliver expected behavior
When customer and you share the same view about the expected behavior of your product you should deliver precisely that. You may change it later, together with your customer, but it is important to deliver what you both have agreed upon as that is part of your customer's expectation and makes you trustworthy - a very important piece of entering a trustful relationship that enables close collaboration.

## 5 - You should continuously document actual behavior of your product
Using techniques and tools that allow you to execute the specification of the expected behavior that your product will exhibit you document that the product is indeed behaving as specified.

## 6 - You should create trusted blocks of code
By using a technique like TDD (Test-Driven Development) you craft the product making up your product in many tiny steps. Because you write the test before the production code you will have good coverage and you will not create any code that is not really required. That way you create blocks of code that you can trust. The better you specify what the code should do and only code the requested behavior, the more you know that your code is trustworthy.

## 7 - You should assemble your product using trusted blocks of code
Now that you have created all the small pieces test-first you can continue with the bigger blocks. You continue to specify behavior, but this time on a higher level, and for the implementation you use the chunks that you have created earlier.

## 8 - You must not verify
That is probably the biggest surprise for many people. I'm really advocating that you should not verify. Not verify anything anymore that is. Because, if you did all the things listed before, then there is nothing left that you would have to verify. You've done it already extensively and performing additional tests would be just a waste of time and money.
