---
title: A simple semantic web application in C#
date: 2007-04-13 16:37
author: Andrew Matthews
ignored-tags: C#, Computer Science, programming
slug: a-simple-semantic-web-application-in-c
status: published
---

\[digg=http://www.digg.com/programming/A\_simple\_semantic\_web\_application\_in\_C\]The
latest update of the [SemWeb](http://razor.occams.info/code/semweb/) library
from Josh Tauberer includes a C\# implementation of the
[Euler](http://www.agfa.com/w3c/euler/) reasoner. This reasoner is able to go
beyond simplistic RDFS reasoning – being able to navigate the class and property
relationships - to make use of rules. The ontology I've been using to get used
to coding in the framework models a simple state machine. The ontology couldn't
be simpler. Here's an [N3](http://www.w3.org/2000/10/swap/Primer.html) file that
declares the classes and their relationships.

```
@prefix daml:  . @prefix rdfs:  . @prefix owl:   . @prefix : .
#Classes :State a owl:Class;
daml:comment "states the system can be in";
daml:disjointUnionOf ( :S1 :S2 :S3 ).
:InputToken a owl:Class;
daml:comment "inputs to the system";
daml:disjointUnionOf ( :INil :I1 :I2 ).
:Machine a owl:Class. :System a owl:Class.
#properties :isInState rdfs:domain :Machine;
rdfs:range  :State;
owl:cardinality "1".
:hasInput rdfs:domain :System;
rdfs:range  :InputToken;
owl:cardinality "1".
#Instances :Machine1 a :Machine;
:isInState :S1.
:This a :System;
:hasInput   :INil.
```

As with any deterministic finite state [machine](http://aabs.wordpress.com/2007/01/16/342/), there are two key classes at work here. :State and :InputToken. State is a disjoint union of :S1, :S2 and :S3. That means that :S1 is not an :S2 or an :S3. If you don't specify such a disjunction, the reasoners cannot assume it – if there is no rule that says they are disjoint, the reasoner won't be able to assume they're different - just because Machine1 is in state S1, doesn't mean it isn't potentially in state S2 as well. You have to tell it that an S1 is not an S2. Pedantry is all-important in ontology design, and while I have gained a fair measure of it over the years as a defensive programmer I was shocked at the level of semantic support I get from the programming languages I use. OWL provides you with such a rich palette to work with, but less conventional support. It is kind of liberating to be designing class libraries in [OWL](http://www.w3.org/2004/OWL/) vs. OO languages. Kind of like when you go from DOS to Bash.

Anyway, the rules for this little ontology define a transition table for the state machine:

```
@prefix log:  . @prefix rdfs:  . @prefix owl:   . @prefix : .
#  ~> {
    :Machine1 :isInState  :S1. :This :hasInput :I1. } => {
    :Machine1 :isInState  :S1. :This :hasInput :INil. }.
#  ~> {
    :Machine1 :isInState  :S1. :This :hasInput :I2. } => {
    :Machine1 :isInState  :S2. :This :hasInput :INil. }.
#  ~> {
    :Machine1 :isInState  :S1. :This :hasInput :I3. } => {
    :Machine1 :isInState  :S3. :This :hasInput :INil.}.
```

I got into problems initially, since I thought about the problem from an
imperative programming perspective. I designed it like I was assigning values to
variables. That's the wrong approach – treat this as adding facts to what is
already known. So, rather than saying *if X, then do Y,* think of it as *if I
know X, then I also know that Y.* The program to work with it looks like this:

```
internal class Program {
    private static readonly string ontologyLocation = @"C:\dev\prototypes\semantic-web\ontologies\20074\states\";
    private static string baseUri = @"file:///C:/dev/prototypes/semantic-web/ontologies/2007/04/states/states.rdf#";
    private static MemoryStore store = new MemoryStore();
    private static Entity Machine1 = new Entity(baseUri + "Machine1");
    private static Entity Input1 = new Entity(baseUri + "I1");
    private static Entity Input2 = new Entity(baseUri + "I2");
    private static Entity theSystem = new Entity(baseUri + "This");
    private static string hasInput = baseUri + "hasInput";
    private static string isInState = baseUri + "isInState";
    private static void Main(string[] args) {
    InitialiseStore();
    DisplayCurrentStates();
    SetNewInput(Input2);
    DisplayCurrentStates();
}
private static void DisplayCurrentStates() {
    SelectResult ra = store.Select(new Statement(Machine1, new Entity(isInState), null));
    Debug.Write("Current states: ");
    foreach (Statement resource in ra.ToArray()) {
        Debug.Write(resource.Object.Uri);
    }
    Debug.WriteLine("");
}
private static void InitialiseStore() {
    string statesLocation = Path.Combine(ontologyLocation, "states.n3");
    string rulesLocation = Path.Combine(ontologyLocation, "rules.n3");
    Euler engine = new Euler(new N3Reader(File.OpenText(rulesLocation)));
    store.Import(new N3Reader(File.OpenText(statesLocation)));
    store.AddReasoner(engine);
}
private static void SetNewInput(Entity newInput) {
    Resource[] currentInput = store.SelectObjects(theSystem, hasInput);
    Statement input = new Statement(theSystem, hasInput, Input1);
    store.Remove(new Statement(theSystem, hasInput, currentInput[0]));
    store.Add(new Statement(theSystem, hasInput, newInput));
    Resource[] subsequentState = store.SelectObjects(Machine1, isInState);
    Statement newState = new Statement(Machine1, isInState, subsequentState[0]);
    store.Replace(new Statement(Machine1, isInState, null), newState);
} }
```

The task was simple – I wanted to set the state machine up in state :S1 with
input :INil, then put input :I1 in, and see the state change from :S1 to :S2. In
doing this I am trying to do something that is a little at odds with the
expressed intention of ontologies. They are more static declarations of a body
of knowledge as much as a specification for a dynamically changing body of
facts. What that means is that they are *additive* – the frameworks and
reasoners allow you to add to a body of knowledge. That makes reuse and trust
possible on the semantic
web\[[1](http://www.w3.org/TR/owl-semantics/rdfs.html),
[2](http://www.w3.org/DesignIssues/N3Logic)\]. If I can take your ontology and
change it to mean something other than what you intended then no guarantees can
be made about the result. The ontology should stand alone – if you want to base
some data on it, that's up to you, and you will have to manage it. In practical
terms, that means you have to manually change the entries for the input and the
states as they change. What the ontology adds is a framework for representing
the data, and a set of rules for working out what the next state should be.
That's still powerful, but I wonder how well it would scale.

### What to notice

There are a few things in here that you should pay very close attention to if
you want to write a semantic web application of your own using SemWeb. Firstly,
the default namespace definition in the ontology and rules definition files.
Generally, the examples of N3 files on the W3C site use the following format to
specify the default namespace of a file:

```
@prefix : <#>
```

Unfortunately that leaves a little too much room for manoeuvring within SemWeb,
and the actual URIs that it will use are a little unpredictable. Generally they
are based upon the location that SemWeb got the files from. Instead, choose a
URL like so:

[\@prefix : \<http://aabs.purl.org/ontologies/2007/04/states/states.rdf\#\>.
]{style="font-family:Courier New;font-size:10pt;"}

This was not the location of the file - it was just a URL I was using prior to
using N3 format. The point is that you just need to give an unambiguous URL so
that the semweb and its reasoner can distinguish resources properly, when you
ask it questions. I used the same URL in the rules.n3 file, since most of what I
was referring to was defined in the namespace above. I could just as easily have
defined a new prefix for states.n3 and prepended all the elements in the rules
with that prefix. The point is to have a non-default URL so that semweb is in no
doubt about what the URL of the resources are that you are referring to.

Next, remember that you will have to dip into the instances in the store to make
manual changes to their state – this is no different from any relational
database application. Although, I was disconcerted at first, because I had hoped
that the reasoner would make any changes I needed for me. Alas that is not in
the spirit of the semantic web apparently, so be prepared to manage the system
closely.

I think that the use of OWL ontologies would be very easy for question answering
applications, but there may be a little more work required to place a reasoner
at the core of your system. Of course, I could be wrong about that, and it could
be my incorrigable procedural mindset that is to blame – I will keep you posted.
I'll be posting more on this over the next few weeks, so if there are things you
want me to write about, or answers to questions you have, pllease drop me a line
or comment here, and I'll try to come up with answers.
