---
title: Truly abstracting a persistence mechanism
date: 2005-07-31 18:46
author: Andrew Matthews
ignored-tags: ORM
slug: truly-abstracting-a-persistence-mechanism-2
status: published
---

The initial design that I used when I made the ancestor of norm was based upon designs by Scott Ambler - The initial intent of Ambler's designs was definitely to provide an abstraction around the logic of a relational database. What I want to do with norm is to abstract the very notion of a data structure. When we persist an object into a row on a RDB it is almost irrelevant that the data is persistent. Of course its not truly irrelevant, else why bother at all? What I mean is that the persistence of the data store in an RDB is irrelevant - it's the concepts that are used that make ORM such a complicated enterprise, the notion of a relationship is subtly different from that used in the object domain. Therein lies the "object/relational impedance mismatch" that Ambler identifies in his hugely influential paper, *[the design of a robust persistence layer for relational databases](http://www.ambysoft.com/downloads/persistenceLayer.pdf)*.

[![](http://photos1.blogger.com/blogger/6860/929/320/persMech.jpg)](http://photos1.blogger.com/blogger/6860/929/1600/persMech.jpg)

As you can see the persistence mechanism is deliberately kept very simple, since there is little in the way of overlap (conceptually) between the APIs for a flat file persistence store and a relational database. In fact the notion of connection means different things in each mechanism.

So what I'm after is a way to bridge the gap between persistence stores so that mappings can be made between two different object models as easily as they can between object models and relational databases. What I'm wondering is whether Ambler's model is the right one to use for such an abstraction. My first task is to purge any domain pollution from the mapping system, the transaction manager and the command system.

My initial system was a very close parallel to Ambler's designs. But now I'm looking to diverge in the hope of a cleaner conceptual model. What most ORM systems do is to define a invertible function between the object domain and the relational domain. I propose to do the same thing, but I want to do it in a non-explicit way.

Normally the mapping is done by enumerating the domain set (the object domain normally), enumerating the range set (the relational model) and then defining the mappings between them. If you look closely at the mapping file formats for persistence mechanisms such as Torque, Hibernate, ObjectSpaces and norm's predecessor, they all followed this idiom using XML configuration files to define the mapping, and an in-memory model to serve as a runtime aid to the persistence broker to build its SQL commands.

That has to be the way of doing it ultimately, but I wonder whether we can't define the mapping in another way, rather like the difference between defining a set using an enumeration of all of its members or through the definition of a generative function that maps onto the set. i.e. Rather than say:

x = {2, 4, 6, 8}

we could say

x = {2i where i \> 0 & i \< 5}

It's definitely more complicated than explicitly enumerating the mappings, but might enable the easy solution of mappings in the case of inheritance where there are several solutions that all work.

To do this conceptual mappings we need to work out what the key abstractions that define the mapping functions:

-   whole/part relationship
-   complex type
-   association
-   CRUD operation
-   is-a relationship

Each of these things are present in every representation that I am considering. They exist in RDBMSs, object databases, and XML documents (i.e. a flat file, kinda:) But how they are represented and realized is vastly different between each of these technologies.

I wonder, and that's all I've done so far, whether if we defined how the underlying concept is laid out in each case we could do the mapping by specifying how that meaning was projected onto the concepts of the problem domain. Maybe I could perform the mapping by saying that this groups of concepts is achieved using this kind of mapping, and maybe the ORM can deduce the rest.

Of course, proper naming strategies in each domain dictate different names, and they are seldom held to consistently, so short of naming the attributes exhaustively there is no way of doing the mapping. So is it worth my time? Or am I just proposing a slight change of terminology so as not to give away the format of the persistence mechanism?
