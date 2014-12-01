---
layout: post
title: Aeronautical Decision Making (ADM) as a model for software developers
tags:
- en
- SDDM
categories:
- Management
---
In aviation decisions can make the difference between life and death. A single wrong decision can lead to the death of 300 people traveling on an aircraft and potentially impact many more on the ground. And even when it is not about big airliners but small personal aircraft the importance of correct decision making is not less important.

In software development mistakes can also lead to severe losses. There may not be fatalities, unless you are working on software that controls devices where defects may harm people, but nonetheless mistakes may lead to serious consequences. These consequences may be financial losses or even as fatal as bankruptcy for a company.

In this article I want to explore a bit what software developers and managers responsible for software development efforts can learn from aeronautical decision making. Aviation has a long history of putting safety first and pilots do their job in an environment that can be quite hostile and unpredictable - despite weather forecasts and technology getting better all the time.

## Expect not to land as intended
In software development there is usually an expectation to turn everything that a customer has asked for into a product feature and deliver it. In many companies not to deliver something is considered a failure. That is similar to the assumption by the general public that every flight with an aircraft will finish with a landing at the destination airport. However, that view is not shared by safety oriented minds in the aviation industry. To quote the [FAA (Federal Aviation Administration)](http://www.faa.gov/regulations_policies/handbooks_manuals/aviation/pilot_handbook/media/PHAK%20-%20Chapter%2017.pdf):

> Most pilots execute approaches with the expectation that they will land out of the approach every time. A healthier approach requires the pilot to assume that changing conditions [...] will cause the pilot to divert or execute the missed approach on every approach. This keeps the pilot alert to all manner of conditions that may increase risk and threaten the safe conduct of the flight.

When a pilot decides not to land that may lead to the decision to fly to an alternate airport and then land there instead. That is similar to not to deliver a certain feature but instead something else that is better suited for the purpose. Software teams should be open to that and modify their decision making accordingly.

## Managing complexity safely
Out of the many decision making models that can be used for aeronautical decision making the 3P model might be useful for decision making in software development as well. In the following table I have put the 3P steps next to the decision making process for the Complex domain from Dave Snowden's Cynefin model that is used to understand systems or situations.

<center>
<table style="text-align: center">
<tr>
	<th style="width: 15em">Aviation 3P</th>
	<th style="width: 15em">Complex, Cynefin</th>
</tr>
<tr>
	<td>Perceive</td>
	<td>Probe</td>
</tr>
<tr>
	<td>Process</td>
	<td>Sense</td>
</tr>
<tr>
	<td>Perform</td>
	<td>Respond</td>
</tr>
</table>
</center>

In aviation a pilot perceives a given set of circumstances for a flight, processes the information by evaluating their impact on the flight and performs by implementing the best course of action.

A flight begins with planning the flight. The pilot will use a number of sources to obtain information about the weather, about the status of the aircraft, about passengers and freight, the status of airports at the origin, along the route, destination and potential alternate airports in case a diversion will be required. Although the flight has not even started yet this is already an investigation and to call it probing is certainly justified. It may even take a couple of hours to do it.

When the flight begins the pilot will continue to probe. He uses information from a multitude of cockpit instruments showing him the status of aircraft systems, navigational information, weather RADAR, position of other aircrafts in the vicinity, etc.

After every probing the pilot will make sense of the information gathered and give a response by taking some action. The probing, sensing, responding never stops until the engine(s) have been shut down.

That matches pretty good with the process in a complex situation as per the Cynefin model.

Once an aircraft is in the air - similar to when you have started a software project - there is a lot of unpredictable things going on around it and even inside it. The weather enroute or at the destination can change dramatically over the duration of the flight, if it's not a beautiful day with blue sky for thousands of miles. There are other aircraft around and their pilots may not be on the same frequency and they may fly VFR, which basically means they can do whatever they want. Some problem may develop in an aircraft system due to fatigue, wear, pollution in the fuel or other vital liquid. And probably many other things.

Because of that the aviation industry has developed ways to deal with complexity and that is why I want to tell about it so that we as software developers and managers responsible for software development can learn something from it.

## The 3P decision making model
The [FAA (Federal Aviation Administration)](http://www.faa.gov/regulations_policies/handbooks_manuals/aviation/pilot_handbook/media/PHAK%20-%20Chapter%2017.pdf) describes the 3P decision making model as follows.

> In the first step [**perceive, probe**], the goal is to develop situational awareness by perceiving hazards, which are present events, objects, or circumstances that could contribute to an undesired future event. In this step, the pilot will systematically identify and list hazards associated with all aspects of the flight: pilot, aircraft, environment, and external pressures. It is important to consider how individual hazards might combine. Consider, for example, the hazard that arises when a new instrument pilot with no experience in actual instrument conditions wants to make a cross-country flight to an airport with low ceilings in order to attend an important business meeting.
> 
> In the second step [**process, sense (making)**], the goal is to process this information to determine whether the identified hazards constitute risk, which is defined as the future impact of a hazard that is not controlled or eliminated. The degree of risk posed by a given hazard can be measured in terms of exposure (number of people or resources affected), severity (extent of possible loss), and probability (the likelihood that a hazard will cause a loss). If the hazard is low ceilings, for example, the level of risk depends on a number of other factors, such as pilot training and experience, aircraft equipment and fuel capacity, and others.
> 
> In the third step [**perform, respond**], the goal is to perform by taking action to eliminate hazards or mitigate risk, and then continuously evaluate the outcome of this action. With the example of low ceilings at destination, for instance, the pilot can perform good ADM by selecting a suitable alternate, knowing where to find good weather, and carrying sufficient fuel to reach it. This course of action would mitigate the risk. The pilot also has the option to eliminate it entirely by waiting for better weather.

The FAA goes on to say:

> Once the pilot has completed the 3P decision process and selected a course of action, the process begins anew because now the set of circumstances brought about by the course of action requires analysis. The decision-making process is a continuous loop of perceiving, processing and performing.

Together with the 3P model to continuously understand the situation during the flight the TEAM and CARE models can be used to perform risk management and understand hazards.

## CARE to perceive hazards
The management of any risk depends on the type and magnitude of the hazard the risk stems from. CARE can be used to understand those potential hazards.

* Consequences
* Alternatives
* Reality
* External Factors

## TEAM to perform risk management
TEAM offers several choices to the pilot and can be used to manage the risk that results from a potential hazard as identified using CARE.

* Transfer the risk
* Eliminate the risk
* Accept the risk
* Mitigate the risk

For now I just want to tell about Aeronautical Decision Making (ADM). In another blog post I want to think about how 3P, CARE and TEAM can be used in software development.
