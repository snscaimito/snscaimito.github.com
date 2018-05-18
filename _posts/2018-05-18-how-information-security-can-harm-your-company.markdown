---
layout: post
title: How Information Security can harm your company
tags:
- en
categories:
- management
---
In my coaching practice I encounter a recurring pattern. Employees in large companies have no access to the Internet at all or limited access. Some ten years ago the reasoning behind restricting Internet access for employees used to be mostly driven by mistrust as management wanted to prevent people from doing personal business on company time. Today the reasoning has shifted and it is now driven by fear of leaking confidential information, being attacked over the Internet or to protect customer data. What seems to have stayed is the opinion that employees don't need all the things available on the Internet to perform their jobs and thus restricting access is a good idea.

My goal with this article is to provide some food for thought. I don't intend to provide instructions, neither do I pretend to be an expert in the field of network or information security. It certainly is helpful to contract with those when designing a secure network.

Back to the situation I frequently encounter. I usually get called in in order to introduce new development practices and thus I'm the guy who talks about a lot of new things the corporate employees of my client don't have available. As today much of that is available as FOSS (Free and Open Source Software) I just point them to a place from where to download a tool or a library and .... booom! they can't get to it. Or we want to use an online collaboration tool and they are denied access.

It may be something as innocent as installing Ruby and then trying to run <code>gem install cucumber</code> to create a quick demo of Acceptance Test-Driven Development. What is supposed to be a quick thing of maybe an hour to download, install and use it during a learning session, frequently turns out to be big issue with lots of waiting - in some cases days.

Most corporate software developers have Windows workstations. Even if they can download something they don't have rights to install software on their workstations or are somehow limited in how they can configure the computer they are working on.

To the regular office worker those limitations don't have any effect. Access to the Internet to them means they can open a web browser and **read** what is available on some websites. They don't demand access to discussion forums, Twitter or similar places. It's clear to them that they are supposed to work for the company and for everything else they use their smartphone.

System and network administrators also are not affected by those limitations as they can usually get to everything. However, their job is also to protect the internal network and corporate data. That is where we then frequently have a conflict of interest. Understandably they become uncomfortable when software developers ask for things that seemingly go against established policies and may put the system administrators at risk.

In many corporations I've visited a one-size-fits-all approach is used. The thinking seems to be that access to the Internet should be restricted and the internal network needs to be protected from the Internet and then the internal network can be considered safe and secure to work in and store corporate data. It then happens that sensitive information floats around the internal network essentially unprotected and every employee has or can have unrestricted access to it. This is like reinforcing the front door of your house while at the same time leave the backdoor unlocked hoping that nobody will walk around and find it.

## Proxy servers
The preferred tool to limit Internet access is the proxy server. Instead of allowing a direct connection of a web browser running on a personal workstation through the corporate firewall to any webserver out on the Internet the connection goes to a proxy server which then will fetch the content from the outside. In most cases the proxy server is combined with a mechanism to scan for viruses and to filter out unwanted content.

*Unwanted* content could be something as useful as Trello or Slack for collaboration and even websites like GitHub are frequently blocked. They all fall into the feared category of information sharing places. Depending on cultural preferences companies also try to protect their employees from porn or gambling websites or other types of information that is deemed inappropriate.

Since the early days of proxy servers and firewalls web browsers could be automatically configured to use a proxy server. For other tools one has to set an environment variable like __http_proxy__ and specify the proxy server hostname and port. The first real violation of very basic information security rules happens right here: if the proxy server itself requires authentication, employees have to provide their username and password in the clear such as:

    http_proxy=http://username:password@10.203.0.1:5187/

Combine that with a policy to change your login password every n days you've not only have a violation of rules but also created a real pain for the employee. It's simply a mindless implementation of an idea that seems good on the surface.

Now we can take that a step further:

Most tools software developers use support a way to specify a proxy server and also allow you to list destinations for which a proxy should not be used. It becomes a nightmare when a developer encounters a situation when tools have conflicting views on the topic or is simply no way to get the right proxy configuration into a virtual machine that is frequently recreated by different people. A common workaround is then to use a so-called technical account but that's just a bandaid for continuing a bad solution for a bit longer.

