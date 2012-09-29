---
layout: post
title: iSCSI support in Linux
tags:
- Miscellaneous
status: publish
type: post
published: true
meta:
  _wpas_done_twitter: '1'
  _edit_last: '6384953'
---
<p><a href="http://linux-iscsi.sourceforge.net/">Linux iSCSI</a> by Cisco joined forces with <a href="http://www.open-iscsi.org/">Open iSCSI</a>. The result is code to be compiled against kernel 2.6.16 or newer. </p>

<p>Yesterday I successfully installed Ubuntu Edgy and upgraded to a kernel 2.6.17 compiled over night from source retrieved via git from the Ubuntu repository. The first boot with the freshly compiled kernel went well so I proceeded to download Open iSCSI from their Subversion repository and compiled it against the 2.6.17 kernel. After completing the configuration of the NetApp FAS 250 filer I could connect to it, map the LUN as /dev/sdb, run fdisk and mkfs and mount the new file system.</p>

<p>Actually it was easier than I expected it to be. Today I'll be working on support for an iSCSI based root file system.</p>

