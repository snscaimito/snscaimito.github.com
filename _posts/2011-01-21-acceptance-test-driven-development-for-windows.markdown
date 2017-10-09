---
layout: post
title: Acceptance Test Driven Development for Windows
tags:
- en
categories:
- software-development
- atdd
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
  jabber_published: '1295657568'
  _wpas_done_twitter: '1'
  reddit: a:2:{s:5:"count";s:1:"0";s:4:"time";s:10:"1299658822";}
---
Software Development driven by tests (TDD) is considered a very good practice to write quality code without technical defects. TDD works well for programmers. It helps to design and test the building blocks of any software system.

Still, despite all the efforts of programmers to write correct code, defects are found during QA testing. If that happens programmers have to go back and fix these things which will hurt the team's velocity.

Another problem is that TDD alone does not ensure that the team is building the right solution. The requirements may miss important information and it is no surprise that these gaps are discovered once the customer sees the software in action for the first time.

Acceptance Test-Driven Development is a technique related to Behavior-Driven Development that can be very helpful in solving this problem. In this post I don't want to elaborate deeper on what ATDD is. I have written about this <a href="/2010/10/17/cucumber-when-programmers-have-a-dream.html">myself lately</a> after I had great success with it on a client project and Cheezy also has a very good description of how <a href="http://www.cheezyworld.com/2010/12/26/a-day-of-acceptance-testing/">a day in the life of an acceptance tester</a> looks like.

Instead I want to talk about a tool that programmers and testers can use for doing ATDD to develop Windows desktop applications.

For web applications one can use <a href="http://seleniumhq.org/">Selenium</a> or <a href="http://watir.com/">Watir</a> to remotely control the browser so it types text, clicks on something or figures out what is displayed. Both come with a Ruby API that makes it easy to use them in <a href="http://cukes.info/">Cucumber</a> step definitions. Ruby is a simple enough language that testers without programming background can quickly learn and at the same time Ruby allows to program all kinds of other things. For a tester that makes learning Ruby far more interesting than to learn some vendor specific scripting language. Further there are many libraries for all kinds of things out there that allows the more advanced tester to handle test data, fake external systems and whatever you can imagine.

What has not been available so far was something that would allow testers to use <a href="http://cukes.info/">Cucumber</a> on Windows desktop applications.

In December 2010 Jarmo Pertman announced RAutomation in a <a href="http://www.itreallymatters.net/post/2352350743/automating-windows-and-their-controls-with-ruby">blog post</a> and on the <a href="http://www.mail-archive.com/watir-general@googlegroups.com/msg12259.html">Watir mailinglist</a>. RAutomation is a Ruby library that allows you to automate Windows desktop application using an API very close to Watir for web applications.

Around the same time a client was looking for a tool for the same purpose and I was doing some experiments to research the topic. I wrote a simple <a href="http://cukes.info/">Cucumber</a> feature to test Windows' Notepad application. From my step definitions in Ruby I called some objects that in turn used the <a href="https://github.com/ffi/ffi">FFI</a> library to call Win32 C functions to retrieve information about Windows controls, send keystrokes or click on things.

After we learned about RAutomation it was decided to collaborate with Jarmo on his library and I forked RAutomation on GitHub. Since then I created a sample application in C# and extended RAutomation's API to support checkboxes, radio buttons and comboboxes. There will be support for list views (tables) soon as well.

During that work I made an interesting discovery. My sample application in C# is using Windows Forms via the Windows Presentation Framework. Once I tried to send the BM_GETSTATE message to one of the checkboxes to learn whether it was ticked or not I got no response. The return code from SendMessage was always 0 which either means that the box is not ticked or there was an error. Great! So which one is it? Some research revealed that the buttons in my application were not regular buttons but instead controls drawn by the Windows Forms framework and because of that they do not respond to the usual Win32 messages.

So I ended up using Microsoft Active Accessibility which offers a COM interface that one can use to get to the state of a checkbox and other buttons.

Unfortunately using the IAccessible COM interface from Ruby was difficult. I am using Ruby <a href="https://github.com/ffi/ffi">FFI</a> to call the Windows API. <a href="https://github.com/ffi/ffi">FFI</a> allows me to build C structs and unions, work with function pointers etc. The challenge was that one of the IAccessible methods (get_accState) expects a VARIANT data type to be passed by value and it also wants a pointer to a VARIANT as its output parameter.

VARIANT is a very common data type used in many places of the Windows API. It is used to pass a number, a string, an interface pointer and many other things to functions or to receive those things. It is a C union that has simple members, structs and other unions inside. In C/C++ the compiler will make sure that the right amount of memory gets allocated but how to model this in Ruby using <a href="https://github.com/ffi/ffi">FFI</a>? I'm sure that <a href="https://github.com/ffi/ffi">FFI</a> can do it as there are FFI::Struct and FFI::Union but VARIANT is a huge thing and all you get is a segmentation fault, if you are just one byte off :-(

So in the end I wrote a DLL in C++ that exports a C function which I can call from Ruby via <a href="https://github.com/ffi/ffi">FFI</a>. That keeps the VARIANT stuff to the right language and from Ruby I only have to deal with simple data types that are easy to handle.

I'd like to thank Jarmo for the work he has done on RAutomation and hope that he will pull in my extensions after I cleaned up my fork a bit.

My fork is on GitHub at <a href="https://github.com/snscaimito/RAutomation">https://github.com/snscaimito/RAutomation</a>