## Proxy servers were created to save bandwidth
As I'm old enough to speak about the early days of the Internet with narrow bandwidth connection I really should mention what proxy servers like Squid were really created for. Back then a 64 kbit/s connection to the Internet for a whole company was a big thing. Streaming video was unthinkable. In that situation it made a lot of sense to cache the content from frequently visited websites and thus speed up the use of the Internet. The intent was caching not security and much less content filtering.

## Does a proxy server really solve the problem?
First, I suggest we look at the problem to be solved.

The problem is three-fold. 

* We want to protect data that belongs to customers
* We want to protect company information from leaking out
* We want to protect systems from harm as being done by eg. viruses

If the **only** need were web browsing - as in passive reading -, a proxy could solve the problem. However, the times of that use of the Internet are long gone.

Software development is a highly collaborative activity and collaboration is not restricted to company employees only. Information exchange is the norm not the rare case that can be monitored and controlled.

So we probably should look at what we really want to protect and design a method for the case at hand instead of trying to use a catch-all method that is likely to have unintended side effects.

## Protect customer data
Today a good place to look for guidelines about how to properly protect customer data is the European Union's regulation on data protection:

<blockquote>
	<p>The GDPR refers to pseudonymisation as a process that is required when data are stored (as an alternative to the other option of complete data anonymization) to transform personal data in such a way that the resulting data cannot be attributed to a specific data subject without the use of additional information. An example is encryption, which renders the original data unintelligible and the process cannot be reversed without access to the correct decryption key. The GDPR requires for the additional information (such as the decryption key) to be kept separately from the pseudonymised data.</p>
	<footer>
		- <cite><a href="https://en.wikipedia.org/wiki/General_Data_Protection_Regulation#Pseudonymisation">European Union General Data Protection Regulation</a></cite>
	</footer>
</blockquote>

Customer data should be encrypted and only who needs to read the data should be able to decrypt it. There is no reason to keep the data in the clear at all.

The following picture shows a network layout to support this:

{% include image.html name="encrypted-data-in-dmz.png" caption="Encyrpted customer data that is protected against outside and inside attackers" %}

Once the data is encrypted the severity of unautorized access is greatly reduced. Who does not have the key can't use it. Yes, I know with enough time and effort encryption can probably be cracked. But the point is that the risk of exposure has been greatly reduced and when the risk is very low there is no point to go to extremes trying to prevent a potentially negative event.

Obviously the keys to decrypt the data need to be well protected. That is the keys, not gigabytes of data.

For this kind of application we have an access control mechanism. The secret information (password) to gain access can be used to decrypt a key, which then can be used to encrypt and decrypt the information belonging to that particular user. So in the end only the user can access the information. To everybody else the information continues to be illegible data junk.

## Protect company information
Given that customer data is already protected by encryption what is left to protect is what we can call trade secrets. That is information you don't want your competitors in the market to have. It may be knowledge about an ongoing development of a new product or it may be a recipe for something.

To protect company information your most important line of defense is the loyalty of all the employees working with that knowledge. A disgruntled employee may deliberately disclose it. A competitor may approach your employees and poach them away in order to obtain their knowledge. And even if people don't tell outright your secrets, they may still use their knowledge and skills when they are now working for the competition.

So the most sensible way to protect company information is to give the employees no reason to become disloyal so that they don't want to share the secrets or leave and take the secrets with them. You can't erase knowledge from people's brains and even contract clauses to prohibit the use of knowledge or to prevent the person leaving from working for a direct competitor are frequently disputed or circumvented.

Secrets are best kept under wrap by limiting their exposure. The less people have to work with something confidential, the lower the probability of voluntary or unvoluntary disclosure.

No firewall, no restricted Internet access will prevent a committed person from disclosing information. I've worked for companies with very restrictive policies on multiple levels. It seems to be good idea to declare buildings a red security zone where cellphones are not allowed and people are searched when going in and out. Still somehow information leaks out from those companies.

However, for most companies there isn't really a trade secret to protect. It's more about protecting customer data or compliance with regulatory requirements. If you happen to have a real secret, then you are on a different playing field and should design a secure work environment by employing specialists. Military security comes to mind.

