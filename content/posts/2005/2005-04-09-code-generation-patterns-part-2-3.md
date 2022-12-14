---
title: Code Generation Patterns - Part 2
date: 2005-04-09
author: Andrew Matthews
ignored-tags: Code Generation, programming
slug: code-generation-patterns-part-2-3
status: published
---

Last time I described typed and un-typed events, and multicasting events to several listeners. One of those listeners would be a code generator. This time I'll go on to describe some of the necessary infrastructure that such a design requires. Generally this information is all about tieing the events together. The context in which an event takes place is as important as the event itself.

When you're generating code progressively, you need to keep track of what you have done, and what still needs to be done. In this case that means the code already generated, and the messages already received, but have not generated code for. It also indicates what code structure(s) an incoming predicate applies to.

There are two complementary modes of operation that a scanner/code-generator system can use for *broadcasting* events. They are variations of tree search algorithms. In the first case, the most senior element is broadcast first. that means that an event would be generated for a type before the events for its methods are fired. I shall call this (for want of a better name) the "***depth-last recursive search***". The second approach is a true "***depth-first search***" since elements that are lowest in the object tree are announced sooner. These two modes support different code-generation plan. The choice will have an effect on what sort of state one has to keep, and how long it has to hang around. More on that later.

With depth-first recursion a *method event* will be broadcast before the corresponding *type event* , and a predicate such as an ***Ensure*** attribute, will be received before the method on which it was attached. Therefore, when you are generating code, you can't just slot what you get into what you already have, because you don't have anywhere to put it.

