---
title: Domain Analysis (kinda)
date: 2005-03-16 13:55
author: Andrew Matthews
ignored-tags: DBC
slug: domain-analysis-kinda-2
status: published
---

I'm blogging my progress from mid-way through the project. I have a working
prototype, which is a crude implementation of what I want. It has a few
limitations which require me to go back and productise it. It may seem a little
arbitrary for me to describe a domain split on my second blog post, before even
telling you what the requirements are. It's not. It's just that that was what I
was thinking about, when I started this blog.

My motivation for this project is long standing. I used Eiffel at university (in
1993!), and since then have always wanted to see declarative predicates attached
to interfaces and classes. Nothing ever came in the languages I use, so I always
end up doing something like this. I wrote a version of this framework for C++
and Java some years ago, and I thought it's time I did the same for C\#. I also
want to explore some of the more obscure (and uniquely powerful) language
features of C\#, and new features coming with C\# v2.0.

I've split up the broad levels of responsibility into the following:

1. Assertion testing.
2. Assertion representation
3. Assertion code generation
4. Assertion handler assembly management
5. Assertion failure management
6. Configuration
7. Third party code integration

Some of these areas I will automatically descope, on the basis that they are
done better elsewhere. For example assertion failure management is done best
using a top level exception management system, or handlers in the code from
which the method invocations came. The Microsoft Enterprise System Exception
Handler Application Block system will allow you to handle exceptions in a
variety of ways, is extensible, and configurable. Lets leave that out. Assertion
testing is probably just an if/then statement. But experience tells me that all
result codes are not equal. HRESULTs needed a specialist test, as do old style C
methods that have zero as a success code, and everything else as failure.

Configuration I have decided to offload onto the new Microsoft Configuration
Application Block. Both came from the ACA.NET framework from Avanade. Kudos to
them, and no bias intended at all from me.

Assertion representation is fairly simple. I have a set of Attributes for each
type of assertion that I wish to make about a program. I have taken these from
Eiffel: Invariant, Require and Ensure. These represent invariant assertions that
must be true in all places and at all times. Ensure and Require are pre- and
post-conditions that apply to whatever they are attached to only. These
attributes store a string representation of the predicate they must enforce. It
is up to this program to turn those string based predicates into lightweight
code that can be applied on every invocation of the method they are attached to.

What I have already for code generation is a simple NVelocity based code
generation template system. It is a dumbed down version of NVelocity, but has
served me well over the years, and has been used in a production environment for
ORM code generation. The system is simple enough to initialise in two lines, and
allows repeated use of the same template with different parameters, so is very
good for doing lots of code generation.

I currently use the CodeDOM framework for the compilation of the generated
source code, and am as yet undecided about what to do with the generated
assemblies. Should I save them to a DLL, and keep them around? Perhaps I could
save myself the code generation step on future runs. I could also use a
Just-In-Time assembly generator and add assertion handlers as they are
encountered.

I am also undecided about whether to generate all of the code for the assembly
inline as proxies, or use some sort of Layer Supertype pattern to outsource the
assertion handling work, and then have a really barebones system emitted
dynamically as MSIL to invoke method on the supertype as necessary.

Assertion handler assembly management is another area where I need to make some
decisions. That will come out of how I solve the code generation issues
described above.

Third party code integration is that part of the design process that makes sure
that the framework is usable with a variety of implementations. For example I
can imagine that this should work with Dynamic and Static proxies. Static are
easier, but are more intrusive potentially. It should also fit into the more
common Aspect Oriented Programming Systems. Again here I am inspired by
Avanade's ACA.NET, which has a very well designed and implemented Aspect
Oriented system, which I'm surprised is not in the enterprise Library
Application Blocks.

So, to recap, I plan to write about how I solve the following problems in the
coming weeks/months:

1. Assertion testing.
2. Assertion representation
3. Assertion code generation
4. Assertion handler assembly management
5. Third party code integration

I'll also describe some simple usage scenarios, to put all of this into context,
which I guess will send me back to my university days and my first introduction
to Eiffel. Eiffel is not a .NET compatible language, so you could say I am
wasting my time re-inventing the wheel, when I could just program in Eiffel. My
only excuse is that I first learned to program in C, and I bonded to the syntax.
Anything else seems clunky or sloppy. I know that Eiffel is neither of these
things, but I've never found a contract for Eiffel either, so I continue to
trade on my C++, Java and C\# skills.

There is another, better, reason: I'm working as a Solution Architect in
Australia, where I don't get to write the programs I'm 'designing'. I'm doing
this project in my private time. I need to keep my skills alive until I get a
real project. So I'm not in any hurry to get this out, but if at some stage it
gets robust enough to show the world, perhaps you would like to join me in a
GPLd project? There are countless people out there who could do a better job of
the third party framework integrations than me. Are you one of them? Are you
single and have no triplets on the way? (unlike me!) Let me know, and when the
time comes, I'll set up the project.
