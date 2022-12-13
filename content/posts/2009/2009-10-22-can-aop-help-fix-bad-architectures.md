---
title: Can AOP help fix bad architectures?
date: 2009-10-22 08:55
author: Andrew Matthews
category: .NET, programming
ignored-tags: .NET, AOP, Aspect Oriented Programming, postsharp, SOA
slug: can-aop-help-fix-bad-architectures
status: published
---

I recently posted a [question](http://stackoverflow.com/questions/1541697/refactoring-nasty-legacy-systems-via-aop-or-other-automated-means) on Stack Overflow on the feasibility of using IL rewriting frameworks to rectify bad design after the fact. The confines of the answer comment area were too small to give the subject proper treatment so I though a new blog post was in order. Here's the original question:

> I've recently been playing around with PostSharp, and it brought to mind a problem I faced a few years back: A client's developer had produced a web application, but they had not given a lot of thought to how they managed state information - storing it (don't ask me why) *statically* on the [Application](http://msdn.microsoft.com/en-us/library/system.web.httpapplicationstate.aspx) instance in IIS. Needless to say the system didn't scale and was deeply flawed and unstable. But it was a big and very complex system and thus the cost of redeveloping it was prohibitive. My brief at the time was to try to refactor the code-base to impose proper decoupling between the components.
>
> At the time I tried to using some kind of abstraction mechanism to allow me to intercept all calls to the static resource and redirect them to a component that would properly manage the state data. The problem was there was about 1000 complex references to be redirected (and I didn't have a lot of time to do it in). Manual coding (even with R\#) proved to be just too time consuming - we scrapped the code base and rewrote it properly. it took over a year to rewrite.
>
> What I wonder now is - had I had access to an assembly rewriter and/or Aspect oriented programming system (such as a PostSharp) could I have easily automated the refactoring process of finding the direct references and converted them to interface references that could be redirected automatically and supplied by factories.
>
> Has anyone out there used PostSharp or similar systems to rehabilitate pathological legacy systems? How successful were the projects? Did you find after the fact that the effort was worth it? Would you do it again?

I subsequently got into an interesting (though possibly irrelevant) discussion with [Ira Baxter](http://stackoverflow.com/users/120163/ira-baxter) on program transformation systems, AOP and the kind of intelligence a program needs to have in order to be able to refactor a system, preserving the business logic whilst rectifying any design flaws in the system.  There's no space to discuss the ideas, so I want to expand the discussion here.

The system I was referring to had a few major flaws:

1.  The user session information (of which there was a lot) was stored statically on a specific instance of IIS. This necessitated the use of sticky sessions to ensure the relevant info was around when user requests came along.
2.  Session information was lost every time IIS recycled the app pool, thus causing the users to lose call control (the app was phone-related).
3.  State information was glommed into a tight bolus of data that could not be teased apart, so refactoring the app was an all-or-nothing thing.

As you can guess, tight coupling/lack of abstraction and direct resource dispensation were key flaws that prevented the system from being able to implement fail-over, disaster recovery, scaling, extension and maintenance.

This product is  in a very competitive market and needs to be able to innovate to stay ahead, so the client could ill afford to waste time rewriting code while others might be catching up. My question was directed in hindsight to the problem of whether one could retroactively fix the problems, without having to track down, analyse and rectify each tightly coupled reference between client code and state information and within the state information itself.

What I needed at the time was some kind of declarative mechanism whereby I could confer the following properties on a component:

1.  location independence
2.  intercepted object creation
3.  transactional persistence

Imagine, that we could do it with a mechanism like PostSharp's multicast delegates:

```
[assembly: DecoupledAndSerialized(
    AspectPriority = -1,
    AttributeTargetAssemblies = "MyMainAssembly",
    AttributeTargetTypes = "MainAssembly.MyStateData",
    AttributeTargetMembers = "*")]
```

[](http://11011.net/software/vspaste)

What would this thing have to do to be able to untie the knots that people get themselves into?

1.  It would have to be able to intercept every reference to MainAssembly.MyStateData and replace the interaction with one that got the instance from some class factory that could go off to a database or some distant server instead.

   that is - introduce an abstraction layer and some [IoC](http://en.wikipedia.org/wiki/Inversion_of_Control) framework.
2.  It must ensure that the component managing object persistence checked into and out of the database appropriately (atomically) and all contention over that data was properly managed.
3.  It must ensure that all session specific data was properly retrieved and disposed for each request.

This is not a pipe dream by any means – there are frameworks out there that are designed to place ‘shims’ between layers of a system to allow the the shim to be expanded out into a full-blown proxy that can communicate through some inter-machine protocol or just devolve to plain old in-proc communication while in a dev environment. The question is, can you create a IL rewriter tool that is smart enough to work out how to insert the shims based on its own knowledge of good design principles? Could I load it up with a set of commandments graven in stone, like “*never store user session data in [HttpContext.Application](http://msdn.microsoft.com/en-us/library/system.web.httpapplicationstate.aspx)*”? If it found a violation of such a cardinal sin, could it insert a proxy that would redirect the flow away from the violated resource, exploiting some kind of resource allocation mechanism that wasn’t so unscaleable?

From my own experience, these systems require you to be able to define service boundaries to allow the system to know what parts to make indirect and which parts to leave as-is. [Juval Lowy](http://www.idesign.net/) made a strong case for the idea that every object should be treated as a service, and all we lack is a language that will seamlessly allow us to work with services as though they were objects. Imagine if we could do that, providing an ‘abstractor tool’ as part of the build cycle. While I think he made a strong case, my experience of WCF (which was the context of his assertions) is that it would be more onerous to configure the blasted thing than it would be to refactor all those references. But if I could just instruct my IL rewriter to do the heavy lifting, then I might be more likely to consider the idea.

Perhaps PostSharp has the wherewithal to address this problem without us having to resort to extremes or to refactor a single line? PostSharp has two incredible features that make it a plausible candidate for such a job. the first is the [Multicast delegate](http://doc.postsharp.org/1.5/##PostSharp.HxS/UserGuide/Laos/Multicasting/Overview.html) feature that would allow me to designate a group of APIs declaratively as the service boundary of a component. The original code is never touched, but by using an [OnMethodInvocationAspect](http://doc.postsharp.org/1.5/##PostSharp.HxS/UserGuide/Laos/AspectKinds/OnMethodInvocationAspect.html) you could intercept every call to the API turning them into remote service invocations. The second part of the puzzle is [compile-time instantiation](http://doc.postsharp.org/1.5/##PostSharp.HxS/UserGuide/Laos/Lifetime.html) of an Aspect – in this system your aspects are instantiated at compile time, given an opportunity to perform some analysis and then to serialize the results of that analysis for runtime use when the aspect is invoked as part of a call-chain. The combination of these two allows you to perform an arbitrary amount of compile time analysis prior to generating a runtime proxy object that could intercept those method calls necessary to enforce the rules designated in the multicast delegate. The aspect could perform reflective analysis and comparison against a rules base (just like [FxCop](http://msdn.microsoft.com/en-us/library/bb429476(VS.80).aspx)) but with an added collection of refactorings it could take to alleviate the problem. The user might still have to provide hints about where to get and store data, or how the app was to be deployed, but given high level information, perhaps the aspect could self configure?

Now that would be a useful app – a definite must-have addition to any consultant’s toolkit.
