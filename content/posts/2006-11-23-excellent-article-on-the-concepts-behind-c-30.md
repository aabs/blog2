---
title: Excellent Article on the Concepts behind C# 3.0
date: 2006-11-23 11:02
author: Andrew Matthews
ignored-tags: C#, LINQ
slug: excellent-article-on-the-concepts-behind-c-30
status: published
---

Thomas Petricek has written a very interesting article on the new concepts behind C\# 3.0 ([here](http://www.tomasp.net/articles/csharp3-concepts.aspx)). It shows the origin of many of the functional programming features found in C\# 3.0 from [Cω](http://research.microsoft.com/Comega/) and [F\#](http://research.microsoft.com/fsharp/). Having explored a little of the code that backs up the functional programming aspects, I understand that although the extension run with the basic features of C\# 2.0, there is a huge amount of C\# code required to deliver the functional paradigm to C\#. Most of that code provides complex code generation, type inference and declarative programming support.

In the first section on first class function support – I found on closer inspection (within LINQ at least) that these first class functions, are actually delivered through calls to the [DynamicMethod](http://msdn2.microsoft.com/en-us/system.reflection.emit.dynamicmethod.aspx) method of System.Reflection.Emit. If you disassemble its code, you'll see that the relationship between the imperative and functional programming in C\# is through '*runtime support*'. The functional programming extensions are a runtime extension to the CLR that generates code to fulfill declarative requirements. That is – there's no new radical paradigm at work in the core code, but the way it's exposed will simplify things so much that it might as well be called a new paradigm.

Well worth a read.
