---
title: Semantic Development Environments
date: 2008-08-22 21:06
author: aabs
category: .NET, Semantic Web
tags: GGG, ideas, lintordf, programming, SemanticWeb, venture altruism, web3.0
slug: semantic-development-environments
status: published
---

The semantic web is a GOOD THING by definition - anything that enables us to create smarter software without also having to create Byzantine application software must be a step in the right direction. The problem is - many people have trouble translating the generic term "smarter" into a concrete idea of what they would have to do to achieve that palladian dream. I think a few concrete ideas might help to firm up people's understanding of how the semantic web can help to deliver smarter products.

**Software Development as knowledge based activity
**

In this post I thought it might be nice to share a few ideas I had about how [OWL](http://www.w3.org/2004/OWL/) and [SWRL](http://www.w3.org/Submission/2004/03/) could help to produce smarter software development environments. If you want to use the ideas to make money, feel free to do so, just consider them as released under the [creative commons attribution license](http://creativecommons.org/licenses/by/3.0/). Software development is the quintessential knowledge based activity. In the process of producing a modern application a typical developer will burn through knowledge at a colossal rate. Frequently, we will not reserve headspace for a lot of the knowledge we acquire to solve a task. Frequently, we bring together the ideas, facts, standards, API skills and problem requirements needed to solve a problem then just as quickly forget it all. The unique combination is never likely to arise again.

I'm sure we could make a few comments about how it's more important to know where the information is than to know what it is - a fact driven home to me by my Computer Science lecturer [John English](http://www.cmis.brighton.ac.uk/staff/je/), who seemed to be able to remember the contents page of every copy of the Proceedings of the ACM back to the '60s. You might also be forgiven for thinking this wasn't true , given the current obsession with certifications. We could also comment about how some information is more lasting than others, but my point is that every project these days seems to combine a mixture of ephemera, timeless principles and those bits that lie somewhere between the two (called 'Best Practice' in current parlance ;).

**Requires cognitive assistance**
Software development, then, is a knowledge intensive activity that brings together a variety of structured and unstructured information to allow the developer to produce a system that they endeavor to show is equivalent to a set of requirements, guidelines, nuggets of wisdom and cultural mores that are defined or mandated at the beginning of the project. Doesn't this sound to you like exactly the environment for which the semantic web technology stack was designed?

Incidentally, the following applications don't have much to do with the web, so perhaps they demonstrate that the term 'Web 3.0' is limiting and misleading. It’s the synergy of the complementary standards in the semantic web stack that makes it possible to deliver smarter products and to boost your viability in an increasingly competitive market place.

**Documentation
**

OK, so the extended disclaimer/apology is now out of the way and I can start to talk about how the semantic web could offer help to improve the lives of developers. The first place I'll look is at documentation. There are many types of documentation that are used in software development. In fact, there is a different form of documentation defined for each specific stage of the software lifecycle from conception of an idea through to its realization in code (and beyond). Each of these forms of documentation is more or less formally structured with different kinds of information related to documents and other deliverables that came before and after. This kind of documentation is frequently ambiguous, verbose and often gets written for the sake of compliance and then gets filed away and never sees the light of day again. Documentation for software projects needs to be precise, terse, rich and most of all useful.

*Suggestion 1.*

Use ontologies (perhaps standardised by the OMG) for the production of requirements. Automated tools could be used to convert these ontologies into human-readable reports or tools could be used to answer questions about specific requirements. A reasoner might be able to deduce conflicts or contradictions from a set of requirements. It might also be able to offer suggestions about implementations that have been shown to fulfill similar requirements in other projects. Clearly, the sky's the limit in how useful an ontology, reasoner and rules language could be. It should also help documentation to be much more precise and less verbose. There is also scope for documentation reuse, specialization and for there to be diagramming and code generation driven off of documentation.

Documentation is used heavily inside the source code used by developers to write software too. It serves to provide an explanation for the purpose of a software component, to explain how to use it, to provide change notes, to generate API documentation web-sites, and to even store to-do list items or apologies for later reference. In .NET and Java, and now many other programming languages, it is common to use formal languages (like XML markup) to provide commonly used information. An ontology might be helpful in providing a rich and extensible language for representing code documentation. The use of URIs to represent unique entities means that the documentation can be the subject or other documents and can reach out to the wider ecology of data about the system.

*Suggestion 2.*

Provide an extensible ontology to allow the linkage of code documentation with the rest of the documentation produced for a software system. Since all parts of the software documentation process (being documented in RDF) will have unique URIs, it should be easy to link the documentation for a component to the requirements, specifications, plans, elaborations, discussions, blog posts and other miscellanea generated. Providing semantic web URIs to individual code elements helps to integrate the code itself into other semantic systems like change management and issue tracking systems. Use of URIs and ontologies within source code helps to provide a firm, rich linkage between source code and the documentation that gave rise to it.

*Suggestion 3.*

Boosted with richer, extensible markups to represent the meaning and wider documentation environment means that traditional intellisense can be augmented with browsers that provide access to all other pertinent documentation related to a piece of code. Imagine hovering over an object reference and getting links not only to a web site generated from the code commentary but to all the requirements that the code fulfills, to automated proofs demonstrating that the code matches the requirements, to blog posts written by the dev team and to MP3s taken during the brainstorming and design sessions during which this component was conceived.

It doesn't take much imagination to see that some simple enhancements like these can provide a ramp for the continued integration of the IDE, allowing smoother cooperation between teams and their stakeholders. Making documentation more useful to all involved would probably increase the chances that people would give up Agile in favour of something less like the emperor's clothes.

*Suggestion 4.*

Here's some other suggestions about how documentation in the IDE could be enriched.
○ Guidelines on where devs should focus their attention when learning a new API
○ SPARQL could be exposed by code publisher
§ Could provide a means to publish documentation online
○ Automatic publishing of DOAP documents to an enterprise or online registry, allowing software registries.

**Dynamic Systems**

Augmenting the source code of a system with URIs that can be referenced from anywhere opens the semantic artifacts inside an application to analysis and reference from outside. Companies like Microsoft have already described their visions for the production of documentation systems that allow architects to describe how a system hangs together. This information can be used by other systems to deploy, monitor, control and scale systems in production environments.

I think that their vision barely glimpses what could be achieved through the use of automated inference systems, rich structured machine readable design documentation, and systems that are for the first time white boxes. I think that DSI-style declarative architecture documents are a good example of what might be achieved through the use of smart documentation. There is more though.

*Suggestion 5.*

Reflection and other analysis tools can gather information about the structure, inter-relationships and external dependencies of a software system. Such data can be fed to an inference engine to allow it to make comparisons about the runtime behavior of a production system. Rules of inference can help it to determine what the consequences of violating a rule derived from the architect or developers documentation. Perhaps it could detect when the system is misconfigured or configured in a way that will force it to struggle under load. Perhaps it can find explanations for errors and failures. Rich documentation systems should allow developers to indicate deployment guidelines (i.e. this component is thread safe, or is location independent and scalable). Such documentation can be used to predict failure modes, to direct testing regimes and to predict optimal deployment patterns for specific load profiles.

**Conclusions**

I wrote this post because I know I'll never have time to pursue these ideas, but I would dearly love to see them come to pass. Why don't you get a copy of LinqToRdf, crack open a copy of Coco/R and see whether you can implement some of these suggestions. And if you find a way to get rich doing it, then please remember me in your will.
