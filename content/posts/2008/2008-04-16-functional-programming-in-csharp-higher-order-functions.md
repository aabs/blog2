---
title: Functional Programming in C# - Higher-Order Functions
date: 2008-04-16 20:58
author: Andrew Matthews
category: .NET, functional programming, programming
ignored-tags: .NET 3.5, C#, Computer Science, functional programming
slug: functional-programming-in-csharp-higher-order-functions
status: published
attachments: 2008/04/clip-image001-thumb.png, 2008/04/clip-image0015.png, 2008/04/clip-image0015-thumb.png, 2008/04/clip-image001.png
---

1.  [Functional Programming - Is it worth your time?](http://aabs.wordpress.com/2008/04/09/functional-programming-is-it-worth-your-time/ "Functional Programming - Is it worth your time?")
2.  [Functional Programming in C\# - Higher-Order Functions](http://aabs.wordpress.com/2008/04/16/unctional-programming-in-csharp-higher-order-functions/)

This is the second in a series on the basics of functional programming using C\#. My topic today is one I touched on last time, when I described the rights and privileges of a function as a first class citizen. I'm going to explore Higher-Order Functions this time. Higher-Order Functions are functions that themselves take or return functions. Meta-functions, if you like.

As I explained last time, my programming heritage is firmly in the object-oriented camp. For me, the construction, composition and manipulation of composite data structures is second nature. A higher-order function is the equivalent from the functional paradigm. You can compose, order and recurse a tree of functions in just the same way as you manipulate your data. I'm going to describe a few of the techniques for doing that using an example of pretty printing some source code for display on a web site.

I've just finished a little project at [Readify](http://www.readify.net) allowing us to conduct code reviews whenever an interesting code change gets checked into our TFS servers. A key feature of that is pretty-printing the source before rendering it. Obviously, if you're displaying XHTML on an XHTML page, your browser will get confused pretty quickly unless you take steps to HTML-escape all the XHTML entities that might corrupt the display. The examples I'll show will highlight the difference between the procedural and functional approaches.

This example shows a fairly typical implementation that takes a file that's been split into lines:

[public static string]{style="color:#0000ff;"}\[\] RenderLinesProcedural([string]{style="color:#0000ff;"}\[\] lines)
{
    [for ]{style="color:#0000ff;"}([int ]{style="color:#0000ff;"}i = 0; i \< lines.Count(); i++)
    {
      lines\[i\] = EscapeLine(lines\[i\]);
    }
    [return ]{style="color:#0000ff;"}lines;
}

[public static string ]{style="color:#0000ff;"}EscapeLine([string ]{style="color:#0000ff;"}line)
{
  [Debug]{style="color:#2b91af;"}.WriteLine(["converting " ]{style="color:#a31515;"}+ line);
  [return ]{style="color:#0000ff;"}line.Replace([" "]{style="color:#a31515;"}, ["  "]{style="color:#a31515;"})
      .Replace(["\\t"]{style="color:#a31515;"}, ["  "]{style="color:#a31515;"})
      .Replace(["\<"]{style="color:#a31515;"}, ["\<"]{style="color:#a31515;"})
      .Replace(["\>"]{style="color:#a31515;"}, ["\>"]{style="color:#a31515;"});
}

There's a few things worth noticing here. In C\#, strings are immutable. That means that whenever you think that you are changing a string, you're not. In the background, the CLR is constructing a modified copy of the string for you. The Array of strings on the other hand is not immutable, therefore a legitimate procedural approach is to make an in-place modification of the original collection and pass that back.  The EscapeLine method repeatedly makes modified copies of the line string passing back the last copy.

Despite C\# not being a pure functional programming language\[[1](http://en.wikipedia.org/wiki/Functional_programming#Pure_functions)\], it's still doing a lot of copying in this little example. My early impression was that pure functional programming (where all values are immutable) would be inefficient because of all the copying goign on. Yet here is a common-or-garden object oriented language that uses exactly the same approach to managing data, and we all use it without a qualm. In case you didn't know, StringBuilder is what you should be using if you need to make in-place modifications to strings.

Let's run the procedural code and record what happens:

[private static void ]{style="color:#0000ff;"}TestProcedural()
{
   [string]{style="color:#0000ff;"}\[\] originalLines = [new string]{style="color:#0000ff;"}\[\] { ["\<head\>"]{style="color:#a31515;"}, ["\</head\>" ]{style="color:#a31515;"}};
   [Debug]{style="color:#2b91af;"}.WriteLine(["Converting the lines"]{style="color:#a31515;"});
   [IEnumerable]{style="color:#2b91af;"}\<[string]{style="color:#0000ff;"}\> convertedStrings = RenderLinesProcedural(originalLines);
   [Debug]{style="color:#2b91af;"}.WriteLine(["Converted the lines?"]{style="color:#a31515;"});

[   foreach ]{style="color:#0000ff;"}([string ]{style="color:#0000ff;"}s [in ]{style="color:#0000ff;"}convertedStrings)
    {
    [Debug]{style="color:#2b91af;"}.WriteLine(s);
    }
}

Here's the output:

> [![clip\_image001]({static}2008/04/clip-image001-thumb.png){width="165" height="118"}]({static}2008/04/clip-image001.png)

As you can see, the lines all got converted before we even got to the "converted the lines?" statement. That's called 'Eager Evaluation', and it certainly has its place in some applications. Now lets use Higher-Order Functions:

[public static ]{style="color:#0000ff;"}[IEnumerable]{style="color:#2b91af;"}\<[string]{style="color:#0000ff;"}\> RenderLinesFunctional([IEnumerable]{style="color:#2b91af;"}\<[string]{style="color:#0000ff;"}\> lines)
{
    [return ]{style="color:#0000ff;"}lines.Map(s =\> EscapeString(s));
}

[static ]{style="color:#0000ff;"}[IEnumerable]{style="color:#2b91af;"}\<R\> Map\<T, R\>([this ]{style="color:#0000ff;"}[IEnumerable]{style="color:#2b91af;"}\<T\> seq, [Func]{style="color:#2b91af;"}\<T, R\> f)
{
   [foreach ]{style="color:#0000ff;"}([var ]{style="color:#0000ff;"}t [in ]{style="color:#0000ff;"}seq)
     [yield return ]{style="color:#0000ff;"}f(t);
}

[static string ]{style="color:#0000ff;"}EscapeString([string ]{style="color:#0000ff;"}s)
{
   [Debug]{style="color:#2b91af;"}.WriteLine(["converting " ]{style="color:#a31515;"}+ s);
   [return ]{style="color:#0000ff;"}s.Replace(["  "]{style="color:#a31515;"}, ["&nbsp;&nbsp;"]{style="color:#a31515;"})
     .Replace(["\\t"]{style="color:#a31515;"}, ["&nbsp;&nbsp;"]{style="color:#a31515;"})
     .Replace(["\<"]{style="color:#a31515;"}, ["&lt;"]{style="color:#a31515;"})
     .Replace(["\>"]{style="color:#a31515;"}, ["&gt;"]{style="color:#a31515;"});
}

[private static void ]{style="color:#0000ff;"}TestFunctional()
{
   [string]{style="color:#0000ff;"}\[\] originalLines = [new string]{style="color:#0000ff;"}\[\] { ["\<head\>"]{style="color:#a31515;"}, ["\</head\>" ]{style="color:#a31515;"}};
   [Debug]{style="color:#2b91af;"}.WriteLine(["Converting the lines"]{style="color:#a31515;"});
   [IEnumerable]{style="color:#2b91af;"}\<[string]{style="color:#0000ff;"}\> convertedStrings = RenderLinesFunctional(originalLines);
   [Debug]{style="color:#2b91af;"}.WriteLine(["Converted the lines?"]{style="color:#a31515;"});

[   foreach ]{style="color:#0000ff;"}([string ]{style="color:#0000ff;"}s [in ]{style="color:#0000ff;"}convertedStrings)
    {
    [Debug]{style="color:#2b91af;"}.WriteLine(s);
    }
}

This time the output looks different:

> [![clip\_image001\[5\]]({static}2008/04/clip-image0015-thumb.png){width="157" height="113"}]({static}2008/04/clip-image0015.png)

At the time that the "Converted the Lines?" statement gets run, the lines have not yet been converted. This is called 'Lazy Evaluation\[[2](http://en.wikipedia.org/wiki/Lazy_evaluation)\]', and it's a powerful weapon in the functional armamentarium. For the simple array that I'm showing here, the technique looks like overkill but imagine that you were using a paged control on a big TFS installation like Readify's [TFSNow](http://www.tfsnow.com/Tour/WhatIsTFS.aspx). You might have countless code reviews going on. If you rendered every line of code in all the files being viewed, you would waste both processor and bandwidth resources needlessly.

So what did I do to change the way this program worked so fundamentally? Well the main thing was to opt to use the IEnumerable interface, which then gave me the scope to provide an alternative implementation to representing the collection. in the procedural example, the return type was a string array, so I was bound to create and populate the array before returning from the function. That's a point worth highlighting: ***Use iterators as return types where possible - they allow you to mix [paradigms](http://en.wikipedia.org/wiki/Programming_paradigms)***. Converting to IEnumerables is not enough. I could change the signature of TestProcedural to use iterators, but it would still have used Eager Evaluation.

The next thing I did was use the Map function to return a functional iterator rather than a concrete object graph as was done in the procedural example. I created Map here to demonstrate that there was no funny LINQ business going on in the background. In most cases I would use the [Enumerable.Select()]{style="font-size:x-small;font-family:Courier New;"} extension method from LINQ to do the same thing. Map is a function that is common in functional programming, it allows the lazy transformation of a stream or collection into something more useful. Map is the crux of the transformation - it allows you to insert a function into the simple process of iterating a collection.

Map is a Higher-Order Function, it accepts a function as a parameter and applies it to a collection on demand. Eventually you will need to deal with raw data - such as when you bind it to a GridView. Till that point you can hold off on committing resources that may not get used. Map is not the only HOF that we can use in this scenario. We're repeatedly calling String.Replace in our functions. Perhaps we can generalise the idea of repeatedly calling a function with different parameters.

[Func]{style="color:#2b91af;"}\<T, T\> On\<T\>([this ]{style="color:#0000ff;"}[Func]{style="color:#2b91af;"}\<T, T\> f, [Func]{style="color:#2b91af;"}\<T, T\> g)
{
    [return ]{style="color:#0000ff;"}t =\> g(f(t));
}

This method encapsulates the idea of composing functions. I'm creating a function that returns the result of applying the inner function to an input value of type T, and then applying the outer function to the result. In normal mathematical notation this would be represented by the notation "g [o]{style="font-size:xx-small;"} f", meaning *g* applied to *f*. Composition is a key way of building up more complex functions. It's the linked list of the functional world - well it would be if the functional world were denied normal data structures, which it isn't. :P

Notice that I'm using an extension method here, to make it nicer to deal with functions in your code. The next example is just a test method to introduce the new technique.

[private static void ]{style="color:#0000ff;"}TestComposition()
{
    [var ]{style="color:#0000ff;"}seq1 = [new int]{style="color:#0000ff;"}\[\] { 1, 3, 5, 7, 11, 13, 19 };
    [var ]{style="color:#0000ff;"}g = (([Func]{style="color:#2b91af;"}\<[int]{style="color:#0000ff;"}, [int]{style="color:#0000ff;"}\>)(a =\> a + 2)).On(b =\> b \* b).On(c =\> c + 1);
    [foreach ]{style="color:#0000ff;"}([var ]{style="color:#0000ff;"}i [in ]{style="color:#0000ff;"}seq1.Map(g))
    {
      [Debug]{style="color:#2b91af;"}.WriteLine(i);
    }
}

TestComposition uses the 'On' extension to compose functions into more complex functions. The actual function is not really that important, the point is that I packaged up a group of functions to be applied in order to an input value and then stored that function for later use. You might think that that's no big deal, since the function could be achieved by even the most trivial procedure. But this is dynamically composing functions - think about what you could do with dynamically composable functions that don't require complex control logic to make them work properly. Our next example shows how this can be applied to escaping strings for display on a web page.

[void ]{style="color:#0000ff;"}TestComposition2()
{
   [var ]{style="color:#0000ff;"}strTest = [@"\<html\>\<body\>hello world\</body\>\</html\>"]{style="color:#a31515;"};
   [string]{style="color:#0000ff;"}\[\]\[\] replacements = [new]{style="color:#0000ff;"}\[\]
     {
       [new]{style="color:#0000ff;"}\[\]{["&"]{style="color:#a31515;"}, ["&amp;"]{style="color:#a31515;"}},
       [new]{style="color:#0000ff;"}\[\]{["  "]{style="color:#a31515;"}, ["&nbsp;&nbsp;"]{style="color:#a31515;"}},
       [new]{style="color:#0000ff;"}\[\]{["\\t"]{style="color:#a31515;"}, ["&nbsp;&nbsp;"]{style="color:#a31515;"}},
       [new]{style="color:#0000ff;"}\[\]{["\<"]{style="color:#a31515;"}, ["&lt;"]{style="color:#a31515;"}},
       [new]{style="color:#0000ff;"}\[\]{["\>"]{style="color:#a31515;"}, ["&gt;"]{style="color:#a31515;"}}
     };

[  Func]{style="color:#2b91af;"}\<[string]{style="color:#0000ff;"}, [string]{style="color:#0000ff;"}\> f = x =\> x;
  [foreach ]{style="color:#0000ff;"}([string]{style="color:#0000ff;"}\[\] strings [in ]{style="color:#0000ff;"}replacements)
  {
     [var ]{style="color:#0000ff;"}s0 = strings\[0\];
     [var ]{style="color:#0000ff;"}s1 = strings\[1\];
     f = f.On(s =\> s.Replace(s0, s1));
  }

[  Debug]{style="color:#2b91af;"}.WriteLine(f(strTest));
}

This procedure is again doing something quite significant - it's taking a data structure and using that to guide the construction of a function that performs some data-driven processing on other data. Imagine that you took this from config data or a database somewhere. The function that gets composed is a fast, directly executable, encapsulated, interface free, type safe, dynamically generated unit of functionality. It has many of the benefits of the Gang Of Four Strategy Pattern\[[3](http://en.wikipedia.org/wiki/Strategy_pattern)\].

The techniques I've shown in this post demonstrate some of the power of the functional paradigm. I described how you can combine higher order functions with iterators to give a form of lazy evaluation. I also showed how you can compose functions to build up fast customised functions that can be data-driven. I've also shown a simple implementation of the common Map method that allows a function to be applied to each of the elements of a collection. Lastly I provided a generic implementation of a function composition mechanism that allows you to build up complex functions within a domain.

Next time I'll introduce the concept of closure, which we've seen here at work in the 'On' composition function.

Some references:

1\. Wikipedia: [Pure Functions](http://en.wikipedia.org/wiki/Functional_programming#Pure_functions "http://en.wikipedia.org/wiki/Functional_programming#Pure_functions")

2\. Wikipedia: [Lazy Evaluation](http://en.wikipedia.org/wiki/Lazy_evaluation "Lazy evaluation")

3\. Wikipedia: [Strategy Pattern](http://en.wikipedia.org/wiki/Strategy_pattern "http://en.wikipedia.org/wiki/Strategy_pattern")
