---
title: Functional Programming - lessons from high-school arithmetic
date: 2008-05-29 21:49
author: aabs
category: .NET, functional programming, programming
tags: LINQ
slug: functional-programming-lessons-from-high-school-arithmetic
status: published
attachments: 2008/05/math.png
---

[[![]({static}2008/05/math.png){.size-full .wp-image-534 .aligncenter width="354" height="259"}](http://geekandpoke.typepad.com/)]{style="font-size:11pt;font-family:Calibri;"}

[I'll start out with an apology - it was only by writing ]{style="font-size:11pt;font-family:Calibri;"}[this ]{style="font-size:11pt;font-style:italic;font-family:Calibri;"}[post, that I worked out how to write a shorter post on the same topic. Sometime I'll follow this up with something less full of digressions, explorations or justifications. The topic of the post started out as '*Closure*'. It then became *'Closure plus Rules of Composition*' and finally ended up as *'functional programming - lessons from high school arithmetic*'. The point of this post is to explore the API design principles we can learn from rudimentary high school arithmetic.  ***You already know all the mathematics I'm going to talk about, so don't be put off by any terminology I introduce - it's only in there to satisfy any passing mathematicians.* ;\^\]**]{style="font-size:11pt;font-family:Calibri;"}

The topic of this post is much more wide-ranging than the previous ones. The post will eventually get around to talking about API design, but I really started out just wanting to dwell on some neat ideas from philosophy or mathematics that just appealed to me. The first idea is '***Closure***'.

Closure has many meanings, but the two most relevant to this blog are:

-   ::: {style="font-size:11pt;font-family:Calibri;margin:0;" lang="en-US"}
    [A function that gets evaluated with a bound variable]{style="font-size:11pt;font-family:Calibri;"}
    :::

-   ::: {style="margin-top:0;margin-bottom:0;vertical-align:middle;list-style-type:disc;" lang="en-US"}
    [A set that is closed under some operation. ]{style="font-size:11pt;font-family:Calibri;"}
    :::

It's this second meaning that I want to explore today - it's one of those wonderful philosophical rabbit holes that lead from the world of the mundane into a wonderland of deeply related concepts. As you'll already know if you've read any of my earlier posts on functional programming, I am not a mathematician. This won't be a deep exposition on category theory, but I do want to give you a flavour so that hopefully you get a sense of the depth of the concepts I'm talking about.

First let's start with two little equations that seem to bear almost no information of interest:

[(1)     1 + 1 = 2]{style="font-size:11pt;font-family:Calibri;"}

and

[(2)     2 - 1 = 1]{style="font-size:11pt;font-family:Calibri;"}

\(1) involves adding two [natural numbers](http://en.wikipedia.org/wiki/Natural_number) to get another natural number. (2) involves subtracting one natural number from another to get a third natural number. They seem to be very similar, except for the fact that if you keep repeating (2) you eventually get a negative number which is not a natural number. If you repeatedly perform addition, you can go on forever. That property is called '***closure***'. It means that if you perform addition on any natural number you are guaranteed to get a valid result. [That closure guarantee for some operations is one of the first things I want you to ponder - some operations give you guarantees of object validity, while others don't. We need to learn how to spot those ideas.]{style="color:#800000;"}

Another interesting thing that some introspection reveals about equation (2) is that the set from which it takes it's values is bounded in one direction, and that at the lower bound is a value that is [idempotent]{style="font-weight:bold;font-style:italic;"} for the operation. That term idempotent is daunting to us non-mathematicians but what it means is simply that when the operation is performed the result remains unchanged, no matter how many times it gets performed. [Here's another thing that is worth pondering - some operations are stable because they guarantee not to change your state.]{style="color:#800000;"}

***Digression***. Why on earth would anyone ever waste their time in writing code that was designed at the outset to [do nothing]{style="font-style:italic;"}? It seems like the ultimate exercise in futility. The answer is that idempotent operations are not doing nothing when in the presence of 'rules of combination'. With rules of combination (of which more later), idempotent operations become a useful tool in *composing functions*.

***SubDigression:*** A rule of combination is a feature of a system allowing you to combine distinct entities of a domain together to form a new entity. You can see how this relates to closure. It relates to closure on two levels. For example, when adding two integers:

-   The result of adding two integers is an integer. That's closure on the set of integers.
-   The composition of two closed functions is itself closed. That's closure at the level of functions on integers.

In other words, you can choose to provide closure at the level of domain object, or on the functions that manipulate them. LINQ queries of type IQueryable\<T\> are a good example. You can combine together two queries to get a sequence of T, thus providing domain-level closure. You can also combine together IQueryables to create new IQueryables that also yield sequences of T. That's functional closure. LINQ is closed on both levels. It's closed at the level of the entities that it is retrieving, but it's also closed at the level of the functions it uses to represent queries.

It's that level of composability that gives LINQ its power. And finding those design principles that we can apply to our own APIs is the purpose of this post. [Ponder this: we don't often provide rules of combination in our object models. If we did, our systems would probably be more flexible.]{style="color:#800000;"} ***End of SubDigression***

Several years ago I produced a graphics library for producing montages in a telepathology app. The system used a scripted generator to produce a tree of graphics operations. Each node on the tree manipulated an image then passed it on to its children. Without an idempotent operation it would have been extremely difficult to add orthogonal operations  (like comms, or microscope operations) or to bind together trees, or to create a default root of an operation graph.

The point of this outer-digression is that there are plenty of cases where at first sight Idempotence seems like architectural overkill. When you have rules of combination you find idempotent operations complete the puzzle making everything just click together. While the idempotent operation does nothing, it creates a framework on which other operations can be composed. [Ponder this: Sometimes targeting an architectural abstraction might seem overkill, but if done wisely it can yield great simplicity and flexibility. If you don't believe this - play with LINQ a little.]{style="color:#800000;"} ***End of Digression***.

If these were properties that only applied to natural numbers under addition or subtraction then they wouldn't be worth a blog post. It's the fact that this is a pattern that can be observed in other places that makes them worth my time writing about, and your time reading. Lets stay with integers a bit longer, though:

[(3)     2 \* 2 = 4]{style="font-size:11pt;font-family:Calibri;"}

[(4)     1 \* 2 = 2]{style="font-size:11pt;font-family:Calibri;"}

You probably noticed right away that the number 1 is idempotent in (4). We could keep multiplying by 1 till the cows come home and we'd always get 2. Now, I'm not setting out to explore the idea of idempotence. The reason I'm mentioning it is that it is an important property of an algebraic system. Closure is another. When you multiply two integers together you get another integer - that's closure.

Just as addition has it's inverse in the form of subtraction, so too does multiplication have an inverse in the form of division. Take a look at this:

[(5)     4 / 2 = 2]{style="font-size:11pt;font-family:Calibri;"}

[(6)     1 / 2 = 0.5]{style="font-size:11pt;font-family:Calibri;"}

In (6), the result is not an integer. As an interesting byline - the history of mathematics is littered with examples where new branches of mathematics were formed when non-closed operations were performed that led to awkward results. The process of creating a closed version of an operation's inverse led mathematicians to create new mathematical structures with new capabilities, thus extending mathematics' reach. The non-closure of subtraction (the inverse of addition) led to the introduction of the integers over the natural numbers. The non-closure of the division operation (the inverse of multiplication) led to the introduction of the rational numbers over the integers. And the non-closure of the square root operation (the inverse of the power operation) led to the introduction of the irrational numbers. On many occasions through history the inverse of an everyday closed operation has led to the expansion of the space of possible data types. [Ponder that - attempting to produce data structures on which the inverses of closed operations are also closed can lead to greater expressivity and power]{style="color:#800000;"}. A bit of a mouthful, that, and probably not universally true, but its something to ponder.

Again, if that were all there were to the idea, I (as a programmer) probably wouldn't bother to post about it - I'd leave it to a mathematician. But that is not the limit to closure. Closure has been recognized in many places other than mathematics - from physics to philosophy and from API to language design. Lets describe an algebraic system in the abstract to isolate what it means to be closed. The simplest mathematical structure that fits my description is called a Magma:

(7)     A Magma is any set \$latex M\$ equipped with a binary function \$latex M \\times M \\rightarrow M\$

This kind of thing is known to mathematicians as an [Algebraic Structure](http://http://en.wikipedia.org/wiki/Algebraic_structure). There are [LOTS](http://en.wikipedia.org/wiki/List_of_algebraic_structures) of different kinds, but that's one digression I'm not going to make. One thing to notice is that closure is built into this most basic of algebraic structures. What \$latex M \\times M \\rightarrow M\$ means is that if you apply the operation '\$latex \\times\$ ' to the two values from \$latex M\$ you get another value from \$latex M\$. By that definition, division doesn't qualify as a Magma if the set \$latex M\$ is integers, but it does if the set is the rational numbers.

(8)     2 + 3 + 5 = 10

(9)     (2 + 3) + 5 = 10

(10)     2 + (3 + 5) = 10

Each of these equations demonstrates what is known as *associativity*. If you add that to the definition of a Magma, you get what is called a semigroup. Integers with addition have that property of associativity, so it counts as a semigroup.

(11)     2 - 3 -5 = -6

(12)     (2 - 3) - 5 = -6

(13)     2 - (3 - 5) = 4

Clearly the subtraction operation on the integers is not associative, so it doesn't qualify to be called a semigroup.  [Try this on for size - associative operations are inherently flexible and composable. [Abelson and Sussman even went so far as to say that designing systems with such properties was a better alternative to the traditional top-down techniques of software engineering.]{style="color:#000000;"}]{style="color:#800000;"}

We saw earlier that the property of idempotence means that there may be an element that yields the same value for that operation. If the Magma has an identity property, then it is called a 'loop'. The point of this is to point out the other properties that operations can have (and how they contribute to membership of an algebraic structure). The key properties are:

-   [Closure]{style="font-size:11pt;font-family:Calibri;"}
-   [Associativity]{style="font-size:11pt;font-family:Calibri;"}
-   [Identity]{style="font-size:11pt;font-family:Calibri;"}
-   [Inversibility]{style="font-size:11pt;font-family:Calibri;"}

I'm going to throw a code snippet in at this point. If you're a programmer with no particular interest in algebra, you might be wondering what on earth this has to do with programming

\[sourcecode language="csharp"\]
var q = from u in MyDataContext.Users
where u.Name.StartsWith("And")
select u;\[/sourcecode\]

\[sourcecode language="csharp"\]
var q2 = from v in q
where v.Name.EndsWith("rew")
select v;\[/sourcecode\]

Here's an example taken from something like LINQ To SQL. Take a look at the 'where' keyword. It is clearly closed, since the application of where to a query yields another query (regardless of whether it gives you any useful results). The example is also associative, since you can reverse the order of the clauses and the resulting set will be the same. LINQ has an identity as well - ".Where(t =\> t)" which does nothing. LINQ lacks and inversion operation, so you can't add a clause, then cancel it out with another - instead, if you tried to do that, you'd get no results or everything. Here's something to ponder - would link be more or less powerful if it had the property of inversibility? It's clearly possible (though probably extremely difficult to implement).

I started thinking about these ideas because I wanted to understand why LINQ is powerful. It's flexible and easy to understand because of the  mathematical 'structure' of the standard query operations. [Ponderable: is any API going to be more powerful and flexible (and less brittle) if it displays some of the properties of an algebraic structure?]{style="color:#800000;"}

What are the advantages of creating APIs that have group structure? Just because we could design an API that has a group structure does not mean that we must. There must be an advantage to doing so. So far I have only hinted at those advantages. I now want to state them directly. If "*we can regard almost any program as the evaluator for some language*"\[[r](http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-25.html#%_chap_4)\], then we can also regard some languages as a more effective representation of a domain than others.  For many years, I've felt that the object oriented paradigm was the most direct and transparent representation of a domain. At the same time, I also felt there was something lacking in the way operations on an OO class work (in a purely procedural approach).

To cleanly transition the state of a class instance to another state, you (should) frequently go to extreme lengths\[[r](http://www.gotw.ca/gotw/008.htm)\] to keep the object in a consistent state. This kind of practice is avoided in those cases where it is feasible to use immutable objects, or more importantly to design your API so that the objects passed around might as well be immutable. Consider a class in C++ that implements the + operator. You could implement the operator in two ways:

1.  <div>

    add the value to the right to ***this***, and then return ***this***.

    </div>

2.  create a temporary object, add the value on the right to it and return the temporary object.

The following pseudo-code illustrates the point by imaging a class that supports "operator +":

\[sourcecode language="csharp"\]
MyClass a = new MyClass();
MyClass b = new MyClass();
MyClass c = new MyClass();
MyClass d = a + b + a + c;\[/sourcecode\]

If you implement '+' using technique 1 the result in d is \$latex (3a + b + 3c)\$ whereas if you implement it using technique 2, the result in d is correctly \$latex (2a + b + c)\$. Can you work out where the 3c comes from? The state, being mutable, is modified in a way that is incorrect during the addition operator. The operands of an operation like '+' should be unaffected by the fact that they took part in the assignment of a value to d. [Something else to ponder: immutable objects or operations can make it easier to produce clean APIs that]{style="color:#800000;"} [work *with* the language to create a correct answer.]{style="color:#800000;"}

You might complain that what I'm aiming for here is a programming style that uses mathematical operators to implement what would be otherwise done using normal methods. But you'd be missing the point. Whether your method is called '+' or if it's called 'AddPreTaxBenefits' is irrelevant. The structure of the operation, at the mathematical level, is the same. And the same principles can apply.

The method signature of a closed method is \$latex T 'times T \\rightarrow T\$. There are plenty of methods that don't fit this model. Lets pick one that pops into my mind quite readily - bank account transactions:

\[sourcecode language="csharp"\]
void Transfer(Account debit, Account credit, decimal sumToTransfer); \[/sourcecode\]

There is an entity in here that does fit the bill for such group like transactions - Money. There are endless complexities in financial transactions between currencies, like currency conversion, exchange rates and catching rounding errors. But the point is that it makes sense to be able to implement group operators on currency values. That ability allows you to define a language of currencies that can be exploited on a higher level item of functionality - the Account. BTW: I'm not talking about the algebraic structure of addition on decimals. I'm talking about adding values of locale specific money values - a different thing.

::: {style="font-size:11pt;font-family:Calibri;margin:0;" lang="en-US"}
\[sourcecode language="csharp"\]
void Transfer(Account debit, Account credit, Currency sumToTransfer)
{
debit.Balance = debit.Balance - sumToTransfer;
credit.Balance = credit.Balance + sumToTransfer;
}\[/sourcecode\]

Would it be better to define the operation on the Account class itself? The operator might actually be updating the internal balance property, but we don't care about that.

\[sourcecode language="csharp"\]
void Transfer(Account debit, Account credit, Currency sumToTransfer)
{
debit = debit - sumToTransfer;
credit = credit + sumToTransfer;
}\[/sourcecode\]

Lets take a look and see whether operator '+' fits the criteria we defined earlier for group-like structures:

**Closed** If you take an account and you add a value to it, you get another valid account, so yes, this is closed.

**Associative** Yes - though I'm not sure what that would mean in terms of bank accounts. Double entry bookkeeping is kinda binary...

**Identity** OK - The identity element of the '+' operation on accounts is the zero currency value.

**Inverse operation** Easy - subtraction. Or the negative currency value. Do you allow negative currency values? that's incompatible with double entry bookkeeping, so it might not be possible to provide an inverse operator for some systems. [There's an example where trying to get an inverse could lead you to change the design of your system.]{style="color:#800000;"}

This approach passes the criteria, but it also highlights a conceptual layer difference between money types and bank account types that makes for an awkward API if you try to treat them as equivalent. From a design perspective you can see that if there are non-obvious rules about how you can combine the elements of your class, you're no better off than with a conventional API design. One thing that does occur to me, though, is that the inconclusive group structure here pointed to a mismatch of levels. The addition operator applies at the level of quantities of cash - account balances. Accounts are more than just balances, and attempting to make them behave like they were nothing more than a number highlights the pointlessness of doing so. [Ponder this: the concept of 'levels' may be something that arises naturally out of the algebraic structure of the entities in a system?]{style="color:#800000;"} I'm not sure about this yet, but it's an intriguing idea, don't you think?

Obviously, we could have expected group structure at the level of balances, since we're dealing with real numbers that are a known group under addition and subtraction. But what about higher level classes, like bank accounts? What are the operations we can perform on them that fits this structure?

I wasn't sure whether I'd come away with any conclusions from this post, but I did come away with some very suggestive ideas to ponder:

-   Some operations give you guarantees of object validity. As a programmer, you need to learn how to spot them.
-   Some operations are preferable because they guarantee not to change your state.
-   Provide rules of combination in our object models would probably make them more flexible.
-   Sometimes abstraction might seem overkill, but if used wisely it can yield great simplicity and flexibility. If you don't believe this - play with LINQ a little.
-   Produce data structures on which the inverses of closed operations are also closed can lead to greater expressivity and power.
-   Associative operations are inherently flexible and composable.
-   Maybe all APIs will be more expressive and flexible (and less brittle) if they displays some of the properties of an algebraic structure?
-   Immutable objects or operations can make it easier to produce clean APIs that work with the language to create a correct answer.
-   Trying to get an inverse for an operation could lead you to change the design of your system.
-   The concept of 'levels' may be something that arises naturally out of the algebraic structure of the entities in a system.

It's funny that these ideas flow simply from looking at high-school algebra, especially since some of them read like a functional-programming manifesto. But, hopefully, you'll agree that some of them have merit. They're just thoughts that have occurred to me from trying to understand an offhand comment by Eric Mejer about the relationship between LINQ and Monads. Perhaps I'll pursue that idea some more in future posts, but for now I'll try to keep the posts coming more frequently.
:::
