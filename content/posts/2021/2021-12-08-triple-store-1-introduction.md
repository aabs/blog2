---
title: Implementing a Triple Store from the Ground Up - Part 1
author: Andrew Matthews
date: 2021-12-08
tags: ["rdf", "rdf databases", "graph databases"]
---

I've long been fascinated with semantic web technologies, the potential of RDF
and understanding how to implement a triple store from the ground up.
Databases are one of those technologies - like compilers - that we often
take for granted, and yet which beneath the hood employs some very sophisticated
algorithms and data structures to achieve acceptable levels of performance.

In this new article series, I'll implement a triple store using techniques
introduced in recent years for efficiently storing and processing indexes on
large knowledge graphs.  I'll use C# 10 and .NET 6 as the platform, with the hope
that I can create something that works on most common platforms, as well as
supporting deployment via docker containers.  Expect a few digressions into
programming techniques in C#, where it's interesting, but otherwise I'll try to
stick to discussions about triple stores and high performance data stores.

Since this is a kind of intro post, I figure I'd describe the lay of the land,
and what I hope to cover.  Since the implementation of databases is a very low
level task, I'll be working from the bottom up and moving to progressively more
usable code as I go.

* [Using Memory Mapped Files in .NET 6](posts/2021-12-08-triple-store-2-memory-mapped-files.html)
* Implementing an B+ Tree on a memory mapped file.
* Indexes used in a triple store.
* Encoding and decoding of IRIs and triples.
* Storing an RDF index on a B+ Tree.
* Storing triples and literals on a B+ Tree.
* Creating an RDF query engine.
