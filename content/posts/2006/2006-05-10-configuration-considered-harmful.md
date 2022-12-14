---
title: Configuration considered harmful
date: 2006-05-10
author: Andrew Matthews
ignored-tags: Computer Science, programming
slug: configuration-considered-harmful
status: published
---

The configuration of applications is a reflex action these days. Programmers assume the need for a config system without reflection and then move on to wondering *how*they will implement it. I've spent a bit of time lately wondering how many of these standard practices of configuration are ill-pre-conceived opinions. Do they deserve the merit that they have? I con't help but think that most of the times I use config it's out of habit, and the vague idea that it adds to my system somehow. But, when I look back on it, I can't see much benefit from having done so. The question I'm try to answer here is really simple. What has configuration ever done for us?

Lets start with a little model to make it easier to reason about configuration data within the wider context of program state data. I'm going to think of a program as a state machine, but I will use a more inclusive idea of what constitutes and defines state. Most industrial-scale systems are very complicated, with a huge state-set defined by all the variables that will exist during their lifetimes. The variables of the program include all of the state variables that are reachable by one means or another. This is a vital point.

Most programmers think of state as whatever is in memory. I'm not going to do that for this little rant because I think that the information environment of any non-trivial interactive system extends beyond the physical boundaries of the system to all the data sources that it can reach. That includes you and I. We humans are not only top-level exception handlers but peripheral data storage devices and processing units as well!

When I say that every piece of reachable data is a part of the state I am being very inclusive - I mean configuration files, database rows, writing on bits of paper, anything and everything. Reachability is key to this little model - if you can get to a bit of data, instantiate it and store it in memory at some stage during the running of the program then it counts as state data.

Normally we distinguish between data that we store in a database from what's in memory, but what is the *real*difference? It can all be inspected, modified, transferred about, displayed and discarded. That it isn't in memory all of the time is irrelevant - memory is a hierarchy of progressively more or less volatile stores in which can be placed pieces of state data. And that hierarchy doesn't end with tape drives it extends beyond into hard-copy and the heads of users, it trickles out into peer systems it interacts with. We can get to it through peripheral devices, and dialog boxes and bring it into the CPU so the APIs of these peripherals, dialog boxes etc can be thought of as another

kind of query, or object retrieval.The distinguishing feature of data that is part of the state is the ability to load the data into the CPU and use it. By that criterion, all reachable data is equal in the eyes of the state machine. So, we can imagine this vast state space defined by the variables that are set and the variables that may be set during the running of the program. Each state transition must involve the modification of one or more of these variables.

The initial state of the program is defined by the initial state of each of these variables. Obviously it doesn't make much sense to talk about the initial state of variables that don't exist yet if you only credit variables as those that exist in memory at run time, but if you imagine placeholders for all variables whether set yet or not, then you can also imagine their being set as just another state change - just the normal workings of a state machine, nothing more.

This model is a simplification of how we generally think about a system. Normally you have to jump through hoops to get external data from out there into the system, so you tend to forget that it is still state. But with the more inclusive view of state it seems more natural to try to erase, ignore or hide the origin of data. It also makes me wonder whether so much data needs to be retrieved through config systems rather than via the normal language runtime.

That we can get all state data into the CPU and out again means we can ignore its origin and focus on issues with retrieval and storage. Most systems of any size have a configuration component, data access and user input. Each of these mechanisms for getting state into the system have grossly different APIs. The differences are almost always dictated by technological problems with the hardware used. File system access for config, RDB queries for databases, and window drawing for dialog boxes. But, the data after the process is finished is always the same.

The differences between the APIs and the formats used for storage in these various media forces us to treat the data as though it is qualitatively different from data in other media. Obviously that's not the case. We still deal with objects in the core of our applications, so any format conversions or format impedance mismatches are irrelevant. For example, it is still common for companies like Microsoft to recommend the internal use of datasets and XML documents within an application. That is a form of technological domain pollution from the communications and storage technologies used. It is a sin akin to performing a one way format conversion. I appreciate that it may be expedient to do so, but lets not kid ourselves - it's not big and it's certainly not clever!

There are glimmers of light. LINQ is a unified query mechanism that hides the origins of data and yields strongly typed results. It is precisely what is needed to allow a unification of our conceptions of state data. I'm looking forward to it because it will simplify my models hugely. I just hope MS doesn't pull the plug on it like they did with ObjectSpaces.

