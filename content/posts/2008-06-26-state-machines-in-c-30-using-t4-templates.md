---
title: State Machines in C# 3.0 using T4 Templates
date: 2008-06-26 00:07
author: aabs
category: .NET, functional programming, programming
tags: .NET, C#, DFT, FSA, lambda, NDFA, partial classes, partial methods, T4, VS2008
slug: state-machines-in-c-30-using-t4-templates
status: published
---

**UPDATE**: The original code for this post, that used to be available via a link on this page, is no longer available. I'm afraid that if you want to try this one out, you'll have to piece it together using the snippets contained in this post. Sorry for the inconvenience - blame it on ISP churn.

------------------------------------------------------------------------

Some time back I [wrote](http://aabs.wordpress.com/2007/01/16/342/) about techniques for implementing non-deterministic finite automata (NDFAs) using some of the new features of C\# 3.0. Recently I've had a need to revisit that work to provide a client with a means to generate a bunch of really complex state machines in a lightweight, extensible and easily understood model. VS 2008 and C\# 3.0 are pretty much the perfect platform for the job - they combine partial classes and methods, lambda functions and T4 templates making it a total walk in the park. This post will look at the prototype system I put together. This is a very code intensive post - sorry about that, but it's late and apparently my eyes are very red, puffy and panda like.

State machines are the core of many applications - yet we often find people hand coding them with nested switch statements and grizzly mixtures of state control and business logic. It's a nightmare scenario making code completely unmaintainable for anything but the most trivial applications.

The key objective for a dedicated application framework that manages a state machine is to provide a clean way to break out the code that manages the state machine from the code that implements the activities performed as part of the state machine. C\# 3.0 has a nice solution for this - partial types and methods.

### Partial types and methods

A partial type is a type whose definition is not confined to a single code module - it can have multiple modules. Some of those can be written by you, others can be written by a code generator. Here's an example of a partial class definition:

    public partial class MyPartialClass{}

By by declaring the class to be partial, you say that other files may contain parts of the class definition. the point of this kind of structure is that you might have piece of code that you want to write by hand, and others that you want to have driven from a code generator, stuff that gets overwritten every time the generator runs. If your code got erased every time you ran the generator, you'd get bored very quickly. You need a way to chop out the bits that don't change. Typically, these will be framework or infrastructure stuff.

Partial classes can also have partial methods. Partial methods allow you to define a method signature in case someone wants to define it in another part of the partial class. This might seem pointless, but wait and see - it's nice. Here's how you declare a partial method:

    // the code generated part public partial class MyPartialClass {
        partial void DoIt(int x);
    }

You can then implement it in another file like so:

    // the hand-written part partial class MyPartialClass {
        partial void DoIt(int x)
        {
            throw new NotImplementedException();
        }
    }

This is all a little abstract, right now, so let's see how we can use this to implement a state machine framework. First we need a way to define a state machine. I'm going to use a simple XML file for this:

    <?xml version="1.0" encoding="utf-8" ?> <StateModels> <StateModel ID="My" start="defcon1"> <States> <State ID="defcon1" name="defcon1"/> <State ID="defcon2" name="defcon2"/> <State ID="defcon3" name="defcon3"/> </States> <Inputs> <Input ID="diplomaticIncident" name="diplomaticIncident"/> <Input ID="assassination" name="assassination"/> <Input ID="coup" name="coup"/> </Inputs> <Transitions> <Transition from="defcon1" to="defcon2" on="diplomaticIncident"/> <Transition from="defcon2" to="defcon3" on="assassination"/> <Transition from="defcon3" to="defcon1" on="coup"/> </Transitions> </StateModel> </StateModels>

Here we have a really simple state machine with three states (defcon1, defcon2 and defcon3) as well as three kinds of input (diplomaticIncident, assassination and coup). Please excuse the militarism - I just finished watching a season of 24, so I'm all hyped up. This simple model also defines three transitions. it creates a model like this:

Microsoft released the Text Template Transformation Toolkit (T4) system with Visual Studio 2008. This toolkit has been part of GAT and DSL tools in the past, but this is the first time that it has been available by default in VS. It allows an ASP.NET syntax for defining templates. Here's a snippet from the T4 template that generates the state machine:

    <#@ template language="C#" #>
    <#@ assembly name="System.Xml.dll" #>
    <#@ import namespace="System.Xml" #>

    <#
        XmlDocument doc = new XmlDocument();
        doc.Load(@"TestHarness\model.xml");
        XmlElement xnModel = (XmlElement)doc.SelectSingleNode("/StateModels/StateModel");
        string ns = xnModel.GetAttribute("ID");
        XmlNodeList states = xnModel.SelectNodes("descendant::State");
        XmlNodeList inputs = xnModel.SelectNodes("descendant::Input");
        XmlNodeList trns = xnModel.SelectNodes("descendant::Transition");
        #>
    using System;
    using System.Collections.Generic;

    namespace <#=ns#> {
    public enum <#=ns#>States : int{
    <#
    string sep = "";
    foreach(XmlElement s in states)
        {
        Write(sep + s.GetAttribute("ID"));
        WriteLine(@"// " + s.GetAttribute("name"));
        sep = ",";
        }

    #>
    } // end enum <#=ns#>States

    public enum <#=ns#>Inputs : int{
    <#
    sep = "";
    foreach(XmlElement s in inputs)
        {
        Write(sep + s.GetAttribute("ID"));
        WriteLine(@"// " + s.GetAttribute("name"));
        sep = ",";
        }

    #>
    } // end enum <#=ns#>States

    public partial class <#=ns#>StateModel{

            public <#=ns#>StateModel()
            {
                SetupStates();
                SetupTransitions();
                SetStartState();
            }
    ...

