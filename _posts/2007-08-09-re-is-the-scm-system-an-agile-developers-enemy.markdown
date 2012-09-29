---
layout: post
title: ! 'Re: Is the SCM system an agile developers'' enemy?'
tags:
- Software-Development
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>A few days back I was lamenting <a href="/2007/07/27/1185561166773.html"><em>Is the SCM system an agile developers' enemy?</em></a>. A reader left a <a href="/2007/07/27/1185561166773.html#comment1185594067381">comment</a> to this post saying:</p>

<blockquote>...and in Subversion, you do not know who, if anybody, might also be working on the same file(s) as you, nor can you easily track changes across branches after merges. Both of these things are extremely useful to a huge class of projects, both 'Agile' and not, and Perforce is light years ahead of Subversion here. I agree with you that's Perforce's process of moving files around is annoyingly cumbersome.</blockquote>

<p>So the question basically is whether it's important to know who is editing a file before you can open it. I've used other SCMs before and I remember doing phone calls to other people in order to ask them to check in a specific file so that I can open it for editing.</p>

<p>My point is that software development is something different than working on configuration files or documents. In many cases I agree that it's a useful feature to let only one person at a time make changes. But to a software developer that's not entirely a good thing. Where is the problem that Joe is making chances to method foo() while Jim is doing something to method bar() that are both in the same file? That happens millions of times a day in every project and is completely normal. What's needed to deal with this is not a tool that limits changes, but a tool that makes merging easy.</p>

<p>Joe and Jim should be allowed to make changes all over the place with no restriction at all. That way they can work away and experiment with different designs, which allows them to find the best solution for the problem they are working on. When each of them is done and wants to share the new stuff with the rest of the team, they tell the SCM to compare their changes to the version of the files in the repository. The SCM should show a side by side view of their version of the file and the one stored in the repository. Now it's easy to decide what to move or where conflicts are. If there are conflicts those can be dealt with before the next merge attempt. Have a look at one of the major Java IDEs (IDEA, Eclipse, Netbeans) and you find exactly that kind of merge editor I just described.</p>

<p>Again, there is no need to prevent people from editing the same file in a software development team. Software development is a creative process and whatever limits or restricts creates a boundary for the creativity. The result of imposing limitations by using the wrong tools will be software that looks and feels just like the limitations its creators suffered from. Please read about <a href="http://moishelettvin.blogspot.com/2006/11/windows-shutdown-crapfest.html"><em>The Windows Shutdown crapfest</em></a> to see how such a thing can look like. It should open eyes.</p>
