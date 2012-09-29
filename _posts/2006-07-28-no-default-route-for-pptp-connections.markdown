---
layout: post
title: No default route for PPTP connections
tags:
- Miscellaneous
status: publish
type: post
published: true
meta: {}
---
<p>Ever wondered how you can avoid Mac OS X' PPTP client to set the default route to the remote gateway? It's a bit annoying that you loose your Internet access, if you connect to PPTP server that doesn't allow your packets through to the Internet.</p>

<p><a href="http://blog.bitflux.ch/archive/2006/01/07/changing-default-routes-on-os-x-on-vpn.html">Bitflux</a> has a good description about how to tell OS X' PPTP client not to change your default route. In short:</p>

<p>Create the directory <code>/etc/ppp/peers</code>, if it doesn't already exist. Then place a file with the exact name of your PPTP connection in there. Write <code>nodefaultroute</code> to that file and when you fire up your PPTP connection your default route will stay untouched.</p>

