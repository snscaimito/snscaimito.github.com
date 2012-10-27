---
layout: post
title: iSCSI support in Linux
tags:
- en
- Miscellaneous
status: publish
type: post
published: true
meta:
  _wpas_done_twitter: '1'
  _edit_last: '6384953'
---
<p>iSCSI support amongst the different Linux distributions is currently a bit uneven.</p>

<p>There are two projects: linux-iscsi on sourceforge which was sponsered by Cisco and Open iSCSI which started independently and now has merged with linux-iscsi. linux-iscsi 4.x is for kernels up to 2.6.10 while Open iSCSI (that is linux-iscsi 5.x) is for kernels from 2.6.16 and newer. As the iSCSI stuff is a driver, it is highly depended on the kernel version.</p>

<p>The recently released Ubuntu Dapper 6.06 does not include it. But one can build a 2.6.17 kernel and use the Open iSCSI sources from Subversion and get a working system. I've tried it and it works well.</p>

<p>Fedora Core 5 has a modified linux-iscsi implementation working with kernel 2.6.15. I've tried it and it works well.</p>

<p>There is another project on sourceforge called iscsi-init which provides support for a root filesystem on iSCSI. This is what one needs in order to have diskless servers booting from the network.</p>

<p>Unfortunately iscsi-init relies on linux-iscsi 4.x for the 2.6.10 kernel and it looks like a stalled project. Open iSCSI does not yet support 'root filesystem' support and has not yet released something they want to label as stable.</p>
