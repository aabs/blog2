---
title: Policy and Configuration II
date: 2006-10-20
author: Andrew Matthews
ignored-tags: programming, software
slug: policy-and-configuration-ii
status: published
---

The last time I gave some thought to some of the limitations of configuration systems, I was concerned that people use configuration without thought about the consequences. Configuration seems to be a solution of *first resort*. I was trying to argue that that is probably an unwarranted strategy. It needs to be thought out. I argued in favour of a limitation on configuration. The points I made were:

1.  The implementation of configuration systems intrude into their client systems unnecessarily.
2.  Configuration systems should produce typed objects, not name-value containers as is all too often the case.
3.  Name-value containers impose an unnecessary overhead when their contents are used regularly and are converted into non-string objects.
4.  Configuration data is *just state data* so it should be created and managed in the same way as any other state data, unless there is an overriding reason to not do so. Developers need to think really hard about whether there really IS an overriding reason to use configuration.
5.  Configuration data can be split into policy data and system state. Policy data controls program flow, and system state determines outputs.
6.  Most configuration data should not even be configuration data.
7.  Hierarchical configurations are best represented using native type hierarchies.

These generalizations don't apply across the board, and some systems are better than others. The general trend is towards typed state data, but point 4 inclines me to the idea that we should hide from ourselves the fact that we are even dealing with configuration data. Polymorphism allows us to incorporate points 1,2,3,4,6 and 7 seamlessly. In this post I want to explore the ideas further and see whether we can conclude anything about how we ought to be handling configuration data, and state data in general.

Are there different types of configuration data?
------------------------------------------------

Previously, I mentioned that configuration data falls into two broad categories: Policy data and State data. By 'policy' I mean data that determines how a system behaves at run-time. As I mentioned before, policy data is a subset of the state space devoted to making decisions about *how* to do things. The rest of the configuration provides input to what gets calculated during program execution. Policy acts as input to flow of control statements. The following excerpt from a configuration file shows a fairly typical example:

`<add key=”DefaultEmailFormat” value=”html” /> <add key=”SmtpServer” value=”smtp.myserver.com” /> <add key=”ForgotPasswordMessageHtml” value=”<html><body>Dear {0},<br/>...” /> <add key=”ForgotPasswordMessageText” value=”Dear {0},\n\n ...” />`

Both types of configuration data are present in this example. DefaultEmailFormat is quite clearly a policy variable, it is used to decide which ForgotPasswordMessageXXXX template is used to generate new emails. Likewise, SmtpServer decides where a message gets routed to when it is being sent. The ForgotPasswordMessageXXXX configurations are different. They are never consulted in deciding what to do. They are used instead to generate data that is intended to produce output. In this case the output is an email body.

My first thought when I noticed this division of configuration data was – surely there are items of configuration data that are both policy *and* configuration. What I'm speculating about in this post is whether config data should be divided in this way - whether such a division will allow better designs.

With a holistic view of the system, we might be able to cut through the propaganda about configuration and characterize what, if anything, distinguishes those variables that directly affect the state evolution, and why they ought not to be shoved into XML files or databases. In my previous posts on configuration I used an email system as an example to illustrate what I'm on about. So, consider the two variables: SmtpServer and DefaultEmailFormat.  Each of these variables that might be candidates for putting in a configuration file to initialize the email system. Is there a difference between these two variables in the way they are used, or how they affect the outcome of operations?

The SmtpServer variable tells the email system where to connect to send an email. The DefaultEmailFormat affects what form of formatting the email server should use for its emails. The SmtpServer setting is just telling the system what IP address to connect to. The system doesn't behave differently if a new address is put in - the same path of execution gets followed, even though the external outcome may be different.  The DefaultEmailFormat variable, on the other hand, will cause different data to be sent. It will also cause different formatting tools and validators to be used, and may cause different email addresses to be retrieved. In other words, it more directly affects the flow of control in the system, without directly contributing to the state data or outputs. It doesn't form part of the output of the system, and it is in existence from the very first moment that the program gets run.  Of course, you can imagine a system where these are not the case, but for the sake of this illustration I am making the point that variables can often fall into these two categories. If you were to modify the logic of the system so that the system responded to the SMTP server or paid no attention to the ShouldSendAsHtml variable. You would however just be changing the category into which these variables fell, without changing the nature of the categories. And it's the fact of these categories that is the point that I'm trying to make - some variables have disproportionately more influence over the evolution of the state of the program than others.

### A holistic view of stateful systems

