---
layout: post
title: Coverage != testing
tags:
- Software-Development
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>This morning I stumpled upon this:</p>

<blockquote><a href="http://tech.puredanger.com">Alex Miller</a> in <a href="http://tech.puredanger.com/2007/11/14/coverage-testing/#comments">Coverage != testing</a>:<br>
Testing verifies your code, coverage verifies your testing, but you can&rsquo;t say that coverage tests your code.
</blockquote>

<p>That's just so true. It's a good idea to start a new class with a unit test where you can model it and show how to use it. After all the test is where you first use the new code. And a unit test makes great documentation as well. It's likely that you will gain 100% coverage from the unit test. But you have not really tested yet. The missing piece is the integration with other parts of your system.</p>

<p>In my opinion it's a good idea to have a team member wearing the QA hat. That's the person who should be vigilantly checking whether there are enough integration tests that really take on edge cases and correctly simulate user behavior or other forms of input.</p>
