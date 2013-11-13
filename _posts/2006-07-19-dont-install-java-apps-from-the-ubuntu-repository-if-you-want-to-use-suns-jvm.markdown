---
layout: post
title: Don't install Java apps from the Ubuntu repository, if you want to use Sun's
  JVM
tags:
- en
categories:
- software-development
status: publish
type: post
published: true
meta:
  _wpas_done_twitter: '1'
  _edit_last: '6384953'
---
<p>Now that Ubuntu Dapper supports <a href="http://blog.stephan-schwab.com/2006/07/18/sun-java-vm-on-ubuntu-linux/">Sun's JVM directly</a>, it would be nice to install things like Tomcat the same way. So let's try this:</p>

<pre class="codeSample">sns@testbed:/opt$ sudo apt-get install tomcat5
Reading package lists... Done
Building dependency tree... Done
The following extra packages will be installed:
  ant apache2-common apache2-utils fastjar gcj-4.1-base gij-4.1 java-gcj-compat libapr0
  libbcel-java libcommons-beanutils-java libcommons-collections-java
  libcommons-collections3-java libcommons-dbcp-java libcommons-digester-java libcommons-el-java
  libcommons-fileupload-java libcommons-launcher-java libcommons-logging-java
  libcommons-modeler-java libcommons-pool-java libexpat1 libgcj-common libgcj7 libgcj7-jar
  libgnucrypto-java libjaxp1.2-java libjessie-java liblog4j1.2-java libmx4j-java libpcre3
  libregexp-java libservlet2.3-java libservlet2.4-java libtomcat5-java libxerces2-java openssl
  ssl-cert
Suggested packages:
  ant-doc apache2-doc lynx www-browser gcj-4.1 libgcj7-awt libbcel-java-doc
  libcommons-beanutils-java-doc libcommons-collections-java-doc libcommons-collections3-java-doc
  lib32gcj7-dbg jython libxerces2-java-doc ca-certificates libapache-mod-jk libapache2-mod-jk
  tomcat5-webapps tomcat5-admin
Recommended packages:
  ant-optional ecj-bootstrap ecj java-compiler libgcj7-src
The following NEW packages will be installed:
  ant apache2-common apache2-utils fastjar gcj-4.1-base gij-4.1 java-gcj-compat libapr0
  libbcel-java libcommons-beanutils-java libcommons-collections-java
  libcommons-collections3-java libcommons-dbcp-java libcommons-digester-java libcommons-el-java
  libcommons-fileupload-java libcommons-launcher-java libcommons-logging-java
  libcommons-modeler-java libcommons-pool-java libexpat1 libgcj-common libgcj7 libgcj7-jar
  libgnucrypto-java libjaxp1.2-java libjessie-java liblog4j1.2-java libmx4j-java libpcre3
  libregexp-java libservlet2.3-java libservlet2.4-java libtomcat5-java libxerces2-java openssl
  ssl-cert tomcat5
0 upgraded, 38 newly installed, 0 to remove and 7 not upgraded.
Need to get 15.3MB/25.4MB of archives.
After unpacking 60.5MB of additional disk space will be used.
Do you want to continue [Y/n]? </pre>

<p>If you go ahead here, you will see this next:</p>

<pre class="codeSample">Adding system user `tomcat5'...
Adding new user `tomcat5' (104) with group `nogroup'.
Not creating home directory `/usr/share/tomcat5'.
Installing /var/lib/tomcat5/webapps/ROOT/WEB-INF/web.xml.
Installing /var/lib/tomcat5/conf/tomcat-users.xml.
Installing /var/lib/tomcat5/conf/jk2.properties
Could not start Tomcat 5 servlet engine because no Java Development Kit
(JDK) was found. Please download and install JDK 1.3 or higher and set
JAVA_HOME in /etc/default/tomcat5 to the JDK's installation directory.
</pre>

<p>And you will find that Sun's JVM is no longer in the PATH. Instead you will be using the GNU JVM. What you will find though is this:</p>

<pre class="codeSample">sns@testbed:/usr/share/java$ ls
ant-1.6.jar                    commons-fileupload-1.0.jar     jsse.jar
ant-bootstrap.jar              commons-fileupload.jar         libgcj-4.1.0.jar
ant.jar                        commons-launcher-1.1.jar       libgcj-4.1.jar
ant-launcher.jar               commons-launcher.jar           log4j-1.2.12.jar
bcel-5.1.jar                   commons-logging-1.0.4.jar      log4j-1.2.jar
bcel.jar                       commons-logging-api-1.0.4.jar  mx4j-2.1.1.jar
commons-beanutils-1.7.0.jar    commons-logging-api.jar        mx4j-impl-2.1.1.jar
commons-beanutils.jar          commons-logging.jar            mx4j-impl.jar
commons-collections-2.1.1.jar  commons-modeler-1.1.jar        mx4j.jar
commons-collections3-3.1.jar   commons-modeler.jar            mx4j-jmx-2.1.1.jar
commons-collections3.jar       commons-pool-1.2.jar           mx4j-jmx.jar
commons-collections.jar        commons-pool.jar               regexp-1.4.jar
commons-dbcp-1.2.1.jar         gnu-crypto.jar                 regexp.jar
commons-dbcp.jar               javax-crypto.jar               servlet-2.3.jar
commons-digester-1.7.jar       javax-security.jar             servlet-api-2.4.jar
commons-digester.jar           jaxp-1.2.jar                   servlet-api.jar
commons-el-1.0.jar             jsp-api-2.0.jar                xercesImpl.jar
commons-el.jar                 jsp-api.jar                    xmlParserAPIs.jar
</pre>

<p>In general that's not a bad idea to make Java applications and libraries be more tightly integrated into the operating system. But as long as the distribution sooner or later will change the JVM and install potentially unwanted code this is not usable in a production environment.</p>