## Protect systems from malware and network attacks
Whenever you want to protect something it is helpful to first do some risk assessment. That's even more important when 100% protection cannot be achieved other than not having the thing you want to protect. Industries like aviation have a lot of experience with that topic. As an instrument rated pilot myself I can tell that I expect failure of some kind when I perform a flight in bad weather. I don't cancel the flight because of a few clouds or the likelihood of thunderstorms. I do assess the risk and prepare plans to mitigate the risk. If the weather deteriorates, I can reroute or even land elsewhere. If an onboard system fails, I can continue the flight using a backup system or perform a safety landing. That's why key systems are redundant. That is also called the [Swiss Cheese Model](https://en.wikipedia.org/wiki/Swiss_cheese_model).

We can apply the Swiss Cheese Model to networks and software systems.

Let's assume we have a simple firewall at the frontdoor of our network. It's policies allow all network traffic from the inside to the outside (that means open access to the Internet) and we are using NAT (Network Address Translation). That firewall with NAT is our first line of defence or the first slice of Swiss Cheese. Yes, it does have holes but still there is no direct way to establish a connection from the outside to a system on the inside. 

{% include image.html name="basic-dmz-network.png" caption="Simple network with DMZ" %}

Indirectly something on the inside can establish a connection to the outside and then transfer data. For that case we need to have another slice of Swiss Cheese and make sure the holes in the slices do not align for a problem to come through. We may use an operating system that is less vulnerable to attacks and malware. Unix based systems like Linux or Apple's OS X have a reputation to be better protected than regular Microsoft Windows. We can also use a firewall directly on the system we want to protect and deny that system a lot of communication channels. Or we can create a subnet that is protected by another firewall with more restrictive rules.

{% include image.html name="special-networks.png" caption="Network with compartments" %}

What exactly we do should be designed based on the threat we want to defend against and we need to take into account the defensive capabilities of the devices and systems we use. The other angle, an important one, is the potential damage caused by a successful attack or the consequences in terms of interruptions caused by a malware infection.

There is another example from other industries we can draw from. Ships and submarines are designed in such a way that a breach in the hull does not lead immediately to fatal failure. The boat will not sink just so. The designers of boats achieve that by compartmentalising risk. If there is a hull breach, a heavy door closes quickly and seals in the breach. Now you may have a compartment full of water - and weight - but the risk of the ship is intact and likely will continue to float.

For a network that means we also have to create such compartments and expect the networks to become compromised. Then we make sure that vital information and systems we need to operate the business are not placed together in the same network - the compartment that might get flooded - and thus we have created another slice of Swiss Cheese.

Good protection is rarely convenient. Good security measures don't assume a lot of trust and make it time-consuming to pass. That is by design as one element of good security is to slow down a potential attacker in order to be able to detect an attack while in progress. In the physical world security is layered so that it takes time to break down barrier after barrier. In a network a firewall may not simply reject a connection attempt but swallow TCP packets and thus create delays that slow down attack tools.

## Use an air gap to protect even further
If you really have some very sensitive information to protect that information should simply not be on any network that is connected to anything. You may even have to go so far to consider the radio emissions from network cabling and the computer system itself.

Here is a simple presentation of how a higher level of security could be achieved:

{% include image.html name="airgap.png" caption="Data transfer over an air gap" %}

Instead of connecting the network with the sensitive data and vulnerable systems to another network we make use of an air gap. To bridge it we can use a one-time medium like a DVD or an USB stick. In case of USB sticks I would purchase them randomly from different sources that are not likely to be linked to my organization as a regular supplier. That adds another layer of protection against someone trying to provide me with USB sticks that are prepared with some malware. I would further use any medium only once and in only on direction of data transfer.

Obviously the use of an air gap is not suitable for any kind of online application. But then if the data is no sensible it probably does not belong there anyway or at least not in raw form.

Another reason for using an air gap might be to protect data from being altered by unauthorized people. Maybe it's a system of record that should be protected from malware that an attacker can use to alter data.

An air gap in combination with other security measures, like virus scanners and other inspections, with an audit trail, data validation, etc. can greatly improve the protection.