![](http://aabs.aspxconnection.com/objectTree.png)

**An object tree. Depth means further from the assembly object.**

With a depth first search context variables track the predicates detected till an event for the method is broadcast and we can generate the whole code for the method. We still have to keep the generated code around till we get the type event! Needless to say, we could hunt for such information as the method event arrives. We could use reflection to navigate up the type object graph as far as the assembly if we wanted to. But if we rely too much on that sort of navigation we break the whole broadcast idiom, and morph the algorithm into a depth-last recursive search (which has it's own unique requirements that I'll come onto next).

In the depth-last search the event for the more senior object is fired before that of its subordinates. That means we get the event for the type before that of the method, and the event for the method before that of its predicates. That's helpful because we now have something to hang the subsequent events off of. If you were producing a whole object graph in memory then this would be ideal, since the tree would always be properly connected rather than fractured. This approach is not without its drawbacks, not least of which is that you have to build up an object graph in memory before you can generate the code for it! With depth-first recursion you know that when you get the event for the method that there are no more predicates coming. You know when it's safe to generate code. With the depth last approach you have to send a "*finish*" message that says when the stream of sub-objects has stopped. On the whole I've found for this project that depth-first navigation of the assembly object graph works fine, and simplifies the event interface of the listeners that I want to use. In other projects I've used this on I've done the opposite, and everything has gone OK, it really depends on the sizes of the data stream, and the performance characteristics required. There are drawbacks with either approach and you should probably decide on the basis of the following criteria:

-   Is the stream of events large (or never-ending)
-   Do you need to keep the resultant data structures around in memory
-   Would single-pass processing be an advantage to you.

The snippet below shows some of the code that I use to process events in the code generator. Much has been chopped out of course, but from this you should see how all the talk about depth-first searches and events translates into code generation.

    public class DbcProxyCodeGenerator : DbcSupertype
    {
        public DbcProxyCodeGenerator()
        {
            InitialiseTemplates();
        }

        #region Context Variables

        private ArrayList processedAssembly = null;
        private ArrayList processedTypes = null;
        private ArrayList processedMethods = null;
        private ArrayList processedProperties = null;
        private ArrayList processedFields = null;
        private ArrayList processedEvents = null;
        private Hashtable processedSnapshotsBefore = null;
        private Hashtable processedSnapshotsAfter = null;
        private ArrayList processedInvariants = null;
        private ArrayList processedEnsures = null;
        private ArrayList processedRequires = null;
        private Hashtable processedNamespaces;

        public void NewAssembly(object sender,
      NewAssemblyEventArgs e)
        {
            vtAssembly.SetAttr("assembly", e.TheAssembly);
            string[] namespaces = new string[
      ProcessedNamespaces.Keys.Count];
            ProcessedNamespaces.Keys.CopyTo(namespaces, 0);
            vtAssembly.SetAttr("namespaces", namespaces);
            vtAssembly.SetAttr("types", ProcessedTypes);
            ProcessedAssembly.Add(vtAssembly.Merge());
        }

        public void NewType(object sender, NewTypeEventArgs e)
        {
            ProcessedNamespaces.Add(e.TheType.Namespace, null);
            vtType.SetAttr("type", e.TheType);
            vtType.SetAttr("methods", ProcessedMethods);
            vtType.SetAttr("fields", ProcessedFields);
            vtType.SetAttr("properties", ProcessedProperties);
            vtType.SetAttr("events", ProcessedEvents);
            ProcessedTypes.Add(vtType.Merge());
            ProcessedMethods = null;
            ProcessedFields = null;
            ProcessedProperties = null;
            ProcessedEvents = null;
            ProcessedInvariants = null;
        }

        public void NewMethod(object sender, NewMethodEventArgs e)
        {
            vtMethod.SetAttr("method", e.Method);
            vtMethod.SetAttr("invariants", ProcessedInvariants);
            vtMethod.SetAttr("requires", ProcessedRequires);
            vtMethod.SetAttr("ensures", ProcessedEnsures);
            ArrayList beforeSnapshots =
      SnapshotProcessor.GetBeforeSnapshots
               (e.Method as MemberInfo, ProcessedSnapshotsBefore.Keys);
            ArrayList afterSnapshots =
      SnapshotProcessor.GetAfterSnapshots
               (e.Method as MemberInfo, ProcessedSnapshotsAfter.Keys);
            vtMethod.SetAttr("ssbefore", beforeSnapshots);
            vtMethod.SetAttr("ssafter", afterSnapshots);
            ProcessedMethods.Add(vtMethod.Merge());
            ProcessedEnsures = null;
            ProcessedRequires = null;
        }

        public void NewInvariantAttribute(object sender,
      NewInvariantAttributeEventArgs e)
        {
            EnsureSpecification es = DbcPragmaProcessor.
      ProcessEnsure(e.Invariant.Predicate);
            SnapshotProcessor.RegisterSnapshots(es,
      ref this.processedSnapshotsBefore,
      ref this.processedSnapshotsAfter);
            vtInvariant.SetAttr("invariant", es);
            ProcessedInvariants.Add(vtInvariant.Merge());
        }

        public void NewEnsuresAttribute(object sender,
      NewEnsuresAttributeEventArgs e)
        {
            EnsureSpecification es = DbcPragmaProcessor.
      ProcessEnsure(e.Ensure.Predicate);
            SnapshotProcessor.RegisterSnapshots(es,
      ref this.processedSnapshotsBefore,
      ref this.processedSnapshotsAfter);
            vtEnsure.SetAttr("ensure", es);
            ProcessedEnsures.Add(vtEnsure.Merge());
        }
    }

### Iterative vs final expansion of templates

A seemlingly simple decision like the order in which you notify interested parties leads to significant performance issues that must be known about in advance. To illustrate this, consider the following scenario:
*I want to use this framework in a number of different scenarios. I want to be able to statically generate the code for a proxy object that I then use as though it were the real object. That proxy object will enforce all of my rules at runtime. Projects that use my proxies must include the proxy assembly as well as the assembly of the target object. This is the simple case, I also need to be able to dispense with that and use dynamic proxies. Thus situation is one where I use dynamic code generation at runtime. To do that I need to request access to the object through a class factory that will perform code generation of the proxy on-the-fly. In other situations I want the framework to dovetail with aspect oriented programming frameworks like ACA.NET. In that situation the generated code could be either static or dynamic, but the specifics need to abstracted into a configuration file.*

As you can see from these requirements our needs can swing between static and dynamic code generation, and we may even want to use both in the same program. Performance must take precedence if we want to use dynamic code generation. Static code generation won't suffer over much if we choose a code generation strategy that is biased towards dynamic code generation since its costs are at compile time, and won't affect runtime performance.
