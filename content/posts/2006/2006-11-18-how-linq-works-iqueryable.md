---
title: How LINQ Works - IQueryable
date: 2006-11-18 23:07
author: Andrew Matthews
ignored-tags: C#
slug: how-linq-works-iqueryable
status: published
---

My last post explored the implementation of the Where extension method on IEnumerator and IQueryable. I showed that the filter method on enumerators visits every element in the collection. I also showed that calling Where on a Queryable just adds a new root to the expression tree. I ended with a promise to show how the queryable gets turned into a sequence of object references. This is the really innovative part of LINQ - If we want to provide a LINQ-style query language on some data store of our own, we need to understand how this stuff works. Unfortunately, it’s undocumented except in this document.

Probably the best way to see that process in action is to examine GetEnumerator() in SequenceQuery. SequenceQuery is the primary concrete implementation of IQueryable. It gets returned when we use Where in conjunction with something like a Lambda Expression. A Lambda expression in C\# has the form

(a, b) =\> a.DestinationCity.ToUpper() != b.DepartureCity.ToUpper()

I’m not going to show so much code as the last post for a couple of reasons. The first is that there is SO much of it that the post would be tedious in the extreme. The other reason is that I am not completely convinced that Reflector is showing me everything that is going on. I’ve tried to get access to the source of LINQ, and if it is forthcoming I will explain in more detail what is happening under the hood. For now, I can give an outline based on my understanding of what has to happen for LINQ to work.

What follows is the outline of the algorithm that LINQ employs to query something like an in-memory collection.

`• SequenceQuery.GetEnumerator()   o SequenceRewriter.Visit(expression)     • Visits each node in the expression tree resolving any references   o Creates an expression compiler   o Compile the expression (using ExpressionCompiler.Compile(LambdaExpression))     • Clear all lambdas and globals     • GenerateLambda    Create new CompileScope    Start generating a new DynamicMethod    Create an IL generator     • GenerateInitLiftedParameters     • Lifter.LiftParameters(this.scope)       • Resolves free variables in the expression     • For each parameter in the expression       • Create a generic type that stores a T       • Add a parameter to the generic method   • Recurse expression tree generating code for operations and member accesses • Return a delegate that acts as a filter over the enumerator of the original collection.`

Please excuse the formatting, but WP doesn't like the way I nest lists. The GetEnumerator method caches the results of any earlier call to it, so subsequent calls will yield the same results as before, without having to go through the whole code generation process. You cannot re-run the query, so if you need to get different sequences of data by running the query over time, you will have to prepare the expression of the query independently then run it in multiple SequenceQueries somehow.

If no results are available, then the SequenceQuery needs to compile the expression tree. This code generation uses the System.Reflection.Emit namespace classes to do its work, and if you want to get familiar with truly native IL code generation you could do worse than explore LINQ to see how it generates generic objects to store values, and how it generates expressions that are eventually invoked as it iterates the target collection.

The first task is to lift all of the parameters of the collection. [Lambda lifting](http://en.wikipedia.org/wiki/Lambda_Lifting) is a concept from functional programming that seeks to resolve *free variables* in an expression in order to evaluate the expression without needing to adhere to scope rules. An expression like *for each* a *in x.GetNearestThingumies()* has a bound variable x that is immediately resolvable. The variable *a* is not so easy to resolve since it changes with each iteration of the Thingumies. In the case of DLINQ I would imagine the problem is harder, since some of the free variables are accessible by making function calls or accessing properties, but others are found in the database itself and must be resolved after the data has been retrieved from the data store. So far, I have been unable to determine whether DLINQ produces a multi-pass filtration system that lifts what it can, and then resolves data after the ADO.NET query has been run. To explain what I mean, consider the following little snippet of DLINQ code:

[var q = from c in Northwind.Customers where c.FirstName.ToUpper() == localVar.ToUpper() select c;]{.QuoteChar}

This must be a non-trivial problem for LINQ to SQL. localVar.ToUpper() can be lifted during the code generation process, it can be converted to upper case and replaced by a constant expression node. The c.FirstName.ToUpper() is a free variable though, and cannot be lifted in advance of the code generation process, since the code generation is meant to retrieve the data from the database and only after that has been done can it do the ToUpper and then do the comparison. Over the next few weeks I’ll be digging deeper to find out what I can.

The ExpressionCompiler turns the expression into whatever sequence of calls are required to get the objects defined in the Expression. We saw in the analysis of IEnumerable.Where that the extension methods follow a validate then delegate pattern, and we see it here again. It calls to an overload of Compile that takes a LambdaExpression. A LambdaExpression is a type of Expression taking a collection of readonly parameters and a body that is an expression. Using type inference, the LINQ runtime is able to turn that combination into an anonymous delegate that can return whatever type the embedded expression has.  This delegate can then be used to instantiate the array of T that the query will store for further enumeration.

Resources:

[]{style="font-family:Symbol;"}·[         ]{style="font:7pt 'Times New Roman';"}The LINQ project [home page](http://msdn.microsoft.com/data/ref/linq/).

[]{style="font-family:Symbol;"}·[         ]{style="font:7pt 'Times New Roman';"}The LINQ Standard Query operators [paper](http://download.microsoft.com/download/5/8/6/5868081c-68aa-40de-9a45-a3803d8134b8/Standard_Query_Operators.doc).

[]{style="font-family:Symbol;"}·[         ]{style="font:7pt 'Times New Roman';"}LINQ on [mono](http://www.go-mono.com/archive/1.1.14/) (read the source here)

[]{style="font-family:Symbol;"}·[         ]{style="font:7pt 'Times New Roman';"}LINQ on [LtU](http://lambda-the-ultimate.org/node/1253)

[]{style="font-family:Symbol;"}·[         ]{style="font:7pt 'Times New Roman';"}Bart De Smet’s [Blog](http://community.bartdesmet.net/blogs/bart/archive/2006/07/04/4115.aspx)

[]{style="font-family:Symbol;"}·[         ]{style="font:7pt 'Times New Roman';"}Troy Magennis’ [aspiring.query](http://aspiring-technology.com/blogs/troym/archive/2006/10/06/24.aspx) extension methods