Naturally, there's a lot in the template, but we'll get to that later. First we need a representation of a state. You'll see from the template that an enum get's generated called \<\#=ns\#\>States. Here's what it looks like for the defcon model.

    public enum MyStates : int {
    defcon1// defcon1 ,defcon2// defcon2 ,defcon3// defcon3 } // end enum MyStates

This is still a bit too bare for my liking. I can't attach an event model to these states, so here's a class that can carry around one of these values:

    public class State {
        public int Identifier { get; set; }
    public delegate void OnEntryEventHandler(object sender, OnEntryEventArgs e);
        // ...public event OnEntryEventHandler OnEntryEvent;
        // ...}

There's a lot left out of this, but the point is that as well as storing an identifier for a state, it has events for both entry into and exit from the state. This can be used by the event framework of the state machine to provide hooks for your custom state transition and entry code. The same model is used for transitions:

    public class StateTransition {
        public State FromState { get; set; }
        public State ToState { get; set; }
    public event OnStateTransitioningEventHandler OnStateTransitioningEvent;
    public event OnStateTransitionedEventHandler OnStateTransitionedEvent;
    }

Here's the list of inputs that can trigger a transition between states:

    public enum MyInputs : int {
    diplomaticIncident// diplomaticIncident ,assassination// assassination ,coup// coup } // end enum MyStates

The template helps to define storage for the states and transitions of the model:

    public static Dictionary<<#= ns#>States, State> states                = new Dictionary<<#= ns#>States, State>();
    public static Dictionary<string, StateTransition> arcs                = new Dictionary<string, StateTransition>();
    public State CurrentState { get; set; }

which for the model earlier, will yield the following:

    public static Dictionary<MyStates, State> states = new Dictionary<MyStates, State>();
    public static Dictionary<string, StateTransition> arcs = new Dictionary<string, StateTransition>();
    public State CurrentState { get; set; }

Now we can create entries in these tables for the transitions in the model:

    private void SetStartState()
    {
        CurrentState = states[<#= ns#>States.<#=xnModel.GetAttribute("start")#>];
    }

    private void SetupStates()
    {
    <#
    foreach(XmlElement s in states)
        {
        WriteLine("states[" + ns + "States."+s.GetAttribute("ID")+"] =               new State { Identifier = (int)"+ns+"States."+s.GetAttribute("ID")+" };");
        WriteLine("states[" + ns + "States."+s.GetAttribute("ID")+"].OnEntryEvent               += (x, y) => OnEnter_"+s.GetAttribute("ID")+"();");
        WriteLine("states[" + ns + "States."+s.GetAttribute("ID")+"].OnExitEvent               += (x, y) => OnLeave_"+s.GetAttribute("ID")+"(); ;");
        }
    #>
    }
    private void SetupTransitions()
    {
    <#
    foreach(XmlElement s in trns)
        {
        #>
        arcs["<#=s.GetAttribute("from")#>_<#=s.GetAttribute("on")#>"] = new StateTransition
        {
            FromState = states[<#= ns#>States.<#=s.GetAttribute("from")#>],
            ToState = states[<#= ns#>States.<#=s.GetAttribute("to")#>]
        };
        arcs["<#=s.GetAttribute("from")#>_<#=s.GetAttribute("on")#>"].OnStateTransitioningEvent              += (x,y)=>MovingFrom_<#=s.GetAttribute("from")#>_To_<#=s.GetAttribute("to")#>;
        arcs["<#=s.GetAttribute("from")#>_<#=s.GetAttribute("on")#>"].OnStateTransitionedEvent              += (x,y)=>MovedFrom_<#=s.GetAttribute("from")#>_To_<#=s.GetAttribute("to")#>;
        <#
        }
        #>
    }

which is where the fun starts. First notice that we create a new state for each state in the model and attach a lambda to the entry and exit events of each state. For our model that would look like this:

    private void SetupStates()
    {
        states[MyStates.defcon1] = new State {Identifier = (int) MyStates.defcon1};
        states[MyStates.defcon1].OnEntryEvent += (x, y) => OnEnter_defcon1();
        states[MyStates.defcon1].OnExitEvent += (x, y) => OnLeave_defcon1();

        states[MyStates.defcon2] = new State {Identifier = (int) MyStates.defcon2};
        states[MyStates.defcon2].OnEntryEvent += (x, y) => OnEnter_defcon2();
        states[MyStates.defcon2].OnExitEvent += (x, y) => OnLeave_defcon2();

        states[MyStates.defcon3] = new State {Identifier = (int) MyStates.defcon3};
        states[MyStates.defcon3].OnEntryEvent += (x, y) => OnEnter_defcon3();
        states[MyStates.defcon3].OnExitEvent += (x, y) => OnLeave_defcon3();
    }

For the Transitions the same sort of code gets generated, except that we have some simple work to generate a string key for a specific \<state, input\> pair. Here's what comes out:

    private void SetupTransitions()
    {
        arcs["defcon1_diplomaticIncident"] = new StateTransition {
                     FromState = states[MyStates.defcon1],
                     ToState = states[MyStates.defcon2]
                 };
        arcs["defcon1_diplomaticIncident"].OnStateTransitioningEvent                  += (x, y) => MovingFrom_defcon1_To_defcon2;
        arcs["defcon1_diplomaticIncident"].OnStateTransitionedEvent                 += (x, y) => MovedFrom_defcon1_To_defcon2;
        arcs["defcon2_assassination"] = new StateTransition {
                     FromState = states[MyStates.defcon2],
                     ToState = states[MyStates.defcon3]
                };
        arcs["defcon2_assassination"].OnStateTransitioningEvent                += (x, y) => MovingFrom_defcon2_To_defcon3;
        arcs["defcon2_assassination"].OnStateTransitionedEvent                += (x, y) => MovedFrom_defcon2_To_defcon3;
        arcs["defcon3_coup"] = new StateTransition {
                     FromState = states[MyStates.defcon3],
                     ToState = states[MyStates.defcon1]
               };
        arcs["defcon3_coup"].OnStateTransitioningEvent                += (x, y) => MovingFrom_defcon3_To_defcon1;
        arcs["defcon3_coup"].OnStateTransitionedEvent                += (x, y) => MovedFrom_defcon3_To_defcon1;
    }

You can see that for each state and transition event I'm adding lambdas that invoke methods that are also being code generated. these are the partial methods described earlier. Here's the generator:

    foreach(XmlElement s in states)
        {
        WriteLine("partial void OnLeave_"+s.GetAttribute("ID")+"();");
        WriteLine("partial void OnEnter_"+s.GetAttribute("ID")+"();");
        }
    foreach(XmlElement s in trns)
        {
        WriteLine("partial void MovingFrom_"+s.GetAttribute("from")+"_To_"+s.GetAttribute("to")+"();");
        WriteLine("partial void MovedFrom_"+s.GetAttribute("from")+"_To_"+s.GetAttribute("to")+"();");
        }

Which gives us:

    partial void OnLeave_defcon1();
    partial void OnEnter_defcon1();
    partial void OnLeave_defcon2();
    partial void OnEnter_defcon2();
    partial void OnLeave_defcon3();
    partial void OnEnter_defcon3();
    partial void MovingFrom_defcon1_To_defcon2();
    partial void MovedFrom_defcon1_To_defcon2();
    partial void MovingFrom_defcon2_To_defcon3();
    partial void MovedFrom_defcon2_To_defcon3();
    partial void MovingFrom_defcon3_To_defcon1();
    partial void MovedFrom_defcon3_To_defcon1();

The C\# 3.0 spec states that if you don't choose to implement one of these partial methods then the effect is similar to attaching a ConditionalAttribute to it - it gets taken out and no trace is left of it ever having been declared. That's nice, because for some state models you may not want to do anything other than make the transition.

We now have a working state machine with masses of extensibility points that we can use as we see fit. Say we decided to implement a few of these methods like so:

    public partial class MyStateModel {
        partial void OnEnter_defcon1()
        {
            Debug.WriteLine("Going Into defcon1.");
        }
        partial void OnEnter_defcon2()
        {
            Debug.WriteLine("Going Into defcon2.");
        }
        partial void OnEnter_defcon3()
        {
            Debug.WriteLine("Going Into defcon3.");
        }
    }

Here's how you'd invoke it:

    MyStateModel dfa = new MyStateModel();
    dfa.ProcessInput((int) MyInputs.diplomaticIncident);
    dfa.ProcessInput((int) MyInputs.assassination);
    dfa.ProcessInput((int) MyInputs.coup);

And here's what you'd get:

    Going Into defcon2.
    Going Into defcon3.
    Going Into defcon1.

There's a lot you can do to improve the model I've presented (like passing context info into the event handlers, and allowing some of the event handlers to veto state transitions). But I hope that it shows how the partials support in conjunction with T4 templates makes light work of this perennial problem. This could easily save you from writing thousands of lines of tedious and error prone boiler plate code. That for me is a complete no-brainer.

What I like about this model is the ease with which I was able to get code generation. I just added a file with extension '.tt' to VS 2008 and it immediately started generating C\# from it. All I needed to do at that point was load up my XML file and feed it into the template. I like the fact that the system is lightweight. There is not a mass of framework that takes over the state management, it's infinitely extensible, and it allows a very quick turnaround time on state model changes.

What do you think? How would you tackle this problem?
