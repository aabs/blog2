---
title: What to expect from a DBC framework
date: 2005-03-17 14:07
author: Andrew Matthews
tags: DBC
slug: what-to-expect-from-a-dbc-framework-2
status: published
---

Last time I said I'd explore the requirements on a DBC solution in a little more detail. I first experienced design by contract when I was studying object oriented design at Brighton University, UK. I was studying it under Richard Mitchell, author of "Design by Contract, by Example". The curriculum was taught using Eiffel. Eiffel was (and is still is, as far as I know) the only programming language that has native support for design by contract. A little googling brings up quite a few links on DBC. One thing is clear from a cursory glance; DBC means different things to different people. To some it means prepending and appending your methods with guard statements like this:

    public void foo() { if(this.Bar < 1) throw new ApplicationException("Bar < 1 failed"); }

This is certainly a step in the right direction. It focuses your attention on what the environment of a component is like, and what the right "operating envelope" is for the correct function of a method. You do this when you define unit tests to explore the limits of a method, seeking ways to break it. Some argue that if you have done your job properly during the testing phase, then DBC wouldn't be necessary.

Others argue that such guard statements are against the tenets of defensive programming, but of course your part in the contract is to make sure that the code never reaches my component unless you are sure that the guards will not be triggered. So a defensive programmer would put guards around the method invocation. Naturally, I can't let my guards down, since as a developer I can't assume that you have done everything that you ought to do to use my component. So the checks are to stay in place, as a defensive measure against people who don't practice defensive programming themselves. Generally you can't handle argument errors at the point of invocation, so it makes sense to send the exception straight back to the caller.

Design By Contract is more than just a way of trapping and reporting errors in component usage. I want to be able to make a declaration like this on an interface, and have all implementers and users of the interface abide by the rules.

    [Invariant(Balance >= OverdraftLimit)] interface IBankAccount { public float Balance{...} public float OverdraftLimit{...} }

This sort of programming is more about making declarations about what you want to happen - declarative programming. It's about having declarations that have some weight. Sadly, in languages like C\#, there is no intrinsic mechanism that enforces contracts like the one above, so the purpose of this project is to find a way to enforce such rules without intruding too much into the everyday routines of a programmer. It should just work.

If you look closely at my interface definition above, you'll see that there is more going on. The interface is setting some semantic rules. Normally, an interface is a syntactic contract between component developers and consumers. But here we are able to go a step beyond that, into the realm of semantics If I produce a contract like this:

    interface IBankAccount { [Require(val > 0.0)] [Ensure($after(Balance) == $before(Balance) + val)] public float CreditAccount{float val}  public float Balance{...} }

I'm not just declaring how you make calls into my method. I'm telling you what the call *achieves*. Previously I was only able to say what the method was called, what parameters it took, what order they were in, and what type the result was. Vital stuff, to be sure, but not useful without a specification or some sort of API documentation. With DBC I can tell you what happens when you call my method, what kinds of data should be in the parameters, and what changes in the state data after the method call. I'm describing the effects of the process, without describing the algorithm. That's exactly what we're after with an interface. We have managed to extend the interface to carry the sort of information that it should have been carrying to begin with! Wow! Now you should be able to see why I'm writing a blog about DBC!

#### In Summary...

You can see from the examples above, that we need to be able to make statements about the content of Properties, Fields and Parameters. We also need to be able to take snapshots of their value before and after the method invocation, and see whether the rules have been followed. We now have some requirements to be going on with.
