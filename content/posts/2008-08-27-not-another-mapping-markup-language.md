---
title: Not another mapping markup language!
date: 2008-08-27 14:03
author: aabs
category: .NET, programming, Semantic Web
tags: C#, databases, Java, LINQ, LinqToRdf, mapping, mashups, ORM, RDB2RDF, SemanticWeb, semweb, web3.0
slug: not-another-mapping-markup-language
status: published
---

Kingsley Idehen has again graciously given LinqToRdf some much needed [link-love](http://kidehen.typepad.com/kingsley_idehens_typepad/2008/08/virtuoso-linked.html). He mentioned it in a post that was primarily concerned with the issues of mapping between the ontology, relational and object domains. His assertion is that LinqtoRdf, being an offshoot of an ORM related initiative, is reversing the natural order of mappings. He believes that in the world of ORM systems, the emphasis should be in mapping from the relational to the object domain.

I think that he has a point, but not for the reason he's putting forward. I think that the natural direction of mapping stems from the relative richness of the domains being mapped. The impedence mismatch between the relational and object domains stems from (1) the implicitness of meaning in the relationships of relational systems and (2) the representation of relationships and (3) type mismatches.

If the object domain has great expressiveness and explicit meaning in relationships it has a 'larger' language than that expressible using relational databases. Relationships are still representable, but their meaning is implicit. For that reason you would have to confine your mappings to those that can be represented in the target (relational) domain. In that sense you get a priority inversion that forces the lowest common denominator language to control what gets mapped.

The same form of inversion occurs between the ontological and object domains, only this time it is the object domain that is the lowest common denominator. OWL is able to represent such things as restriction classes and multiple inheritance and sub-properties that are hard or impossible to represent in languages like C\# or Java. When I heard of the RDF2RDB working group at the W3C, I suggested (to thunderous silence) that they direct their attentions to coming up with a general purpose mapping ontology that could be used for performing any kind of mapping.

I felt that it would have been extremely valuable to have a standard language for defining mappings. Just off the top of my head I can think of the following places where it would be useful:

1.  Object/Relational Mapping Systems (O/R or ORM)
2.  Ontology/Object Mappings (such as in LinqToRdf)
3.  Mashups (merging disparate data sources)
4.  Ontology Reconciliation - finding intersects between two sets of concepts
5.  Data cleansing
6.  General purpose data access layer automation
7.  Data export systems
8.  Synchronization Systems (i.e. keeping systems like CRM and AD in sync)
9.  mapping objects/tables onto UIs
10. etc

You can see that most of these are perennial real-world problems that programmers are ALWAYS having to contend with. Having a standard language (and API?) would really help with all of these cases.

I think such an ontology would be a nice addition to OWL or RDF Schema, allowing a much richer definition of equivalence between classes (or groups or parts of classes). Right now one can define a one-to-one relationship using the owl:equivalentClass property. It's easy to imagine that two ontology designers might approach a domain from such orthogonal directions that they find it hard to define any conceptual overlap between entities in their ontologies. A much more complex language is required to allow the reconciliation of widely divergent models.

I understand that by focusing their attentions on a single domain they increase their chances of success, but what the world needs from an organization like the W3C is the kind of abstract thinking that gave rise to RDF, not another mapping markup language!

------------------------------------------------------------------------

Here's a nice picture of how LinqToRdf interacts with Virtuoso (thanks to Kingsley's blog).

\[caption id="" align="aligncenter" width="770" caption="How LINQ uses LinqToRdf to talk to SPARQL stores"\][![How LINQ uses LinqToRdf to talk to SPARQL stores](http://virtuoso.openlinksw.com/Whitepapers/html/linqtordf/linqtordf2.png){width="770" height="709"}](http://kidehen.typepad.com/kingsley_idehens_typepad/2008/08/virtuoso-linked.html)\[/caption\]
