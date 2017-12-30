---
layout: post
title: A build and deployment pipeline with Maven, Docker and Jenkins
tags:
- en
categories:
- software-development
---
This is a little story about setting up a build and deployment pipeline for a small service. The service is written in Java, compiled and packaged with Maven and deployed in the form of a Docker container. The pipeline is implemented on Jenkins.

Unlike in a more traditional way I don't want to treat the Maven produced JAR file of the service as the potentially shippable artifact. It may or may not work depending on the environment it is deployed to. Instead I want to create a Docker container and ship that as a self-contained unit. All that is left then is to connect it to other units around it but no actual installation of software or configuration.

By "connect" I mean enabling it to do a DNS lookup for eg. the SQL server it requires. That should be a fairly simple and safe operation which is not likely to fail without a clear error message and an easy fix.

## Maven build to create the service JAR
My service requires a database. During development and when building the JAR file I use a MariaDB container that is started and shut down from Maven. Here is the relevant <code>build</code> section from my pom.xml.

    <build>
    <plugins>
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
      </plugin>
      <plugin>
        <groupId>io.fabric8</groupId>
        <artifactId>docker-maven-plugin</artifactId>
        <version>0.23.0</version>
        <configuration>
          <images>
            <image>
              <alias>db</alias>
              <name>it_ledger_database</name>
              <build>
                <from>mariadb:latest</from>
              </build>
              <run>
                <ports>
                  <port>3306:3306</port>
                </ports>
                <env>
                  <MYSQL_ROOT_PASSWORD>xxxx</MYSQL_ROOT_PASSWORD>
                  <MYSQL_DATABASE>ledger</MYSQL_DATABASE>
                </env>
                <log>
                  <date>default</date>
                  <color>MAGENTA</color>
                </log>
                <wait>
                  <log>.*mysqld: ready for connections.*</log>
                  <time>100000</time>
                </wait>
              </run>
            </image>
          </images>
        </configuration>
        <executions>
          <execution>
            <id>start</id>
            <phase>pre-integration-test</phase>
            <goals>
              <goal>build</goal>
              <goal>start</goal>
            </goals>
          </execution>
          <execution>
            <id>stop</id>
            <phase>post-integration-test</phase>
            <goals>
              <goal>stop</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-failsafe-plugin</artifactId>
        <executions>
          <execution>
            <goals>
              <goal>integration-test</goal>
              <goal>verify</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-surefire-plugin</artifactId>
        <configuration>
          <excludes>
            <exclude>**/IT*.java</exclude>
          </excludes>
        </configuration>
      </plugin>
    </plugins>
    </build>

## Build Pipeline
My project contains a Jenkinsfile that builds the artifact, then creates a Docker container and uses another Docker container to perform acceptance tests using Cucumber. If the Cucumber tests turn out good, the container with the deployment canditate gets uploaded to a container repository with tag *latest*.

    pipeline {
      agent any
    
      tools {
        maven 'mvn-3.5.2'
      }

      stages {
        stage('Build') {
          steps {
            sh 'mvn package'
          }
        }
        
        stage('Make Container') {
          steps {
          sh "docker build -t snscaimito/ledger-service:${env.BUILD_ID} ."
          sh "docker tag snscaimito/ledger-service:${env.BUILD_ID} snscaimito/ledger-service:latest"
          }
        }
        
        stage('Check Specification') {
          steps {
            sh "chmod o+w *"
            sh "docker-compose up --exit-code-from cucumber --build"
          }
        }
      }
    
      post {
        always {
          archive 'target/**/*.jar'
          junit 'target/**/*.xml'
          cucumber '**/*.json'
        }
        success {
          withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            sh "docker login -u ${USERNAME} -p ${PASSWORD}"
            sh "docker push snscaimito/ledger-service:${env.BUILD_ID}"
            sh "docker push snscaimito/ledger-service:latest"
          }
        }
      }
    }

