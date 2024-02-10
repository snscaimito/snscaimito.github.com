---
layout: post
title: Selecting a test and automation tool for IOS
tags:
- en
- ale-news-service
categories:
- atdd
- software_development
---
My development process or method is ATDD, which stands for Acceptance Test-Driven Development. As the actual development should be driven by a test, it does mean that I write the test before I write the production code of the application.

So far I have used Cucumber for Java and scenarios, which describe expected application behavior from the user's perspective in natural language, to test-drive the development of the Article Service and the (rudimentary) web-based client application.

{% include ale-news-post-header.html %}

This approach requires the developer to be able to automate the application that being created. For a web service it means calling the web service from another program, which is nothing special, as the whole point of a web service is to be consumed by other programs. For the web client it means to automate a web browser simulating user interaction. That is a bit special but tools like Selenium or Watir, now merged as Selenium WebDriver, do a superb job at doing that.

For mobile platforms like IOS and Android there are similar tools available. Usually these tools leverage the accessibility API built into the platform.  Accessibility is a feature that allows people with some disability to access the user interface of a computer program with the help of special devices or by enlarging portions of the text and other means. In the end the user interface of an application is being used by another program that makes it available to humans with special needs. Automation tools now use that feature to make the user interface available to another program instead of a human.

## Appium
After some research I decided to use Appium. Appium is an implementation of the Selenium WebDriver API and runs as a RESTful web service. The test script tells Appium what to do and Appium then uses the appropriate means to relay the request to the IOS automation tools or the Android automation tools. In my current case Appium starts the IOS simulator or deployes to a physical device and controls the application via the Instruments application on OS X.

As Appium is a Selenium WebDriver I can use the API I already know from testing web applications. For mobile specific actions like touching the screen, panning, swiping, or shaking the device Appium has some extensions to that API. Here is an example:

```Ruby
screenshot "./test.png"

find_element(:name, 'IntegerA').send_keys('1')
find_element(:name, 'IntegerB').send_keys('23')
find_element(:name, 'ComputeSumButton').click
puts "Answer = #{find_element(:name, 'Answer').value}"

find_element(:name, 'show alert').click

wait { text 'this alert is so cool' }
```

But before I can really make good use of Appium I need to learn a bit more IOS programming itself. I'm in the middle of that ...

{% include ale-news-post-footer.html %}
