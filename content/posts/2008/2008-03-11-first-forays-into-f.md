---
title: First Forays into F#
date: 2008-03-11
author: Andrew Matthews
category: SemanticWeb
slug: first-forays-into-f
status: published
---

Since I've been doing a lot of LINQ in the last year or so, I figured that I could improve my C\# 3.0 by improving my functional programming. I had two choices of language to explore: Haskell or F\#. F\# was the obvious choice, I'm doing this to be a better C\# programmer, right? I don't want to depart too far from C\# then.

I'm not going to give you the whole F\# tutorial (though god knows someone needs to, cos the manual is poor). I'm just going to give you my first impressions: what it felt like to program in F\#, what seemed nice, what could do with improvement, that sort of thing.

I often learn a new language by writing a Genetic Algorithm (GA). It gives me a few chances to explore the syntax, and it's more interesting that a simple [hello world]{.underline}. This time round, I wrote a GA to evolve strings with all ones. I know it's pretty boring, but it's easy to give an absolute score to an individual (just by counting the ratio of 1s to 0s).

Scope rules and Immutability? Huh?
----------------------------------

My GA took up about 150 lines of code. That's probably a little more terse than the equivalent C\#, Java or C++ code. It's a little unusual for me (being used to languages with curly braces everywhere) to work in a language that uses indentation to define scopes, but it took me all of about 10 minutes to find it completely natural. My initial confusion was compounded by the fact that my every instinct was telling me that variables were mutable and that I could pass and return in my functions. I had to catch myself a few times with that. For instance, to my untrained eye, the following looked OK:

    let rec MyGeneticAlgorithm pop =
        generation <- generation + 1
        let tmp = GetNextPop pop
        if (Pass(tmp) == false) then
            let tmp = MyGeneticAlgorithm(tmp)
        Display tmp

[](http://11011.net/software/vspaste)

The tmp inside the else part and the tmp defined at the start of the function are completely unrelated, and when you invoke Display on tmp, you're getting the first value. That mistake caught me over and over, till I ended up avoiding that approach altogether.

Pipelines
---------

There were a few language features that were really nice to deal with. The first was pipeline operator ( **\|\>** ). It allows you to compose functions, feeding the results from one into the next. It helps to make the flow of data in your code very clear.  Here's an example from the main loop of the GA:

    let rec GeneticAlgorithm pop =
        generation <- generation + 1
        let tmp = (pop |> Score |> Transition |> Select |> DisplayBestScoringIndividual)
        if (Pass(tmp)) then
            tmp
        else
            GeneticAlgorithm(tmp)

[](http://11011.net/software/vspaste)

The section (pop \|\> Score \|\> Transition \|\> Select \|\> DisplayBestScoringIndividual) is easy to interpret.  My functions were designed to allow composition, since I wanted to be able to take the result of a chain of function calls and assign it to some variable. here's another nice example of using a pipeline and concatenating the result to another list:

    let Transition pop =
        let new_generation = [for i in 0 .. 5 -> Mate(SelectTwoMates(pop))]
        pop @ (new_generation  |> MutatePopulation  |> Score)


[](http://11011.net/software/vspaste)

In this example I select two mates randomly, five times, and mate them together. List1 ***@*** List2 concatenates List1 to List2 creating a new list. What I can do is pass my next generation of population members through a process of mutation and testing first, before I add them to the existing population. I could even have abbreviated it further:

    pop @ ([for i in 0 .. 5 -> Mate(SelectTwoMates(pop))] |> MutatePopulation |> Score)

Comprehensions
--------------

The \[for x in y -\> abc\] syntax is called a *list comprehension.* It's another nice piece of syntax that allows me to run a loop, invoke a function on the loop variable and create a list out of the results returned from each function invocation. The nearest C\# equivalent (that I can think of) looks like this:

    var myList = new List<PopulationMember>(Enumerable.Range(0, 5).Select(x => Mate(SelectTwoMates(pop))));

I think I prefer the F\# syntax! You can do this for arrays and sequences too.

Grokking the types
------------------

The F\# type system has parallels for many of the familiar .NET types. For example the ***list*** type is an extension of the List\<T\> type found in the System.Collection.Generic namespace. it provides a few additional methods to allow it to retain compatibility with OCaml. Sequences are the same as IEnumerables and arrays are the same as C\# arrays. Anothe primitive data structure provided by F\# is the ***tuple*** that allows you (kinda) to package data up in tiny anonymous structures for later concumption. the Syntax for tuples is easy to grasp, and being able to deal natively with them is extremely powerful.

Things that seemed strange (to me)
----------------------------------

The first being the type notation for functional types. I'm still struggling to get my head around the type signatures for higher level functions (that take and consume functions). Time will tell how natural this will get for me, but for now I find it a little irritating to have to resort to '*so that's a function that takes a function that takes an int and returns a function that.."* routine every time I get an intellisense pop-up.

Another thing I took a while to get used to was not surrounding the arguments to a method with parentheses and separating them with commas. If I invoke a method with that notation I end up passing it a tuple with each of the parameters as parts. Which may be appropriate, or not. If you want to include the results of a method invocation in the parameter list, you then have to surround it with parentheses.

I was really thrown by the lack of implicit type casting when dealing with integers and floats and singles etc. My first programming language was C, and every language since then has used implict type conversion where it was safe to do so. Casting the integer 2 to be a float should be perfectly safe. But F\# refuses to do it for me behind the scenes. I end up with code like this:

    let FitnessFunction (g:int list) : float =
        let totalOnes = Sum(g.Map(fun i -> float i))
        float totalOnes / float g.Length

Apart from the final division, most of this should have been possible simply because a conversion from an int to a float involves no possible loss of precision. pity.

Another irritation is the lack of signposts to good documentation. Naturally, because F\# is a product, MS don't want to point out to you that F\# is very close in syntax to OCaml (or at least, that's how it seems). I tried to get by on the F\# manuals, which were way too brief and short on examples. What I didn't realise initially is that OCaml has a lively open source community and that means there are some good quality tutorials and language guides about.

Things that seemed cool (to me)
-------------------------------

There are always a few things that take longer to fix in your mind when you are learning a new language. I never studied functional programming in university. Our campus opted in favour of Design By Contract & Eiffel. I wish, now, that it had been otherwise. I've really enjoyed my first foray into F\#. I think the code I'm able to write is easy to read. When I got my head around the scoping and immutability rules, my code just worked straight away. Not only that, it was fast. I was able to fly through a couple of thousand generations with 100 individuals each with a genome of 100 bits in about 1s. That's about a millisecond per generation. I was worried initially that all this copy was going to slow me down. It seems not.

Some Useful References
----------------------

1.  [Objective Caml Tutorial](http://www.ocaml-tutorial.org/)
2.  [The Objective Caml system](http://caml.inria.fr/pub/docs/manual-ocaml/index.html) by Xavier Leroy
3.  [The F\# Manual](\Program%20Files\FSharp-1.9.3.14\manual\library.html)

::: {.wlWriterSmartContent style="display:inline;margin:0;padding:0;"}
del.icio.us tags: [GA](http://del.icio.us/popular/GA),[genetic algorithm](http://del.icio.us/popular/genetic%20algorithm),[AI](http://del.icio.us/popular/AI),[F\#](http://del.icio.us/popular/F#),[OCaml](http://del.icio.us/popular/OCaml),[functional programming](http://del.icio.us/popular/functional%20programming),[C\#](http://del.icio.us/popular/C#),[dotnet](http://del.icio.us/popular/dotnet),[.NET](http://del.icio.us/popular/.NET)
:::
