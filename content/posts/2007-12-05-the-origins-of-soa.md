---
title: The Origins of SOA
date: 2007-12-05 21:50
author: aabs
category: SemanticWeb
slug: the-origins-of-soa
status: published
---

I recently attended Juval Lowy's WCF Master class course in Sydney, and in the introduction to the course Juval made some really interesting observations about the origins and justifications of Service Oriented Architecture. I was reading over the notes I took the other day, and I thought they were worthy of a blog post. Thanks go to Juval for making the course entertaining with so many quotable observations. I've tried to relay them here as he said them. If I misquoted him or haven't kept the thread so clear, then the fault is mine.

He approached the history of software engineering from the perspective of [coupling](http://en.wikipedia.org/wiki/Coupling_%28computer_science%29). There are many kinds of coupling in software systems, and we can see their effects by looking at the amount of analysis work needed to determine the effects of a change to a piece of software. Within a tightly coupled system the effects of a change can be felt in distant parts of the system because of causal chains linking the changed areas of the system with others. There may be no direct link between the changed system and those other regions, but designs are like transitive relationships - they fan out through the system affecting everything they touch. Designers spend a lot of time trying to avoid coupling. The origins of SOA stem from the decades long search for transparent forms of decoupling.

As Lowy sees it, WCF is the pinnacle of those decades of effort that have culminated in an easy to use system that allows fairly complete decoupling whilst allowing the developer to retain complete control over many aspects of the runtime behaviour of the system. It also allows the developer to control aspects of security, scaling and robustness that are not by default part of the .NET framework. For those reasons he asserts that .NET is dead and WCF is the new .NET.

Prior to the advent of structured programing, machine code software made heavy use of the [branch instructions](http://en.wikipedia.org/wiki/Considered_Harmful). To see the effect of a change made to the system (and thus its state) you had to trace the gotos to see what code made use of the data that you changed, and then you had to see what was dependent on them and so on. Structured programming (use of sub-routines) was the first major effort to introduce a measure of decoupling within the system to localise the effects of code changes.

The use of global variables in structured programming languages like C forced you again to perform extensive analysis to work out where the variables were being read and written to. The need to decouple a system from coupling via variables brought on the advent of object oriented programming. You see the drivers for each of the major programming paradigms has frequently been attempts to remove a form of coupling inherent in the language. Object oriented languages provided a facility to encapsulate variables so that you knew where they were going to be use from, thereby reducing the analysis required to work out how to change the code.

Object oriented languages suffered from their own kinds of coupling though. For a start they required that you interoperate with them using the same language. The same language requirement meant that teams had to standardise on a given language if they wanted to share any of their code modules or algorithms. Doing otherwise reduced the economies of scale for reuse within the company. But code file reuse within a team cause a form of coupling too. If team A produces some code, then for team B to reuse it it has to adopt design elements from the system that team A wrote the module for. That meant that in many case there was either friction between the teams, or there team B just rewrote the module themselves (the so-called ['not invented here'](http://en.wikipedia.org/wiki/Not_invented_here) syndrome). With the advent of large frameworks for inter-process communication that were intended to allow high-use systems to scale, many of the strategies that were part of the OO paradigm had to be dropped anyway.

The use of class hierarchies meant that there was also a form of vertical coupling between elements in a class hierarchy. If you wanted to use one class, you might end up tied to all the classes in the system that it was coupled to. You got the whole class hierarchy. DLLs provided a means to allow code reuse whereby that code could be dynamically brought into the system enabling prepackaged reusable code elements. But even they were coupled to runtimes and introduced coupling to DLL versions.

DLL hell was the situation whereby your system became coupled to a specific DLL version forcing you to go through hoops to provide a smooth upgrade path. And even then it wasn't really feasible to have multiple installs on a given machine that used different versions of a DLL. COM provided a versioning mechanism that allowed you to address DLL hell, but its interface referencing mechanism (the GUID) meant that software producers were coupled to particular interfaces and that stifled innovation. In any case you still got language coupling through the use of shared headers. type libraries attempted to reduce the language coupling, but they were never very popular.

To quote Lowy - ".*NET is cleaned up COM*" and "*The scars of DLL hell are all over .NET*". The CLR is a component aware version of COM. The versioning problem was largely solved by .NET, but again the zealous use of versioning stifles innovation and reuse, and in my experience it is seldom used in everyday .NET development.

.NET originally provided a few means for interprocess communication such as remoting. Remoting was a fairly high performance solution but it coupled you to .NET which ruled it out for any truly service oriented system. SOAP web services provided a means to allow language decoupling but it didn't address the perennial problems of security, identity, scaling or transactions (to name a few). In addition, there was still CLR coupling because of the low level coupling to threading and memory management models. So .NET was not a perfect candidate for a SOA platform since it still forces many forms of coupling whilst not providing for the core tenets of SOA. To refresh your memory those are:

-   Explicit service boundaries
    -   total encapsulation of everything except functionality
    -   location independence
    -   technological independence
-   Autonomous services
    -   independent operation
    -   independent versioning
    -   independently secured
    -   fault isolated
-   share contracts for functionality and data
    -   technology independent metadata (WSDL, schemas etc)
    -   platform neutral (inter language, inter machine)
    -   version independent
    -   no shared code
-   compatibility is based on policy
    -   only compatible services can interact
    -   policies are published
    -   access control and policy are independent of implementation

In addition Lowy indicates that there are other principles that they must uphold:

-   services are secure
-   they leave the system in a consistent state
-   they're thread safe
-   they're reliable
-   they're robust

None of these features are by default addressed by .NET. WCF on the other hand is designed solely to address these issues. When you code in .NET you seldom even have to think about the above issues (well you do, but not to the extent that you have to write whole frameworks to tackle them). The setting of policies and the addressing of metadata exchange, transactional and security policy can all be controlled during the deployment of the application. That's a major advance. Although at the moment WCF is the only standards compliant  SOA framework, it won't always be. For the moment if you want all of these benefits you're very tightly coupled to WCF to achieve them. That won't always be the case, at which point WCF will allow a solution to all of the kinds of coupling described so far. The costs of getting such inter-system decoupling are minimal in terms of the average developer's day to day business of cutting code.

As Juval pointed out, around 95% of current code is devoted to plumbing. Plumbing is not concerned with delivering business functionality, it's just about getting the system to work as asked for. Nobody cares about plumbing. Think about that for a moment - 95% of your time is spent writing code that no one cares about (or wants to spend money on). Is it any surprise that developers are constantly under time, budget and quality constraints? Is it any wonder that development is being shipped out to India? To quote Lowy - the *software industry is haemorrhaging and Indian blood is cheaper*. Or to put it another way (he was very quotable) - *Plumbing is evil. Every time you write a piece of plumbing you commit a sin against you colleagues and your customers.*

You can see that the history of software engineering has been about the reduction of various forms of coupling. Each step has made it possible to get better value out of the time spent writing, and has led to more robust and maintainable code. SOA is our current best practice. ***SOA in short (and WCF in particular) is just our best current knowledge of how to do software engineering.***
