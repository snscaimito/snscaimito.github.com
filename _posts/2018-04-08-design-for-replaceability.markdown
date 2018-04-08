---
layout: post
title: Design for replaceability
tags:
- en
- farm-it
categories:
- software-development
---
{% include series-header.html introURL = "/2018/04/02/considerations-for-a-farm-following-the-principles-of-lean-startup.html" %}

The special thing about my application is that it is not really an application per se - at least not a single one. It's more of a compound thing that gets assembled at *the edge*. The edge in this case is the edge of the network and happens to be the webbrowser of the user. You could also say that that is where the integration happens.

As of now I have three SCS applications that provide their own user interface and a total of six running containers.

Here is the output of <code>docker ps</code> at the time my application is running:

    CONTAINER ID        IMAGE                        COMMAND                  CREATED             STATUS              PORTS                    NAMES
    04d888f2511a        nginx                        "nginx -g 'daemon of…"   2 weeks ago         Up 26 hours         0.0.0.0:80->80/tcp       farmmealplanner_frontend_1
    b46ccf41cd6a        farmmealplanner_cookbooks    "java -Djava.securit…"   2 weeks ago         Up 26 hours         8080/tcp                 farmmealplanner_cookbooks_1
    89e4532ae1fe        farmmealplanner_navigation   "java -Djava.securit…"   2 weeks ago         Up 26 hours         8080/tcp                 farmmealplanner_navigation_1
    9a2203ca4d1f        farmmealplanner_recipes      "java -Djava.securit…"   2 weeks ago         Up 26 hours         8080/tcp                 farmmealplanner_recipes_1
    aae136f37e2f        redis                        "docker-entrypoint.s…"   2 weeks ago         Up 26 hours         0.0.0.0:6379->6379/tcp   farmmealplanner_redis_1
    0224e73c6ef9        farmmealplanner_main         "java -Djava.securit…"   2 weeks ago         Up 26 hours         8080/tcp                 farmmealplanner_main_1

Navigating to <code>http://localhost</code> brings up the main page. In the annotated image below the content of the browser window comes from three applications running independently from each other in containers. I have marked them up in the image. Red is the navigation UI coming from the navigation application, green is from the recipe application and the rest is from the main application.

{% include image.html name="sub_applications.jpg" %}

## Integrating the navigation bar
For simplicity reasons I'm using the Thymeleaf template engine to work with HTML fragements and files to produce the user interface. The main page has a DIV element at the very top and then a SCRIPT block at the bottom.

    <body>
      <div id="navigation"></div>
      ...
      <script th:include="navigation/topmenu :: topmenu"></script>
    </body>

The SCRIPT block intents to load the actual navigation bar as a subelement to the DIV with id navigation. If that fails, a static - or hardcoded - version is put there instead.

    <script th:fragment="topmenu">
      $(document).ready(function() {
        $('#navigation').load('/navigation/ #navbar', function(responseText, status){
          if (status !== 'success') {
            $('#navigation').html('<div id="navbar" class="landing_header"><a href="./"><img src="http://placehold.it/200x45"/></a><a href="./" class="landing_menu_item">Home</a></div>');
          }
        });
    
      });
    </script>

That is now an important concept. Let me stay at the topic for while.

The above uses the user's web browser to integrate the user interface of two separate applications that have independent development and deployment lifecycles. There is a dependency between the main and the navigation application and the dependency can disappear unexpectedly. Somehow the container with the navigation application can stop working. This form of loose coupling creates new problems.

The solution above is to expect failure and be prepared to offer a replacement for the failed component. **Instead of designing for reliability I design for replaceability.** There is a small timeout period when trying to load the menubar from the other application but once it failed to load the replacement menubar looks like this:

{% include image.html name="nav_failure.png" %}

At the moment I've kept it very simple in order to focus on other things. Later on I intent to have a replacement that allows the user to do essential operations.

## Replace running container
When I want to replace one of the applications during development I simple run <code>mvn install</code> and later use the <code>localrun.sh</code> script:

    22:08 sns ~/dev/farm/farm_meal-planner  (master)$ ./localrun.sh replace recipes
    Building recipes
    Step 1/5 : FROM openjdk:jdk-alpine
     ---> 3642e636096d
    Step 2/5 : MAINTAINER sns@caimito.net
     ---> Using cache
     ---> d2d0bcb7f3bc
    Step 3/5 : COPY target/recipes-*.jar /opt/app.jar
     ---> 69efffa29717
    Step 4/5 : EXPOSE 8080
     ---> Running in d512abce4ceb
    Removing intermediate container d512abce4ceb
     ---> 28f68d399f0c
    Step 5/5 : ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/opt/app.jar"]
     ---> Running in a3bf89ffc388
    Removing intermediate container a3bf89ffc388
     ---> 85bfeeba927d
    Successfully built 85bfeeba927d
    Successfully tagged farmmealplanner_recipes:latest
    Recreating farmmealplanner_recipes_1 ... done

The result is that the running container gets replaced with the freshly build one.

{% include series-footer.html seriesTag = "farm-it" %}
