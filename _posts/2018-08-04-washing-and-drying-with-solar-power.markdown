---
layout: post
title: Washing and drying with solar power
tags:
- en
- house
categories:
- farm-life
- spain
---
We've had [the solar system for a little while](/2018/07/19/solar-power-for-the-house.html) but it was too small for anything more serious than to power our refrigerator. A few days I was able to buy four more 330W panels locally and take them to the farm. 

I made a simple wooden support structure to replace the single wood piece that was holding up the panels before.

{% include image.html name="solar-2.jpg" %}

Then I placed all six panels onto the structure and checked the inclination. It's supposed to be 22 degrees in our area during summer. For winter we will have to lift them up to 57 degrees. I have to invent something for that or we'll have a permanent place for the panels by then.

{% include image.html name="solar-3.jpg" %}

Ivan, the electrician we are working with, helped me to wire up all six panels in parallel in two groups so that we have 1980W output with 24V system voltage.

{% include image.html name="solar-4.jpg" %}

Two connector boxes were screwed into the support structure underneath the panels.

{% include image.html name="solar-1.jpg" %}

Here are the technical specs for our small system. With six panels we are at the maximum system size. The limiting factor is the maximum current of 50A.

{% include image.html name="solar-5.jpg" %}

Our batteries were almost depleted when we finished the installation of the new panels. At 22.5V we will soon here a warning beep and without charging the system will power itself off shortly after starting to beep.

{% include image.html name="solar-6.jpg" %}

We then flipped the switch and the panels started delivering power. In the beginning there were 36V coming from the panels. When the current rose the voltage dropped. Eventually it settled at 23V and 47A of current. Unfortunately our system came preassembled and the manufacturer wanted to make it safe for non-electricians and put in a 20A fuse between the solar panels and the rest of the system. After a while the fuse popped and we had to remove that part and wire the panels directly into the system. According to our electrician that is what one is supposed to do anyway as the charge controller has a current limiter built into it - it's the whole idea after all.

{% capture imagePath %}{{ page.date | date: "%Y-%m-%d" }}-{{ page.title | slugify }}{% endcapture %}
<div style="margin-left: auto; margin-right: auto; width: 740px; display: grid; grid-auto-columns: 360px; grid-auto-flow: column ; grid-column-gap: 20px">
  <img src="/img/posts/{{ imagePath }}/solar-8.jpg" />
  <img src="/img/posts/{{ imagePath }}/solar-7.jpg" />
</div>

The next day I was then able to perform the ultimate test. Can we wash and dry clothers with purely solar power and still have energy for the night in the batteries?

{% include image.html name="solar-9.jpg" %}

Well... Yes, we can! The above picture shows the system status after washing for about two hours. At the time of the picture being taken the dryer was running. Voltage in the batteries had dropped to 23.3V and the dryer is drawing 2001W from the system. There was also the fridge connected but that load is just 50W.

Interesting to note is also the bypass. In the display there are two lines above the little battery symbol. One goes straight from the charge controller (left) to the inverter (right). The system sends the power straight to the inverter's output and only uses the remaining power to charge the batteries.

At the moment it appears that we can indeed start the washer for it's run of three hours, then switch to drying for two hours and end up with fully charged batteries for the night.

A few people have asked me about the price for this system. It was roughly 1.800 € for the kit that came with two 330W panels and two 250Ah batteries. The additional four panels were about 700 € which brings it to 2.500 € total.

Our future plans for solar power go beyond that. In several steps we want to build our own "power station" and then use high voltage to bring the power where it's needed. That will certainly be the house but also a workshop and other places. As we are in a place with about 300 days of sunshine we don't really want to store a lot of energy in batteries but instead have a lot of power generated for direct use during the day.
