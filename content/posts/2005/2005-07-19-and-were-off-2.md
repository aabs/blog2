---
title: And we're off
date: 2005-07-19 16:04
author: Andrew Matthews
ignored-tags: DBC
slug: and-were-off-2
status: published
---

I have set up the sourceforge project. You can find it [here](http://sourceforge.net/projects/aabsnorm/). I've also classified all of the work, and split it up into releases.

Here's what will go into release one:

  ----------------- -------------------------------------------------------------------------
  Configuration     Use native .NET configuration
  Configuration     Remove existing config assembly
  Installers        WIX installers
  Runtime Control   Add transactional support from COM+
  Runtime Control   Extend reverse engineering to examine SPs and create wrappers for them.
  Runtime Control   Configurable ID strategy
  Runtime Control   Configurable transaction isolation policy
  Templates         Move core templates into resource assembly
  Testing           Create a proper test database
  Runtime Control   Divide system between runtime and development projects
  Runtime Control   Standardise all names to CamelCase
  ----------------- -------------------------------------------------------------------------

I think the highest priority is the configuration rework. Configuration in the previous system was way too complicated. What we need is a very simple, very reliable system that can easily be expanded to accommodate something like the config app block at a later date. As soon as that is done, the key task will be converting it from its current broken state to a working state, and then splitting the system up into runtime and development arms. I will also do some work towards creating WIX installers for the runtime and development systems, including an installer for packaging source releases, that will allow the easy setup of a development environment for new volunteers on the project.

This is of course based on the "*if you build it, they will come*" model of open source development.
