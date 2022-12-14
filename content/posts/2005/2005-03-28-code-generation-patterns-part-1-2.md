---
title: Code Generation Patterns - Part 1
date: 2005-03-28
author: Andrew Matthews
ignored-tags: Code Generation
slug: code-generation-patterns-part-1-2
status: published
---

This time I'm going to show you the design pattern that I use for code generation. Generally I use this for analysis of hierarchical structures, such as assemblies or database metadata. You could use it in other scenarios, where data is less structured. If you are familiar with the operation of a SAX parser and .NET events then you'll have no trouble understanding the design.

#### SAX-like Parser

A SAX parser works by iterating through its material (in this case XML, but that's immaterial) firing off events for everything that it finds. It doesn't do anything with what it finds, it just acts as an event generator that embodies some knowledge of the internal structure of the incoming material. It is up to whoever is listening to the events to do something with them. In the case of a SAX parser an XML DOM tree is probably built up, but not necessary, and that is the point. You have the option to tailor your processing of the sequence of events according to your requirements.

#### event scanner & generator

In my design pattern the objective is to decouple event generation from event handling. As far as the event handler is concerned, it is the order of events and their content that matters, not where they originated from. Likewise for the scanner it is not important how the data is handled, only that it navigates through the data properly. So we decouple and encapsulate the two aspects of the process and enable the enhancement and extension of the system easily.

#### multicast events

The use of events means that you can *multicast* events frm the scanner to as many handlers as you need.

#### typed events vs overloaded events

A natural question that occurs to me when I liken the pattern I use for code generation with that of a SAX parser is why I use a plethora of events with typed parameters rather than an overloaded interface with a single event and event parameter type. With SAX events come in many shapes and sizes and are sent out through a single event interface. In my design I have chosen an interface and a set of events that represent each of the possible entities that we are interested in. The interface for the assembly scanner looks like this:

In a previous project I used the delegate/event interface as a common language between a set of components of an ORM system. The data initially made its way into the system through a reverse engineering database metadata schema reader. Apart from being a mouthful to say, it read the structure of a SQL Server database, and generated a set of events that were multicast in the ways I've described above. One of the listeners built an in-memory model of the schema. Later on we needed to persist this model to disk as a configuration file that would be used at runtime as the class map of the ORM (if this intrigues you, goto Scott Ambler's web site for some very influential papers). So when the ORM service started up it loaded the configuration file and read through that firing off *exactly the same events*. The same listener was stationed on the other end of the event interface, so I was able to guarantee that the class map model was brought into memory in the same way as was used for the code generation cycle. My point is that this typed event interface acts as a common language between components participating in the data's lifecycle. If provided a natural depth first search model for passing data about in a way that allowed on the fly processing. It also allowed a complete decoupling of the data traversal mechanism from the data handling, the sequence of events was all that mattered to my code generation system, not the format on disk or even in memory - for all it cared the data could be stored as metadata in an RDBMS or nodes in an XML file or DOM. The decoupling is total, but not at the expense of vagueness as can be the case with catch all interfaces.

    public class AssemblyScannerEventNotifier : MarshalByRefObject { public delegate void NewAssemblyHandler(object sender,   NewAssemblyEventArgs e); public event NewAssemblyHandler newAssembly; public void NotifyNewAssembly(Assembly assembly) { NewAssemblyEventArgs e = new NewAssemblyEventArgs(assembly); if (newAssembly != null) newAssembly(this, e); } }

The EventArg object simply carries the assembly that has been found.

    public class NewAssemblyEventArgs : EventArgs { private Assembly theAssembly = null; public Assembly TheAssembly { get{return theAssembly;} } public NewAssemblyEventArgs(Assembly assembly) { theAssembly = assembly; } }

What this allows is for us to multicast the event to a number of different interested parties. Generally that will be a small set including the code generator or some intermediate party, plus the test harness to provide a progress bar.
