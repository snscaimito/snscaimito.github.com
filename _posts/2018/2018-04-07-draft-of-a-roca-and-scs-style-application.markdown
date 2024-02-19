---
layout: post
title: Draft of a ROCA- and SCS-style application
tags:
- en
- farm-it
categories:
- software_development
---
I had been working on and off on what I call the Meal Planner application before I discovered the idea of Self-Contained Systems (SCS). The concept made a lot of sense to me and as I was already planning on using containers I quikly set out to make a few changes.

The code for it is in the open at [GitHub](https://github.com/snscaimito/farm_meal-planner)

## Continuous Integration for a single developer
I have to make a confession. I don't use a CI server regularly :-)

As I am working alone and am not part of a team a tool like Jenkins doesn't really help me. Frequently I am physically somewhere and only have my laptop. If I were using a Jenkins installation it would have to be accessible over the open Internet, which would require a server somewhere in a datacenter and a VPN connection to reach it or I would be running it exposed to the world. There is really no benefit for me as I'm the only contributor to the codebase.

Instead I build everything around my own command line and that means I focus on shell scripts and a local production like environment.

If at some point I happen to have a team, all of that could be easily put into Jenkins as long a I treat the CI server as some sort of a glorified scheduler.

## Target runtime environment
As of now my target runtime environment is a Linux host (Debian/Ubuntu) with nothing else installed but the [Docker Engine](https://www.docker.com). I'm trying to keep everything isolated in containers and so the host itself can be quite dumb.

## Development workflow, project structure, tooling
Here are a few considerations regarding my development workflow:

* run a multi-piece application locally in a production-like environment
* build and test containers, then store into a repository
* deploy tested containers as a single unit from a repository into production

Unlike in the past I don't want to deploy a WAR or JAR file to any type of application server. Instead the smallest unit for deployment is a Docker container. The container is also the unit that undergoes testing. If it is found to be good, it gets stored under a version number to a repository and the very same container images is deployed to a Docker engine on production host(s) where the container can be run several times for scaling.

In order to satisfy my first point I use a custom shell script with the following options:

    12:52 sns ~/dev/farm/farm_meal-planner  (master)$ ./localrun.sh
    Usage:
    --help    displays help
    up        run without rebuilding
    down      put all containers down
    rebuild   rebuild and run

As of today my directory structure looks like this:

    -rw-r--r--@  1 sns  staff   330 Feb 23 10:17 Dockerfile-cucumber
    -rw-r--r--@  1 sns  staff   183 Mar  3 21:57 Gemfile
    drwxr-xr-x   8 sns  staff   256 Mar 12 12:56 common
    drwxr-xr-x   9 sns  staff   288 Mar 12 23:03 cookbooks
    -rw-r--r--@  1 sns  staff   512 Mar 18 02:00 docker-compose-dev.yml
    drwxr-xr-x  13 sns  staff   416 Mar 15 22:35 features
    drwxr-xr-x   3 sns  staff    96 Mar 14 15:56 frontend
    -rwxr-xr-x@  1 sns  staff  1442 Apr  6 12:52 localrun.sh
    -rwxr-xr-x@  1 sns  staff   679 Mar 11 14:59 localtest.sh
    drwxr-xr-x   9 sns  staff   288 Mar 14 15:58 main
    drwxr-xr-x   9 sns  staff   288 Mar  8 20:14 navigation
    drwxr-xr-x  10 sns  staff   320 Mar 11 20:19 recipes
    drwxr-xr-x   8 sns  staff   256 Mar 11 13:02 styles

The directories <code>common</code>, <code>cookbooks</code>, <code>main</code>, <code>navigation</code>, <code>recipes</code>, <code>styles</code> contain independent Maven projects.

<code>localrun rebuild</code> performs <code>mvn package</code> for each of these projects and creates an artifact (JAR file). Then Docker containers are build for each application and eventually started by <code>docker-compose</code>.

In the end I have a production like environment (via Docker engine) on my laptop can I can access the application(s) through <code>http://localhost</code> and see something like this:

{% include image.html name="main_screen.png" %}

To specify what my application(s) are supposed to be doing and for automated testing I use Cucumber. I created another shell script <code>localtest.sh</code> which I can either use to test a specific application or the whole:

    00:51 sns ~/dev/farm/farm_meal-planner  (master)$ ./localtest.sh --help
    Usage:
    all         Test the whole application on port 80
    recipes     Test only recipes on port 8080

It sets a few environment variables and then runs Cucumber in the context of a Bundler bundle. As I run it on my laptop I can visually supervise how a real Google Chrome browser or any other is being used to access the application(s).

I've done some experiments to run it unattended on Jenkins in the way described in [*Testing with Selenium Docker container*](/2018/01/07/testing-selenium-docker-container.html) but at the time being I'm not interested in using Jenkins for the reasons stated earlier. That will likely change in the future when running all my acceptance tests takes longer than 5 minutes and I want to offload that task to a machine.

{% include series-footer.html seriesTag = "farm-it" %}
