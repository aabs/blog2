---
title: Polymorphism in C#/.NET Makes Code Incomprehensible
date: 2006-12-06 10:14
author: Andrew Matthews
ignored-tags: Code Generation, LINQ, programming
slug: polymorphism-in-cnet-makes-code-incomprehensible
status: published
---

I've recently been working on a series of blog posts that require me to reverse engineer the contents of the LINQ assembly System.Query. My experience has largely been very positive, but I have one problem that has slowed my progress – navigating beyond polymorphic method calls. This isn't a problem with LINQ (it uses polymorphism in a number of key places) it's a problem with code reading generally.

I find that while abstraction frameworks are essential to allow clean factoring and decoupling of object models, they make interpretation of runtime behaviour ***very hard*** – the more fully encapsulated a framework is, the harder it is to read it's code and deduce how it works.

I don't have a problem with polymorphism as a rule, well I do, but it's a price I am more than willing to pay. But I really have struggled to get through the LINQ code base – it is complex enough, without me being hindered at every step by the fact that I have to guess what is going on at runtime for a specific combination of parameters. The struggle for me was keeping it all in my head – the structure of the LINQ expression tree (specifically the Type of each node in the tree), the call stack, the type parameters passed to generic methods, and the progress in iterating collections of those types. It's hard, and it's not using everyday idioms so you can't guess with very much confidence what it ought to be doing. I wonder whether there might be some tool support that I can exploit to ease the code reading process.

If you know of a tool (or some way to augment the debugger) that will allow me to profile the LINQ expression creation and compilation at runtime, please let me know. I've tried combinations of [Reflector](http://www.aisto.com/roeder/dotnet/), [Hawkeye](http://www.acorns.com.au/hawkeye/) and [dotTrace](http://www.jetbrains.com/profiler/). None of them were able to penetrate the fog individually, and were impossible to use in combination. Perhaps you know of a way to tackle these issues?
