---
title: Relational Modeling? Not as we know it!
date: 2008-11-18 21:11
author: aabs
category: programming, Semantic Web
tags: databases, SemanticWeb, semweb
slug: relational-modeling-not-as-we-know-it
status: published
---

Marcello Cantos commented on my [recent post](http://aabs.wordpress.com/2008/09/23/object-orientation-not-as-we-know-it/) about the ways in which RDF can transcend the object-oriented model. He posed the question of what things RDF can represent more easily than the relational model. I know Marcello is a very high calibre software engineer, so it's not just an idle question from a relational dinosaur, but a serious question from someone who can push the envelope far with a relational database.

Since an ontology is most frequently defined (in compsci) as a [specification of a conceptualization](http://www-ksl.stanford.edu/kst/what-is-an-ontology.html), a relational model is a kind of ontology. That means a relational model is by definition a knowledge representation system. That'd be my answer if I just wanted to sidestep the real thrust of his question; *Is the relational model adequate to do what can be done by RDF*?

That's a more interesting question, and I'd be inclined to say everything I said in my previous post about the shortcomings of object oriented programming languages applies equally to the relational model. But lets take another look at the design features of RDF that make it useful for representation of 'knowledge'.

○ URI based
○ Triple format
○ Extensible
○ Layered
○ Class based
○ Meta-model

#### URI Based

By using URIs as a token of identification and definition, and by making identifications and definitions readable, interchangeable and reusable the designers of RDF exposed the conceptualisation of the ontology to the world at large. Could you imagine defining a customer in your database as '*everything in* *XYZ* *company's* *CRM's* *definition of a customer, plus a few special fields of our own*'. It is not practical. Perhaps you might want to say, *everything in their database less some fields that we're not interested in*. Again - not possible. Relational models are not as flexible as the concepts that they need to represent. That is also the real reason why interchange formats never caught on - they were just not able to adapt to the ways that people needed to use them. RDF is designed from the outset to be malleable.

#### Triple Format

At their foundation, all representations make statements about the structure or characteristics of things. All statements must have the form (or can be transformed into that format). The relational model strictly defines the set of triples that can be expressed about a thing. For example, imagine a table 'Star' that has some fields:

    Star (
        StarId INT,
        CommonName nvarchar(256),
        Magnitude decimal NOT NULL,
        RA decimal NOT NULL,
        DEC decimal NOT NULL,
        Distance decimal NOT NULL,
        SpectralType nvarchar(64)
        )

Now if we had a row

    (123, 'Deneb', 1.25, 300.8, 45.2, 440, 'A2la')

That would be equivalent to a set of triples represented in N3 like this:

    []
      StartId 123;
      CommonName "Deneb";
      Magnitude 1.25^xsd:decimal;
      RA 300.8^xsd:decimal;
      DEC 45.2^xsd:decimal;
      Distance 440^xsd:decimal;
      SpectralType "A2la" .

Clearly there's a great deal of overlap between these two systems and the one is convertible into the other. But what happens when we launch a new space probe capable of measuring some new feature of the star that was never measurable before? Or what happens when we realise that to plot our star very far into the future we need to store radial velocity, proper motion and absolute magnitude. We don't have fields for that, and there's no way in the database to add them without extensive modifications to the database.

RDF triple stores (or runtime models or files for that matter) have no particular dependence on the data conforming to a prescribed format. More importantly class membership and instance-hood are more decoupled so that a 'thing' can exist without automatically being in a class. In OO languages you MUST have a type, just as in RDBMSs, a row MUST come from some table. We can define an instance that has all of the properties defined in table 'Star' plus a few others gained from the Hipparchos catalog and a few more gleaned from the Tycho-1 catalog. It does not break the model nor invalidate the 'Star' class-hood to have this extra information, it just happens that we know more about [Deneb](http://en.wikipedia.org/wiki/Deneb) in our database than some other stars.

This independent, extensible, free-form, standards-based language is capable of accommodating any knowledge that you can gather about a thing. If you add meta-data about the thing then more deductions can be made about it, but its absence doesn't stop you from adding or using the data in queries.

#### Extensible, Layered, Class Based with Meta-model

Being extensible, in the case of RDF, means a few things. It means that RDF supports OO-style multiple inheritance relationships. See my previous post to see that this is the tip of the iceberg for RDF class membership. That post went into more detail about how class membership was not based on some immutable Type property that once assigned can never by removed. Instead it, can be based on more or less flexible criteria.

Extensibility in RDF also means providing a way to make complex statements about the modelling language itself. For example once the structure of triples is defined (plus URIs that can be in subjects, predicates or objects) in the base RDF language, then RDF has a way to define complex relationships. The language was extended with RDF Schema which in turn was extended with several layers in OWL, which will in turn be extended by yet more abstract layers.

Is there a mechanism for self reference in SQL? I can't think of a way of defining one structure in a DB in terms of the structure of another. There's no way that I can think of of being explicit about the nature of the relationship between two entities. Is there a way for you to state in your relational model facts like this:

    {?s CommonName ?c.} => {?s Magnitude ?m. ?m greaterThan 6.}

i.e. if it has a common name then it must be visible to the naked eye. I guess you'd do that with a relational view so that you could query whether the view 'nakedEyeStars' contains star 123. Of course CommonName could apply to botanical entities (plants) as well as to stars, but I imagine you'd struggle to create a view that merged data from the plant table and the star table.

So, in conclusion, there's plenty of ways that RDF specifically addresses the problems it seeks to address - data interchange, standards definition, KR, mashups - in a distributed web-wide way. RDBMSs address the problems faced by programmers at the coal face in the 60s and 70s - efficient, standardized, platform-independent data storage and retrieval. The imperative that created a need for RDBMSs in the 60s is not going away, so I doubt databases will be going away any time soon either. In fact they can be exposed to the world as triples without too much trouble. The problem is that developers need more than just data storage and retrieval. They need *intelligent* data storage and retrieval.
