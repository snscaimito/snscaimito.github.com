---
layout: post
title: ! 'Most common mistake: start Swing applications off the right thread'
tags:
- en
- Software-Development
status: publish
type: post
published: true
meta:
  _edit_last: '6384953'
---
<p>While reading <a href="http://java.sun.com/developer/technicalArticles/javase/swingworker/">Improve Application Performance With SwingWorker in Java SE 6</a> from the Sun Developer Network I found that I made the most common mistake in Swing programming myself as well.</p>

<p>All Java programs start with an initial thread out of the main() method. A lot of people - including myself - will create the application main window as a JFrame there in main() and show the UI. That's wrong!</p>

<p>The correct way is to use the Event Dispatch Thread (EDT) for all user interface related stuff. So creating the application main window outside of the EDT is wrong, because it might lead to thread synchronization problems later. The right way to do it is to use the invokeLater() method from SwingUtilities:</p>

<pre class="codeSample">public class MainFrame extends javax.swing.JFrame {
 
  public static void main(String[] args) {
    SwingUtilities.invokeLater(new Runnable() {
      public void run() {
        new MainFrame().setVisible(true);
      }
    });
  }
}
</pre>

<p>Doing so has another advantage. The call to invokeLater() returns immediately allowing your application to perform other initialization tasks without delay. If a wait is required, one can use invokeAndWait() instead.</p>
