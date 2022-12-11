---
title: Why open-source software development environments are crap
date: 2007-02-02 14:21
author: Andrew Matthews
ignored-tags: programming
slug: why-open-source-software-development-environments-are-crap
status: published
---

It seems that our little [Anti-Agile spat](http://alecthegeek.wordpress.com/2007/01/23/agile-is-not-a-panacea-neither-is-it-a-cure-all/) generated a fair amount of traffic for both Alec and I. Alec's excellent blog attracted a record number of visitors. Quite right too. Evidently [Mitch's](http://notgartner.wordpress.com) comment about opinion being more of a draw than painstakingly researched and presented essays was right. [***Controversy drives up the ratings.*** ]{style="text-decoration:underline;"}I say "*hey ho!*" let's go with the most direct way to get things going – Alec baiting. Alec, as you all must know now (since you've been to his blog now), is not only an Agile band-wagoneer but a bit of an aficionado of obscure and marginal operating systems – he has to write device drivers on the train in the morning to get his laptop working, no joke. Another thing you may know about Alec is that he creates Linux development distros for open source development teams, which brings me to the point of this post.

[***Open Source IDEs are Crap!***]{style="font-size:14pt;"}

Now, I am not leveling this criticism at Alec, since he doesn't write the IDEs. I am leveling this criticism at all of those IDEs that I have ever turned to in the vain hope that the time has come for me to migrate to Linux. I am a C\#/.NET developer, but before that I was into Java and before that into Visual C++ and before that I used GCC and before that I used Eiffel and compiler suites for VMS and various Unix variants.

As a Java developer, I was (through budgetary constraints) obliged to work with open source development environments like NetBeans, and Eclipse. I ended up better off with Vi. They were slow, flaky and frustrating. I thought that this was just a case of them being based on Java, and thought little more of it. I've been able to work with Visual Studio ever since I left university in 1995. At all stages through that period, VS was regarded as the benchmark for other tool vendors. They never seemed to make the grade. I very soon abandoned the Java world – I couldn't stand the tools, the debuggers were crap or non-existent and the documentation was sparse one-dimensional and uninspiring.

Visual Studio Team Suite has raised the bar again. During a recent stint with a client here in Melbourne I was required to knock together a development environment that was partially based on VS.NET 2003 but with a whole bunch of open source tools to fill in the gaps for revision control, bug tracking, team portals, task and requirements management. It worked and the team got stuff done, but when I moved on to the next project I used TFS and was forced to admit that the unified team development experience is fantastic. There is nothing out there in the open source world that can begin to compete with the fluidity of TFS.

*I WANT to run Linux* on my laptop. I gave up Windows PowerShell and went back to Cygwin. I always use find, grep and xargs in preference to windows search or Google desktop. I Love Unix and would love to go back to it. But I couldn't bear to give up VS.NET 2005. Nothing comes close. As a .NET developer my options are:

-   **Vi + NAnt**
   A mighty powerful combination that can move mountains. Not exactly much in the way of intellisense or debugger support though, eh?
-   **\#Develop**
   not bad, but lagging behind the pack. Partial support for web technologies. Doesn't support Resharper. Won't support LINQ for years, especially not on Linux. No team development or SCC integration.
-   **MonoDevelop**
   Crude port of KdeDevelop?

OK, I'm the first to admit that these reviews are biased and unspecific, but I am hoping that someone out there will prove to me that I'm wrong. I want to go over to Mono. I'm waiting, actually. How long am I going to have to wait?
