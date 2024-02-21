---
layout: post
title: Quite fast
tags:
- en
categories:
- panama
status: publish
type: post
published: true
meta: {}
---
<p>Since Friday the new <a href="/2006/08/15/fiber-optics-for-internet-access.html">2 mbps dedicated Internet access</a> is working now and the first experience is quite a pleasant one. It's fast, ping times from Panama to the US or to Europe are much shorter than over cable modem as before.</p>

<p>Here a traceroute to Tampa, Florida in the US:</p>

<pre class="codeSample">traceroute to www.caimito.net (207.150.163.124), 64 hops max, 40 byte packets
 1  192.168.10.1 (192.168.10.1)  1.768 ms  1.130 ms  1.019 ms
 2  host-200-115-165-209.optynex.com (200.115.165.209)  2.052 ms  2.037 ms  2.649 ms
 3  ge-2-1-0-501.ar1.pty1.gblx.net (208.51.117.169)  2.342 ms  2.996 ms  2.600 ms
 4  so1-0-0-2488m.ar2.tpa1.gblx.net (67.17.66.169)  74.603 ms  75.025 ms  74.205 ms
 5  lightspeed-ip-inc-triple-8.ge-3-0-0.ar2.tpa1.gblx.net (64.214.175.194)  74.942 ms  74.424 ms  74.435 ms
 6  gige3.ds03a.tpa.sagonet.net (65.110.32.70)  75.489 ms  75.522 ms  74.846 ms
 7  unknown.sagonet.net (207.150.163.124)  75.027 ms  75.679 ms  75.431 ms</pre>

<p>And to Germany:</p>

<pre class="codeSample">traceroute to www.heise.de (193.99.144.85), 64 hops max, 40 byte packets
 1  192.168.10.1 (192.168.10.1)  1.706 ms  1.038 ms  1.340 ms
 2  host-200-115-165-209.optynex.com (200.115.165.209)  2.248 ms  2.388 ms  2.286 ms
 3  ge-2-1-0-501.ar1.pty1.gblx.net (208.51.117.169)  2.352 ms  2.930 ms  2.640 ms
 4  so4-0-0-2488m.ar2.fra2.gblx.net (67.17.65.78)  152.354 ms  139.273 ms  140.302 ms
 5  plusline-ag-ip-services.ge-1-2-0.408.ar2.fra2.gblx.net (208.49.181.90)  159.152 ms  158.475 ms  158.795 ms
 6  heise2.f.de.plusline.net (213.83.46.196)  161.429 ms  162.020 ms  161.908 ms</pre>

<p>An interesting detail is this:</p>

![OptynexSwitch](/img/posts/OptynexSwitch.jpg)

<p><a href="http://www.optynex.com/">Optynex</a> has deployed a fiber optics network based on Ethernet throughout Panama City, Panama, and connects customers with a simple TX-FX converter and a managed switch on the customer premises. If you look closely at the picture, you will see that the 100 mbps LED on the switch is illuminated. So we actually have a 100 mbps connection to the other side and only get shaped down to 2 mbps. There is some room to grow ;-)</p>
