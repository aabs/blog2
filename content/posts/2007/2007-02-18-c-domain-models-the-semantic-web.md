---
title: C#, Domain Models & the Semantic Web
date: 2007-02-18 06:54
author: Andrew Matthews
ignored-tags: artificial intelligence, C#, Computer Science, LINQ, ORM, philosophy
slug: c-domain-models-the-semantic-web
status: published
---

I've recently been learning more about the [OWL](http://www.w3.org/2004/OWL/) web ontology language in an attempt to find a way to represent [SPARQL](http://www.w3.org/2001/sw/DataAccess/) queries in [LINQ](http://msdn2.microsoft.com/en-us/library/aa479865.aspx). SPARQL and LINQ are very different, and the systems that they target are also dissimilar. Inevitably, it's difficult to imagine the techniques to employ in translating a query from one language to the other without actually trying to implpement the LINQ extensions. I've got quite a long learning curve to climb. One thing is clear though: OWL, or some system very similar to it, is going to have a radical impact both on developers and society at large. The reason I haven't posted in the last few weeks is because I've been writing an article/paper for publication in some related journal.  I decided to put up the abstract and the closing remarks of the paper here, just so you can see what I'll be covering in more depth on this blog in the future: LINQ, OWL, & RDF.

PS: If you are the editor of a journal that would like to publish the article, please contact me by email and I'll be in touch when it's finished. As you will see, the article is very optimistic about the prospects of the semantic web (despite its seeming lack of uptake outside of academia), and puts forward the idea that with the right fusion of technologies and environments the semantic web will have an even faster and more pervasive impact on society than the world wide web. This is all based on the assumption that LINQ the query language is capable of representing the same queries as SPARQL.

The Abstract:

The software engineering industry is undergoing a reassessment of ORM systems. It is possible to foresee a coming revolution where object oriented systems are augmented by semantic web technologies to allow legacy systems to become more intelligent. It is possible to embed an object oriented domain model in an ontology and use an object/ontology mapping (OOM) to overcome the impedance mismatch that exists between the two realms. The article explores the possibility of augmenting an object model with RDF. Reasoners can at last be employed on domain models – a feat that hitherto has been impossible. Finally, for fun, we attempt to prognosticate on what semantic web technologies mean for the object and relational domains.

The Closing Remarks:

Recently, the demonstration of [D-Wave Systems’](http://www.dwavesys.com/) working quantum computer gave developers renewed hope for practical applications combining both semantic web technologies and quantum computing. The D-Wave computer was designed to solve problems equivalent to the graph matching algorithm at the heart of DL reasoner queries. Ontologies currently have to be designed in such a way as to guarantee a solution within the limitations of existing reasoners. What would be exponentially hard to solve using conventional von Neumann architectures may be entirely feasible on a quantum computer.

Imagine the prospect of being able to incorporate something like the Cyc ontology into your systems; to be able to ask useful but open-ended questions of your system without having to worry (too much) about the time taken to perform the query. Imagine being able to easily endow your applications with real-world insight that extends way beyond the narrow confines of the application at hand. Imagine being able to express business rules in their natural context – the business strategy. It would be a compelling commercial force for adoption of the semantic web. I imagine that in such a case developers would have less reason to cleave to relational databases with such fervour as at present.

Under these circumstances it’s hard to believe that the semantic web will not suffuse society as quickly as the World Wide Web. It’s also hard to see an aspect of society that won’t be radically overturned by a combination of easy semantic web queries, quantum computer based DL reasoners and the combination of detailed domain-level and broadly scoped real-world ontologies. The near term effect of semantic web technologies on developers will be the merest foreshadowing of the momentous effects on society generally. Truly, the semantic web will help to sustain and accelerate the Singularity.