I've distinguished between two types of configuration data, but I wonder whether there is any real difference between configuration data and the normal state data that we consider the grist for the mill of our programs?

In the example above, policy data controls how the state of the system evolves, because the state is controlled by the branches in execution on the way to producing a result.  Imagine an executing program as a sequence of states - an automaton. In an automaton, we represent the status of a system as a finite set of 'states'. As the program progresses it moves between states, until it either loops back to it's original state and starts again, or finishes on a completion or error state. All non-trivial computer programs have to maintain a record of their state, often in numerous variables and objects, and the combined set of these variables represents the current state of the system.

More often than not, we'll find that the state variables are distinct from the normal data that the system is manipulating. Even more often they are implicitly stored in the position of the program's thread of execution. The point is that the data that keeps track of where we are and what we need to be doing is kept apart from the data that we are manipulating. Imagine that our email program has to go through a set of states to do a mail merge. The system may start out in a '**ready**' state, move to a '**collecting recipients**' state, then on to '**producing emails**', '**sending emails**' before returning to its '**ready**' state again. Much of this will be implicit in the stack frames that define the sequence of method calls we make.

The system undergoes a sequence of state changes under the control of a set of policy data variables. For a program that is closed (i.e. no inputs), the evolution of states is perfectly determined by the initial state of the system at start-up. For a system that is not closed, i.e. one that receives input from outside, such as user input or data from some other source such as a database, we might be tempted to regard it as in some way random.  I prefer to think of the external input as still part of the state, but stored elsewhere. Hence what I meant by ***Holism***.

Configuration data, although externally stored, is still state data. It's just more obvious when it has been brought into the system and turned into objects. Likewise, we can treat user input and all other input as just another form of state. The user is a kind of external database for state data. The system uses the GUI as a form of retrieval mechanism (a query API?) to get that data on demand.

This is a bit of a simplification of the real state of affairs, because policy data and non-policy data can swap roles at will. SO perhaps it's better to regard the whole body of data within reach of the system as state data. What would the consequences be if we could categorically claim that each item of data fell into one role or the other? Would that constitute a good or a bad design? Would it be harder or easy to think in these terms when designing object models? Would we treat members of those object models differently? Would wee be able to make stronger assertions about how state will change during the course of a method invocation?

Whenever I am designing a system my mind works as hard to break the conceptual design as it does to construct it in the first place. What would happen if we had a design that used a variable both as input to and output from a calculation and as a policy variable? Lets construct an example? Let's take SmtpServer – imagine a piece of code that did the following:

`string server = (DefaultEmailFormat.ToString()) + “mail.myserver.com”; if(server.ToLower().Equals(“htmlmail.myserver.com”)) SendHtmlMail(server, “Message from ” + server); else SendTextMail(server, “Message from ” + server); `

It's a bit contrived, I know, but I've seen worse in production systems, believe me! Now, the server variable is constructed out of a policy variable and it then used as both a policy variable and as normal state data (as part of the message being sent). What conclusions can we draw about this piece of code? The first thing to note is that the code becomes more brittle after the change. Changing a single variable now affects not only the path of execution of the system, but also its outputs and they will potentially be compounded over time. By keeping the policy variable separate from the state variable we are able to independently manipulate the behaviour of the system or the content of its outputs. Thus we stand a better chance of being able to maintain the system over time. There is also a hit on the comprehensibility of the system that also makes it harder to maintain and extend. This is a form of coupling that once embedded into the logic of your system, can be very hard to weed out without extensive refactoring. It therefore seems to me that careful division of variables between policy and state can contribute to the long-term viability of a software system.

There is another issue that I want to discuss next, which is another defining feature of policy variables. The frequency with which they are accessed. The frequency of access of variables can be used to justify special treatment for policy variables. That point is a specific case of a general problem – the misplacement of data in the memory pyramid.

Frequency of Reference
----------------------

Modular software systems tend to follow the '*transaction script*' pattern in making state changes. That means that at any stage they are working on making modifications to a specific subset of the data that is in the system. In outlook, you wouldn't expect that when you add a new task that it would be also making modifications to the archived messages, or setting up new appointments. That principle is called the *principle of locality of temporal reference* (PLTR). If like or related data are kept together then changes and references to data will tend over time to cluster together. That is – if you access a variable now, the chances are you're going to need it again soon. That's the principle on which working sets in virtual memory systems are based. If you are working on a piece of data, bring it into memory for a while along with other data nearby. That way when you need to update a related piece of data it will probably be to hand.

