---
layout: special
date: 2012-12-15
title: VFR vs. IFR flying
---
There are two sets of rules for flying any aircraft: VFR and IFR. VFR stands for _Visual Flight Rules_ and IFR means _Instrument Flight Rules_. Depending on the weather conditions a pilot may opt for one set of rules or the other. There are a number of other factors that influence the decision but for simplicity's sake it's the weather that make you fly VFR or IFR.

## VFR - See and avoid
In order to fly VFR _Visual Meteorological Conditions_ (VMC) have to be maintained. Basically it means you cannot fly through clouds and need to keep a safe distance. In some types of airspace you also have to see the ground. As under VFR you are responsible for seeing other aircraft and avoid a collision there is also a minimum horizontal visibility. Depending on the altitude you are flying in that is between 5 km and 8 km.

> In some countries, including Germany, airspace G allows for a visiblity of just 1.5 km. Plus you have to be able to see the ground. Under special permit is also possible to apply the same minima when flying within controlled airspace at an airport.

Many countries also allow __VFR flights at night__ but some European countries like Spain do not. In Germany VFR night is permitted.

### Some write-ups about my own VFR flights
<div>
	<ul style="list-style-type: none">
{% for post in site.tags.vfr limit %}
	<li>{{ post.date | date: "%d %b %Y" }} <a href="{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}
	</ul>
</div>


### Go from origin to destination in a straight line
Flying under VFR allows the pilot to choose any flight path as he likes. That may very well be a simple straight line between origin and destination. In fact the [comparisons of travel time](comparing-trips.html) I did are based on going direct.

## IFR - It used to be called blind flying
Whenever VMC (see above) cannot be met a pilot with the proper skills, rating and an IFR equipped aircraft can still perform a flight. In theory flights can be performed with zero visibility from start to landing. That of course sounds quite scary and certainly puts the flight crew under a lot of stress - which is why larger aircraft for commercial service are not flown by a single pilot.

IFR is the way to go at night also when the country you want to fly in or through does not allow VFR at night.

### Flying IFR is not always the shortest route between two points
Unlike VFR flights IFR happens usually within controlled airspace and requires filing a flight plan (usually) ahead of time. The routing is not completely at the pilot's discretion. Established waypoints and airways have to be used and the altitude for the flight is determined by things like minimum airway altitude, minimum radar vectoring altitude (MRVA) and traffic situation.

In Europe all IFR flight plans have to go through the [Central Flow Management Unit (CFMU)](https://www.public.cfmu.eurocontrol.int) by Eurocontrol. There are many tales available on several websites that talk about how inefficient routings sometimes get. On the other hand in trip reports IFR pilots report frequently that ATC all across Europe works hard to offer "directs" as much as possible thus allowing the pilot to shorten the distance to be flown. The bad thing is that ahead of the time the flight takes place these shortcuts cannot be known and therefore all other calculations, including the amount of fuel required, need to be made based on the routing as accepted by CFMU.

### Some write-ups about my own IFR flights
<div>
	<ul style="list-style-type: none">
{% for post in site.tags.ifr limit %}
	<li>{{ post.date | date: "%d %b %Y" }} <a href="{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}
	</ul>
</div>


## To make the trip or cancel it
Weather is the primary factor that causes a flight to be canceled at the last minute. If at the origin or the destination the weather conditions are not good enough to perform a safe flight, the pilot will decide to not go.
