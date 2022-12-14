---
title: Functional programming - Is it worth your time?
date: 2008-04-09
author: Andrew Matthews
category: .NET, programming
ignored-tags: .NET 3.5, C#, C# 3.0, functional programming
slug: functional-programming-is-it-worth-your-time
status: published
---

Short Answer: Yes!

Regular readers of the The Wandering Glitch know I focused lots of attention on LINQ and the new wave of language innovation in C\# 3.0. I'm intrigued by functional programming in C\#. At university, I focused on languages like C, C++, Eiffel and Ada. I've never since needed to learn functional programming techniques - who uses them, after all? Functional programming had always seemed like a distant offshoot of some  [Bourbakiste](http://en.wikipedia.org/wiki/Nicolas_Bourbaki#cite_note-0) school of mathematical programming unconcerned with practical issues of software development. Don't get me wrong - I find that attractive, but it was always hard to justify the time, when there was so much else of practical worth that I needed to study. So the years passed, and I never came near. Functional programming was suffering from bad PR. But times change.

A fundamental change is under way in how we develop software. Declarative, Functional, Model-driven, Aspect-oriented and Logic Programming are all examples where new ways of representing and solving problems can pay huge dividends in programmer productivity and system maintainability.  Suddenly, it no longer seems that functional programming is a means to try out obscure new forms of lambda calculus. Now it seems that there are fast, powerful, easy to understand techniques to be learnt that will make my systems more robust and smaller.

I regretted not learning functional programming - I felt that there were ideas I was missing out on. And that made me envious. So, now is as good a time as any to address that deficiency. Another deficiency I want to address is the dearth of posts on the Glitch. I got tied up in producing a SPARQL tutorial for IBM which swallowed up my evenings. After that I had in mind to pursue an idea for a blog post on the relationships between LINQ, and Meta-mathematical structures like Groups and Categories. I got a major dose of intellectual indigestion, which stopped me from producing anything. The only way I'll get productive again is to break the topics I want to cover into bite-sized chunks. that's enough apologia - here's the post.

[Functional Programming](http://en.wikipedia.org/wiki/Functional_programming) is probably simpler than you think. It's based on the idea that there is often very little distinction between programs an data. Consider this function 'f':

    f(x): x + 5

This function 'f' adds five to whatever you pass into f. What do I mean when I say 'f'. I'm talking about the function, not using it. It came completely naturally for you to go along with me and describe the function 'f' as a thing. Here's what I mean:

      g(f, x): f(x) + 7

This function 'g' adds 7 to the result of calling 'f' on x. So the final result would be '(x + 5 ) + 7'. You see, that wasn't really a complex concept at all. Yet that's the essence of functional programming. To put it another way:

> *Functions are first class citizens.*

Which means that:

-   They can be named by variables.
-   They can be passed as arguments to procedures.
-   They can be returned as values of procedures.
-   They can be incorporated into data structures. \[[1](http://mitpress.mit.edu/catalog/item/default.asp?ttype=2&tid=3305)\]

It should also mean that you can compose your own functions as I did with 'f' and 'g' earlier. Another possibly less vital feature to empower this charter for the rights and privileges of functions is the 'lambda' (or λ) function. A lambda function is simply a way to create function on the fly, without having to give it a name. Compare this C\# function:

    int f(int x){return x + 5;}

With this one:

    int f(int x) {   int c = 5;   return x + c; }

They both perform the same function, but the second one pointlessly created a name for the value '5'. The first example got by perfectly well without having to give a name to the value it was working with. Well, the same principle applies to lambda functions. Here's a C\# example that does what 'g' did above:

    int g(Func<int , int> f, int x){return f(x) + 7;}

The 'Func\<int, int\> f' syntax is a new piece of C\#, used to represent that f is a function that takes a single int and returns an int. you can probably already see that this function 'g' could be used with many different functions, but sometimes we don't want to exercise our right to be able to name those functions with variables. To just create a function, without naming it (to use an 'anonymous function' in .NET parlance) you use the new lambda function syntax in C\# 3.0:

    int x = 3; int z = g(y => y + 5, x);

'g' gets an anonymous function and an integer as parameter, runs the function with the parameter, adds 7 to what comes out of the function and then returns the result. Pretty cool. We've exercised our second right - to be able to pass functions into procedures. What about the first right? Well we sort of already had that with parameter 'f' in the function 'g' earlier. Lets look at another example:

    int Foo() {   Func<int , int> bar = y => y + 5;   // …   return bar(56); }

We've kept our function around in a format that is very flexible. It hovers in a middle ground between program and data. If, like me, you have a procedural and imperative heritage - you regard anything that you can store, return and pass around as data. But when you can run that data as code, then the lines begin to get a little blurred.

The next right that we need to claim is the ability to return functions as values. We have all the machinery needed to do that now. If we can pass something into a function, then we could pass it straight out again. If we can create lambdas we can return them rather than use them or pass them into other functions. Here's an example based on the function 'g' earlier:

    Func<int , int> H() {   return (int a) => a + 7; }

This is powerful - rather than give you the result of adding a number to some value you pass in, this function gives you a function that you can use to perform the function. you don't need to know what the function is, just how to run it. Sounds like a perfect recipe for business rules. Obviously, adding numbers like that is trivial, but the principle can be applied to functions of great complexity. This can be lazy too - you can provide a function to calculate the result *when you need it* and not before. Think LINQ to SQL queries, that don't incur the expense of hitting the DB until necessary.

The last right needed to be a first class functional citizen is also achieved through the capabilities that have been explained already (in the case of C\# at least). If we can create a function and assign it to a variable, then we can do the same to a compound data structure. Here's a slightly more elaborate example (thanks to [Paul Stovell](http://www.paulstovell.com/blog/) for the idea):

    public class MySwitcher<T , R> { Func<T , bool> Pred{get;set;} Func<T , R> Iffer{get;set;} Func<T , R> Elser{get;set;}

    public MySwitcher(Func<T , bool> pred,   Func<T , R> iffer,   Func<T , R> elser) {   Pred = pred;   Iffer = iffer;   Elser = elser; } R Run(T input) {   if(Pred(input))   return Iffer(input);   return Elser(input); } }

This class keeps two functions around for later use. It also keeps a predicate function (a function that returns a yes/no answer) to decide which of them to use for a given piece of data. This could be used, for example, in a UI to decide between different ways to filter or render data based on some criteria.

I hope this very simple introduction shows you that not only does C\# (and .NET 3.5 generally) now support functional programming, but that the arsenal of the functional programmer is very small and easy to learn. Next time around I hope to show you just how powerful these simple techniques can be.

\[1\] Abelson & Sussman: the structure and interpretation of computer programs. 2ed. MIT Press. 1998.
