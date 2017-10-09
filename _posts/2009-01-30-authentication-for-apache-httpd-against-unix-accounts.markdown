---
layout: post
title: Authentication for Apache httpd against Unix accounts
tags:
- en
categories:
- software-development
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>This morning I spent a little time to configure a new installation of Apache httpd to use authentication against Unix accounts. Why create a separate account database, if the users who should access content via httpd are the same that access the host via ssh? It seemed logical to use the same account database for both and that database is the shadow password system made accessible through PAM.</p>

<p>So I looked for the right module to use. There are two <a href="http://unixpapa.com/mod_auth_external.html">libapache2-mod-authnz-external</a> and libapache2-mod-auth-pam. Apparently the latter is no longer under development.</p>

<p>With the help of this very good <a href="http://blog.innerewut.de/2007/6/26/apache-2-2-authentication-with-mod_authnz_external">writeup</a> by <a href="http://blog.innerewut.de/">Jonathan Weiss</a> I had the authentication against shadow passwords working quickly.</p>

<p>Just as Jonathan I don't quite understand why the ability to authenticate against shadow password requires one to compile code and dissolve conflicts amongst modules manually. Is the wish to authenticate against shadow passwords so rare? Probably it is, as you don't want to do that for a publicly available server out on the Internet where the web users are not the same as the system users. For internal purposes it is quite handy though. The server for which I needed this will become a build server for a small development team.</p>