The main reason that people use configuration systems is to tailor the behaviour of systems from one machine to another, or from one class of machines to another. i.e. all UAT machines might be tailored to use a test database and to use a low logging threshold. Another reason that I have used in the past to justify using configuration is the notion that I may need to tailor the behaviour of the system at runtime. So, I need to at least leave the door open to an extension, right? Both of these excuses hold a lot less water than you might think. In fact they are anti-patterns that need to be re-assessed urgently.

Config settings are often keyed to classes of machine, so a dev machine will behave differently from a UAT or production machine. Configurations are seldom created on a per-machine basis - it makes testing harder if you can't guarantee that the other developer or test machines will behave in the same way. So the set of customisations of behaviour can be tailored based on a single environment setting. Since that is the case you could have a class hierarchy in code that looks like this:

    public class DefaultRuntimeSettings : IRuntimeSettings{}
    public class DevRuntimeSettings : DefaultRuntimeSettings{}
    public class UatRuntimeSettings : DefaultRuntimeSettings{}
    public class ProductionRuntimeSettings : DefaultRuntimeSettings{}

The class factory could look like this:

    public class SettingsFactory{

    public IRuntimeSettings GetSettings(){
        switch(GetRuntimeClass()){
        case RTS.DEV:
            return new DevRuntimeSettings();
            break;
        case RTS.UAT:
            return new UatRuntimeSettings();
            break;
        case RTS.PROD:
            return new ProductionRuntimeSettings();
            break;
        }
    }

The DefaultRuntimeSettings class defines all of the default values for the configuration settings, UatRuntimeSettings overrides that for values that apply to the runtime settings and so on. It's a very simple arrangement, and will work perfectly well in most cases. After all if we want to change any of these settings we have to stop the server anyway, whether using a config file based system or not, so we lose no flexibility in the process by doing it this way. We can have intellisense with this, which is one thing we couldn't have with the Settings\["ABC"\] approach.

We don't lose out on the runtime update, if that really is a requirement, either. We could use a plug-in model that reloads the settings assembly if we really wanted to, but even then we still face consistency issues. But we could do it that way, without having to resort to external config settings.

In previous projects I have resorted to using file system monitors to watch a config file change as trigger to reloading the config settings. In that case I had to resort to using a publish/subscribe pattern as a means to notify configuration consumers that the config settings had changed so that they could refresh any references that they held in a safe way. In that case I was dealing with the core configuration files of an ORM service that needed to have its runtime behaviour tailored. But let's face it - an administration console is a better choice for that kind of tuning. My point is that I find it hard to think of a scenario that isn't better served by an admin console and internalised settings.

I hope that I have at this point persuaded you that my point deserves more than a glance. Can you think a piece of config code that you have written that *had* to use external config settings? I wish I had a dollar for every program out there that was written with the idea that in future it would be extended to allow live updating of config settings, but which never got that extension.

There is another nail in the coffin of runtime updating of config settings. That is consistency across sessions, machines and operations. Imagine you have a situation where a system is updated to use a different session store dynamically, but there are still references extant after the update that point to the old session store, and writes happen to the old session store after the update. What do you do about that? ASP.NET shuts down the whole server and restarts, it's the only sensible thing to do.

Another situation where inconsistency can take place is if similar changes are rolled out across a class of machines in a cluster progressively. At some point in the process different machines that could take part in a user session are using different configuration settings. That may lead to similar devastating failures or corruptions. It's a kind of thread safety problem that is common in multi-threaded applications. In multithreaded applications, the mutex around a shared data item is the standard way to guarantee consistency. On the config level that means having a mutex around every configuration setting to prevent inconsistency. That is a recipe for poor performance. Putting the config settings in a shared data store adds to the delays, and row locks on frequently used configuration data could lead to terrible performance degradations. One might resort to banning any kind of caching of config data or having a shared configuration server. Both approaches add delays, complicate the model and provide nothing in return.

We don't escape from this dilemma by providing an object oriented solution. If we recreated a singleton config object at runtime in response to a signal, we still face problems of consistency. Either we have to lock everybody out, and then do it, or we have to restart. Or both. ;-) This is the reason why most of those system out there never got their promised upgrade to allow runtime update of config data.

So we are faced with a trade-off between performance and consistency. We may be able to come up with a fast way of sharing config between all the machines in a class, but at what cost? Most of the time we will be able to update config settings while we are adding new features or updates to the system so we don't really need to go to all that trouble. Did we need to go to the trouble of creating all those vast complicated configuration frameworks in the first place? I don't think so, I think that we should look for ways to avoid config altogether - it's harmful, to designs, performance, consistency and readability of code. Generally it's evil, and should be allowed out of the house only when dressed up in legacy clothes.
