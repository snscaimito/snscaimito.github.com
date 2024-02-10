---
layout: post
title: Testing with Selenium Docker Container
tags:
- en
categories:
- software_development
---
To run acceptance tests for a web application you want to use a real web browser just the same way a regular human user would do. With tools like Cucumber it is common to use Selenium WebDriver to remotely control a web browser like Chrome, Firefox, Internet Explorer or Safari.

My web application is being delivered as an executable JAR file created with Spring Boot that is packaged up as a Docker container. As in the [previous example](/2017/12/30/maven-docker-jenkins-pipeline.html) I use a Jenkins pipeline to build my project and put the resulting artifact into a Docker container that then gets put through the pipeline until it reaches a production environment. Before I was running my Cucumber acceptance tests in a separate container that is able to use the container under test.

I've been toying with the idea to install Chrome and the Chromedriver onto the same Ruby/Cucumber container. That seems what people have been doing before and it seems ok. But it never really worked for me. Plus, it seems that this is an approach one would use with a virtual machines while containers are not virtual machines per se. The idea behind Docker containers is part of a different philosophy which is basically: one application per container.

Thankfully the Selenium project is providing ready to use Docker containers for the exact same purpose I'm after. So here is my docker-compose.yml and you can see I'm using a third container in my setup: <code>selenium/standalone-chrome</code>

Note the line <code>JAVA_OPTS=-Dselenium.LOGGER.level=WARNING</code>. Without it the Selenium container will drown your console or logfile in INFO level messages for every request that comes in.

    version: '3'
    services:
      meal-planner-app:
        image: snscaimito/meal-planner-app:latest
        ports:
         - "9080:8080"
      selenium:
        image: selenium/standalone-chrome
        environment:
        - JAVA_OPTS=-Dselenium.LOGGER.level=WARNING
        ports:
        - "4444:4444"
        links:
        - meal-planner-app
      cucumber:
        environment:
        - HOST=meal-planner-app
        - PORT=8080
        links:
        - meal-planner-app
        - selenium
        volumes:
        - ./:/home/cucumber
        build:
          context: ./
          dockerfile: Dockerfile-cucumber

When I run docker-compose it will start up all three containers in the right order and make them visible to each other (note the links statements). Then I can create my Watir::Browser like this:

    browser = Watir::Browser.new :chrome, {timeout: 120, url: "http://selenium:4444/wd/hub"}

From that point on my Cucumber scenarios run as usual. I get screenshots taken when a scenario fails. In Jenkins I'm using the Cucumber Reports plugin. 

![CucumberReport]({{ "/img/posts/2018-01-07/CucumberReport.png" | relative_url }})

