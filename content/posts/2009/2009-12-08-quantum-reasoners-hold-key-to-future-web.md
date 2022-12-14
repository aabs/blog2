---
title: Quantum Reasoners Hold Key to Future Web
date: 2009-12-08
author: Andrew Matthews
category: Semantic Web
ignored-tags: artificial intelligence, RDF, science, SemanticWeb, semweb, software, web3.0
slug: quantum-reasoners-hold-key-to-future-web
status: published
---

Last year, a company called [DWave Systems](http://www.dwavesys.com/) announced their quantum computer (the 'Orion') - another milestone on the road to practical quantum computing. Their [controversial](http://dwave.wordpress.com/2007/04/06/more-on-the-tr-interview/) claims seem worthy in their own right but they are particularly important to the semantic web (SW) community. The significance to the SW community was that their quantum computer solved problems akin to [Grover's Algorithm](http://en.wikipedia.org/wiki/Grover's_algorithm) speeding up queries of disorderly databases.

Semantic web databases are not (completely) disorderly and there are many ways to optimize the search for matching triples to a graph pattern. What strikes me is that the larger the triple store, the more compelling the case for using some kind of quantum search algorithm to find matches. DWave are currently trialing 128qbit processors, and they claim their systems can scale, so I (as a layman) can see no reason why such computers couldn't be used to help improve the performance of queries in massive triple stores.

What I wonder is:

1.  what kind of indexing schemes can be used to impose structure on the triples in a store?
2.  how can one adapt a B-tree to index each element of a triple rather than just a single primary key - three indexes seems extravagant.
3.  are there quantum algorithms that can beat the best of these schemes?
4.  is there is a place for quantum superposition in a graph matching algorithm (to simultaneously find matching triples then cancel out any that don't match all the basic graph patterns?)
5.  if DWave's machines could solve NP-Complete problems, does that mean that we would then just use OWL-Full?
6.  would the speed-ups then be great enough to consider linking everyday app data to large scale-upper ontologies?
7.  is a contradiction in a 'quantum reasoner' (i.e. a reasoner that uses a quantum search engine) something that can never occur because it just cancels out and never appears in the returned triples? Would any returned conclusion be necessarily true (relative to the axioms of the ontology?)

Any thoughts?

***[UPDATE
]{style="text-decoration:underline;"}***DWave are [now working](http://googleresearch.blogspot.com/2009/12/machine-learning-with-quantum.html) with Google to help them improve some of their machine learning algorithms. I wonder whether there will be other research into the practicality of using DWave quantum computing systems in conjunction with inference engines? This could, of course, open up whole new vistas of services that could be provided by Google (or their competitors). Either way, it gives me a warm feeling to know that every time I do a search, I'm getting the results from a quantum computer (no matter how indirectly). Nice.
