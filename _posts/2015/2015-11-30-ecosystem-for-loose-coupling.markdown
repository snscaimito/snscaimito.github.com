---
layout: post
title: Ecosystem for loose coupling to avoid critical path project management
tags:
- en
categories:
- management
- business
- software_development
---
A lot of effort goes into large-scale software development. I believe too many non-software people try to solve the challenge on the wrong level. 

It is not a problem of better managing work items at all.

Instead, it is a question of tight coupling vs loose coupling and how systems are being set up and operated in a large enterprise. 

Ecosystems are complex systems where all entities within do stuff that influences or directly affects the stuff the other entities do or can do. Ecosystems are not ordered systems. There is nothing that controls behavior or direction of development. Everything that goes on is a reaction to what others do or have evolved into. Constant change is paramount. It is also normal that entities disappear (die).

Enterprises have been traditionally set up like a machine with a few controls to operate it. When it was about a manufacturing shop making bicycles that worked well. A large enterprise offering multiple products and services and employing several thousand people is a hugely complex system and cannot be controlled in the same way as the small shop.

Unfortunately the mindset of the small bicycle manufacturer has created bigger and bigger machines and within those enterprises software systems are created that mirror the machine like organizational structures.

The following are a few ideas.

## Use only what is in production
Every enterprise I have coached at so far is always trying to create long-term project plans based on hope. It is the hope that group X will deliver functionality Y by a certain date that creates a lot of fear and thus drives people more and more into control behavior in a desparate attempt to avoid uncertainty. At some point it becomes a vicious cycle.

The simplest way to avoid uncertainty is to use only what is already in production. It is available, likely runs quite stable and there is infrastructure and operations people to keep it running.

## Everything has an API
Loose coupling is well-known within the developer community. When any system exposes an API, the services it provides can easily be used in a way not envisioned by the original developers at the time.

A lot of web applications are now being created as a client application running in the browser that talks to an API exposed by the server portion of the whole system. That makes it incredibly easy to reuse functionality in a new context.

## Technical abilities to create variants
The better the technical skills of the developers in an enterprise are, the easier it is for them to make any changes to any piece of software. It's all about being a true software craftsman.

Good code can be written blazingly fast, if you let experienced people do it. And furthermore, writing the code itself is not the problem at all. The challenge is to design something that can be modified easily. For that you need really good developers.

If you let talented people pursue personal mastery in software development, you will have a lot of very good developers. Just get out of their way and invest into creating an environment that is suitable.

## Collective code ownership
Anyone is allowed to make changes and improvements to any system in the whole enterprise.

Changes need to be given back within a reasonable timeframe to the group owning a system. That is similar to open source development.

### Pull requests
There is one particular version control system (git) that makes collective code ownership and giving back changes very convenient. Git has a concept and mechanism called *pull request*.

On the platform GitHub these are frequently used to accept contributions from developers beyond the core team ([see details](https://help.github.com/articles/using-pull-requests/)).

### Variants can go into production
If the code for all systems is owned collectively by the developer community in an enterprise and people are allowed to make modifications to reach their goals, it is required that the variants can go into production.

However, that does not mean that people should be encouraged to operate an infinite number of variants for all eternity. Instead the changes should be pulled in by the owners of a system in a timely fashion and only as an exception should the modifying group be allowed to operate their variant. 

To play this game right the concept of real options is helpful.

## Favor small systems
The smaller a system is - that refers to the size of the code base for it - the easier it is for developers to understand it and make modifications to it.
