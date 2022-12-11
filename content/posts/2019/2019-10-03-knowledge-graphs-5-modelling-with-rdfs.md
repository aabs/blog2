---
title: Knowledge Graphs 5 - Modelling with RDFS
date: 2019-10-03 12:02
author: aabs
category: programming
ignored-tags: knowledge graphs, modelling, RDF, Semantic Web
slug: knowledge-graphs-5-modelling-with-rdfs
status: published
attachments: 2019/10/edvard-alexander-rolvaag-e75zuaipczo-unsplash.jpg
---

This installment moves beyond the simple graph model of RDF to introduce the
modelling support of RDF Schema. I will go on to show you how using the W3C
Standard RDFS imbues your data with another layer of meaning, and makes it
easier for you to enrich your raw data with meaning over time.




This is part 5 of an ongoing series providing a little background on ‘*knowledge graphs*‘. The aim is to let software developers get up to speed as fast as possible. No theory, no digressions, and no history, just practical knowledge.

-   [Knowledge Graphs 101](https://andrewmatthews.blog/2019/09/12/knowledge-graphs-101/)
-   [Knowledge Graphs 2 – Playing on the CLI](https://andrewmatthews.blog/2019/09/13/knowledge-graphs-2-playing-on-the-cli/)
-   [Knowledge Graphs 3 – Using a Triple Store](https://andrewmatthews.blog/2019/09/13/knowledge-graphs-3-using-a-triple-store/)
-   [Knowledge Graphs 4 – Querying your knowledge graph using .NET](https://andrewmatthews.blog/2019/09/16/knowledge-graphs-4-querying-your-knowledge-graph-using-net/)
-   [Knowledge Graphs 5 – Modelling with RDFS](https://andrewmatthews.blog/2019/10/03/knowledge-graphs-5-modelling-with-rdfs/)
-   [Knowledge Graphs 6 - Semantics](https://andrewmatthews.blog/2019/10/03/knowledge-graphs-6-semantics/)
-   [Knowledge Graphs 7 - Named graphs](https://aabs.wordpress.com/2019/11/06/knowledge-graphs-7-named-graphs/)

First let's have a recap then take a look at the basics of modelling.

Recap - The RDF Graph Model
---------------------------

Just to remind you of how low-level the foundations are, let's review what bare RDF is made up of.

The RDF model consists of only a few basic ideas. RDF allows you to build a graph using *Triples*. Each triple is an *edge* of the directed graph, where the identifier of each vertice and edge is a Uri. The three components of the edge of the graph are used to make statements: Subject, Predicate and Object. The subject is the primary *thing *that you are making a statement about - that's the *from vertex*. The Object is something that you are *relating *to the Subject - the *to vertex.* The Predicate - the *edge* itself - is *how *you relate the Subject and Object.

Triples forming a graph are stored in a kind of database called a '*Triple Store*'. A triple store allows you to store multiple graphs of triples, each of which is, of course, identified by a URI. So to be properly accurate, each triple is really a quadruple - one URI for the graph ID, plus one each for the subject, predicate and object.

Modelling in RDF
----------------

So far I have introduced how to capture some knowledge in your RDF graph, but what we have so far falls a long way short of how we think about the world. So RDF on its own is insufficient. A key extension for representing real-world concepts comes with the RDF Schema (RDFS) standard. It introduce two key ideas; the *Class* and the *Property*.

Those coming from a software development background, will probably have an intuitive grasp of the concept of a '*class*'. According to the dictionary, a class is defined as

> A set or category of things having some properties or attributes in common
>
> Oxford English Dictionary.

Similarly, a set is any group or collection of entities that can be considered as a single unit. In practice I tend to think of a set as any collection that I can conceive of, and give a name to, regardless of whether they have properties defined or not. And that's the point. Being able to give a name to some set of things is the act of assigning a Uri to denote them. Assigning properties comes at a later stage.

Solidifying this idea is the purpose of [RDF Schema](https://www.w3.org/TR/rdf-schema/). It provides ways to define classes and subclasses, and declare membership of them. It also provides a way to describe the defining properties of a class.

Defining Classes
----------------

Since a class or set is the fundamental unit of abstraction, it is also the primary building block in a model. Let's see how to define some classes:

```
:Vehicle rdf:type rdfs:Class .
:Car rdfs:subClassOf :Vehicle .
:Sled rdfs:subClassOf :Vehicle .
```

I can then define instances of the class like so:

```
:MyCar2 rdf:type :Car .
:YourSled rdf:type :Sled .
```

So essentially, there's an innate hierarchy at work. You declare an instance of a class through the  `rdf:type` predicate. But when you declare a thing as an instance of a  `rdfs:Class` then you are actually declaring a class that other things can be instances of.

Class definition and membership would be of little value without subset or subclass hierarchies. The  `rdfs:subClassOf` predicate allows you to coin a new class based on a subset of some super class. For example, I defined  `:Car` as a subclass of  `:Vehicle `. Later on, I declare  `:MyCar2` to be an instance of  `:Car `.

As a software developer this all seems so basic I feel I should apologise, but bear with me - I promise to sail out into uncharted waters soon. After all, the good folks at the W3C didn't stop here - they kept on building.

Defining Properties
-------------------

Part of the definition of Class I cited above was the *defining properties or attributes.* RDF Schema allows us to define properties, and later on I will show you how we can use those properties as *defining characteristics.*

Since a car is usually build from a modular arrangement of sub-parts, let's model it's engine accordingly. First I want to break down the vehicle class hierarchy a little more.

```
:Vehicle a rdfs:Class.
:SelfPropelledVehicle rdfs:subClassOf :Vehicle .
:Car rdfs:subClassOf :SelfPropelledVehicle .
:MyCar2 a :Car .

:engine a rdf:Property;
    rdfs:domain :SelfPropelledVehicle;
    rdfs:range :Engine .
```

In my grossly simplistic world, there are no such things as sails. Anything that is self propelled must have an engine of some sort. Being an instance of  `rdf:Property` means that  `:engine` is a predicate that joins some subject and another object. In this case will join some sort of self propelled vehicle and an instance of an engine. You would use it like this:

```
:engine2 a :Engine .
:MyCar2 :engine :engine2 .
```

An engine in turn may have further properties, and so on.

```
:cylinders a rdf:Property;
    rdfs:range xsd:integer;
    rdfs:domain :Engine .

:engine2 :cylinders 6 .
```

I don't have to supply the  `rdfs:domain` if it makes sense to be able to apply a predicate to instances of many different sets.

```
:cost rdfs:range xsd:integer .
:engine2 :cost 2000 .
```

As I mentioned, earlier in this series, the object of a triple can be a resource node or a literal. By defining the  `rdfs:range` as an instance of  `rdfs:Class `, I'm restricting the Object's URIs to only those of instances of the range class. When I reference a datatype from XSD, however, I am restricting to literals of a specific datatype.

Subproperties
-------------

One cool modelling feature of RDFS is that, in addition to class hierarchies, it allows the definition of property hierarchies also. This is a feature that is wholly absent from the world of object orientation. You might think that since it is absent, it must be non-essential or obscure somehow, yet that couldn't be further from the truth. In fact, every day we use super and sub properties without ever thinking about it.

Let's first show the *hello world* of subproperties.

```
:isSpouseOf rdfs:domain :Person;
    rdfs:range :Person .

:isWifeOf rdfs:subPropertyOf :isSpouseOf;
    rdfs:domain :Woman .

:alice :isWifeOf :john .
```

We intuitively know that if you are the wife of someone, you are their spouse. Wife is a restricted version of spouse for the case when the domain is women. Similarly, we could do the same thing with  `:isHusbandOf` restricting the domain to  `:Man `. Shortly, I will show you that this is of more that theoretical interest. For now, let's look at some other variations.

Another commonly shown case, of sub propertyhood is the relation between  `:parent` and  `:ancestor` - if you are my parent, you are my ancestor, but if you are my ancestor, you are not necessarily my parent.

Finally, here's an example from cars.  `:isComprisedOf` is assumed when we provide some properties, but not others:

```
:isComprisedOf a rdf:Property .
:engine rdfs:subPropertyOf :isComprisedOf .
```

This is a slightly less obvious relationship, yet if you say that the car has an engine, then it is at least comprised of that engine, as well as any other parts it includes. This is a powerful capability to make use of.

### Reinterpreting Data

Often we can transmute base metals into gold, by re-interpreting something humble to mean something deeper or of more lasting significance. This actually happens all the time these days, when organisations use low level signals to signify the occurrence of high-level business events. For example, in the super industry, the occurrence of a low level log file entry might be re-interpreted in several ways:

```
WWW Logs contained HTTP 200 Status Code for login page
|-> User successfully authenticated on our web site
    |-> User visited our web site
        |-> The user is an Engaged User
            |-> The user should be targeted by marketing
```

Cynical as this sounds, it is a sound piece of reasoning in the superannuation industry where customers ignore the websites of their super funds for years at a time. Other companies will use this kind of reinterpretation of data to bootstrap event sourced systems by deducing business domain events from low level audit log entries.

The point of this digression, is that sub properties enable a similar sort of reinterpretation of the data and the relationships between resources after the fact, allowing data to be turned into *intelligence.*

Summary
-------

This time round I introduced you to the powerful tools for modelling provided by RDF Schema. In later installments I will introduce the capabilities of OWL2, which makes the capabilities of RDFS (an object orientation as well) seem rather weak.

I briefly touched on how we can reinterpret data through some of the more powerful modelling capabilities of RDFS. Next time I will show how the use of entailment and reasoners allow us to materialise some of the alternate means that are latent in our data. That promises to be a lot of fun, but till then, please let me know in the comments if you have any questions, thoughts or suggestions.
