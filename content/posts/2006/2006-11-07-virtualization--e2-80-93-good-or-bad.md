---
title: Virtualization – Good or Bad?
date: 2006-11-07
author: Andrew Matthews
ignored-tags: programming, software
slug: virtualization-%e2%80%93-good-or-bad
status: published
---

Virtualization is a craze in the making. All the warning signs are there – you have to throw all your machines away, and replace them with several hundred thousand dollars worth of new ones. Effectively you have to ditch your distributed system and replace it with a distributed system simulated on a supercomputer. Wow. That's Cool!!! But is it a good idea?

The first time I had the technology (and its capabilities) explained to me, I was captivated. But I've spent the last few weeks thinking about what it means to me as a designer and developer of enterprise web applications and I'm beginning to question the wisdom of virtualization as a technology.

The latency of all inter-tier calls will shrink massively from milliseconds to microseconds. That will allow the server to render pages at a MUCH higher rate. Its threads are not waiting on calls to external services like RDBMSs. If that is the case – what effect does that have on the design of typical distributed systems? Can we dispense with the usual strictures against chatty interfaces? Can we avoid using cursors and other programmatic methods to avoid network usage?

The beauty of virtualization is that it allows us to undo some of that overzealous use of remoting and web services that we all used a few years back, because it was the craze at the time. Physical deployment wasn't a benefit of n-tier design; it was just what people thought they ought to be doing to their n-tier designs – to allow scaling. The problem was that people never took the time to do stress and volume testing and capacity planning, so they didn't know where their time was being wasted – they just deployed across a web farm in case. The end result was that simple pages could take a large chunk of a second to render because of all this needless communication across the network.

Virtualization magically turns our physical partitioning back into logical partitioning. This is a great thing. But not something we need to spend a gazillion dollars to achieve. Just use in-proc calls wherever possible. If we were to back off from physical partitioning, what are we left with? An n-tier logical design deployed on as few machines as possible (whilst still retaining fail-over).

Question: If you had a supercomputer to run a website with, would you use a sizable proportion of its CPU cycles to simulate an old-style web-farm or would you dedicate all the CPU cycles to rendering web pages? I guess the thing is that virtualization allows you to do is make a slow transition from physically distributed systems to monolithically distributed systems. Which would be better – have a VM server running a single VM for the presentation and business logic tiers or have several VMs doing that work? I'd be interested to see how the performance metrics look for these two scenarios.

Virtualization will mean big changes for development teams, since it may be possible for them to test their code on literally identical installations to production. What other changes are in store?