A memory pyramid defines areas of access relative to chances of access. Therefore if you expect to refer to or change a piece of data frequently, don't put it out to disk. Keep it in memory, so that you don't incur unnecessary delays when you want to get to it. The concept of the memory pyramid stems from the insight of the PLTR in deciding where to put state data in a system with memory constraints. In a memory pyramid data is inherently mobile, since it moves up and down the memory pyramid as the chances of accessing it rise or fall. In many case the operating system takes care of moving data between levels of the pyramid. In some key cases, such as configuration you have to do it yourself. If you do not to make a choice, you still have made a choice – probably not one you were counting on.

![](http://static.flickr.com/82/274215346_2f741304b3_o_d.png)
[**Figure 1. A Memory Pyramid, showing types of data according to how much we can store there, and how fast we can get at it.** ]{style="font-size:9pt;color:#4f81bd;"}

The majority of configuration data is incorrectly placed in the local disk tier of the memory pyramid. The majority is also generally stuck where the developer puts it, and cannot move. By drawing the distinction between policy variables and normal state variables, I hope to highlight that some configuration should be elevated to RAM and others should be relegated to remote servers.

Locality of Spatial Reference – or *Use Case* for short ;-)
-----------------------------------------------------------

Most of us write modular code these days. With the help that modern refactoring tools provide, we can easily factor out duplication in our code, and move it about till we have a tidier, more normalised, class design. Which brings me to another kind of locality of reference principle – the *principle of locality of spatial reference* (PLSR). This is related to the PLTR, and works in the same way. When you access a piece of data, you are likely to access pieces of data nearby or related to it. That means you should cluster semantically related data together, and move it around in the memory pyramid as a chunk. So, another criticism of standard configuration systems such as that natively provided by .NET is that all configuration is treated as an undifferentiated mass without semantic linkage. Perhaps something like RDF should be used to store configuration data. That way, we could at least know what goes together and how to treat it.

There are policy variables for use in specific use cases that will, for a while, be accessed continually and then not be used again for seconds or hours. The PLSR tells us that if we keep them around in memory after that time, we are probably just wasting space. Likewise, if we leave them out of memory when they are most in use we are causing disk access that could be avoided.

What we should do is assess the usage patterns of our configuration data and use that as a guide on how to put it in its rightful place in the memory pyramid. That either means we need a much more sophisticated configuration system or, as I think, a vastly simpler one.

In Summary
----------

This time round I've tried to highlight some other concerns about how we use configuration. In addition to criticisms of needless overheads and lack of type-safety, the way we treat configuration is symptomatic of a general issue about mobility of data. Next time I tackle configuration, I'll try to focus on some real-world concerns that may influence how we should treat state data in modern applications. Issues such as thread safety, spatial distribution, consistency, mutability and system complexity. What do we know so far?

-   Some state data is used for decision making, while others are used as inputs and outputs to calculations
-   Designs that avoid this distinction can lead to brittleness, unreadability, inflexibility and maintenance issues
-   All data in a system (or within reach of it) can be thought of as system state.
-   That data can be accessed intensively over time and, when accessed, will likely see related data accessed as well.
-   State data exists in a memory hierarchy (a memory pyramid) – whether we like it or not.
-   Most configuration data is improperly placed in the memory pyramid. Too high in the case of normal state data, and too low in the case of policy data.
-   State data has a semantic structure that will affect its usage patterns, and these structures should determine how we handle them WRT memory management
-   All state data, but especially critical configuration, should be mobile inside the memory hierarchy.

I don't think I have all the answers here – perhaps its more accurate to think that I have more interesting questions. So why don't I finish off with some questions? Try answering those questions and let me know if you come up with different answers.

-   should policy variables be stored and treated differently from non-policy state data?
-   Where should policy data be stored?
-   Is policy data consulted more or less often than other state data?
-   Where should state data be stored generally?
-   Is caching an issue to consistency or performance? If so how should we cache state data generally, and how should we expose our technology to the rest of our systems?
-   Should configuration data be retrieved on demand, or brought into memory?
-   Should state data follow the memory hierarchy?
-   Does the treatment of state data need to follow the memory hierarchy according to usage patterns, or can we manage it all in a block? How do we represent a block of related data? How will that change between different types of data? (i.e. sparsely or highly interconnected data)
-   Do policy and state data fall into different parts of the memory hierarchy?
-   What about other types of data in the system? Are there other types of data classifications?
-   What are the forces at work in making decisions about how state data is managed? i.e. memory size, speed, latency, volatility etc