My acceptance test or *executable specification* are implemented in Ruby Cucumber. The service exposes a RESTful API and with the rest-client gem it is easy to talk to it from the Cucumber step definitions.

In the post pipeline stage I archive the JAR file generated by the Maven build and save the JUnit and Cucumber reports so that I can look at them from the corresponding Jenkins build report.

The Cucumber test container is created with a Dockerfile containing:

    FROM ruby

    # Install Chrome, Xvfb and utility packages (libav for video capture), clean up
    RUN set -ex \
        && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
        && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" \
            >> /etc/apt/sources.list.d/google.list' \
        && apt-get update \
        && apt-get install -y google-chrome-stable unzip \
        && rm -rf /var/lib/apt/lists/*

    # Install Chromedriver
    RUN set -ex \
        && cd /tmp \
        && wget -Nv http://chromedriver.storage.googleapis.com/2.34/chromedriver_linux64.zip \
        && unzip chromedriver_linux64.zip \
        && chmod -v +x chromedriver \
        && mv -v chromedriver /usr/local/bin/ \
        && rm -v chromedriver_linux64.zip

    RUN groupadd -r cucumber && useradd -r -g cucumber -G audio,video cucumber \
        && mkdir -p /home/cucumber && chown -R cucumber:cucumber /home/cucumber

    USER cucumber

    COPY Gemfile /home/cucumber/Gemfile

    WORKDIR /home/cucumber
    RUN gem install bundler && bundle install

    CMD ["cucumber"]

The acceptance test is done by using docker-compose with this docker-compose.yml file:

    version: '3'
    services:
      ledger-service:
        image: snscaimito/ledger-service:latest
        ports:
         - "9080:8080"
        environment:
        - SPRING_PROFILES_ACTIVE=production
        links:
        - ledger_db
      ledger_db:
        image: mariadb:latest
        environment:
        - MYSQL_ROOT_PASSWORD=xxxxx
        - MYSQL_DATABASE=ledger
      cucumber:
        environment:
        - HOST=ledger-service
        - PORT=8080
        - MYSQL=ledger_db
        links:
        - ledger-service
        volumes:
        - ./:/home/cucumber
        build:
          context: ./
          dockerfile: Dockerfile-cucumber

Running docker-compose with the option *--exit-code-from* lets Jenkins know about the outcome of the tests. A non-zero exit code means failure.

## Deployment Pipeline
I created a project at GitHub which contains this Jenkinsfile:

    pipeline {
      agent any
  
      stages {
        stage("Pull") {
          steps {
            withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
              sh "ssh production.local docker login -u ${USERNAME} -p ${PASSWORD}"
              sh "ssh production.local docker pull snscaimito/ledger-service:latest"
            }
          }
        }
        stage("Run") {
          steps {
              sh "scp docker-compose.yml production.local:docker-compose.yml"
              sh "ssh production.local docker-compose up -d"
            }
        }
      }
    }

There is also the docker-compose.yml which gets copied over to the production.local virtual machine:

    version: '3'
    services:
      ledger-service:
        image: snscaimito/ledger-service:latest
        ports:
         - "9080:8080"
        environment:
        - SPRING_PROFILES_ACTIVE=production
        links:
        - ledger_db
      ledger_db:
        image: mariadb:latest
        environment:
        - MYSQL_ROOT_PASSWORD=xxxx
        - MYSQL_DATABASE=ledger

## How do I use it
As I travel around a lot and don't like to maintain a continuously running server somewhere on the Internet I have two virtual machines on my laptop. One is called <code>build.local</code> and the other is <code>production.local</code>. The first one runs Jenkins and the other one is my production system. This is mainly an experiment so it doesn't matter that "production" is just a local virtual machine. I can host it somewhere later and the setup still will be the same. So that is fine for now.

On my laptop I run Eclipse to edit my source files, then push to GitHub and trigger the Jenkins pipeline manually with the click of a button.

Once I want to update my production system I push another button and the deployment pipeline performs the work.
