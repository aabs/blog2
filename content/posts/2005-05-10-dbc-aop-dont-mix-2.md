---
title: DBC & AOP don't mix
date: 2005-05-10 19:44
author: Andrew Matthews
tags: Code Generation, DBC
slug: dbc-aop-dont-mix-2
status: published
---

This time I'm going to explore some of the issues I've found in converting the prototype over to work in a JIT environment. If you've seen any of my previous posts, you'll know that I have a working prototype that uses static code generation to produce proxies to wrap objects that identify themselves with the DbcAttribute. These proxies are produced solely for those objects, so the developer has to know which items have predicates on them in order to instantiate the proxies rather than the target objects. If the programmer forgets, or doesn't know, that an object has predicates, he may create the target object and not benefit from the DbcProxy capabilities.

I've therefore been looking at ways to guarantee that the proxy gets generated if the library designer has used DBC. There are a lot of ways to do this, and having not explored all of them, I want to find a way to construct the proxies that will allow any of these approaches to be employed at run time. That naturally makes me think of abstract class factories and abstraction frameworks. It is nice to allow the library designer to define predicates on interfaces, but that may not fit the design they are working on, so I don't want to mandate it.

The solution I've looking at uses the code injection system that comes with the System.Enterprise namespace's ContextBoundObject classes. This framework guarantees that the object gets a proxy if it has an attribute that derives from ProxyAttributes. I would derive my DbcAttribute from ProxyAttribute and get an automatic request to create a proxy. Sounds perfect? Yes! But as you will see, there is a gotcha that will prevent this approach. Read on to find out more...

#### Status of the prototype

The prototype uses a Windows console application that is invoked as part of the build process to create the proxies for an assembly. The program is invoked in association with an application config file to provide it with the details of the target assembly, where the resulting proxy assembly is to be stored, and what it's to be called. It has a few other config settings to define how it will name the proxy for a target object, and what namespace it shall live in. So far, I have not added any guidance to it on how to handle the assemblies in a not static way. I haven't implemented any dispenser to intercede in the object creation process. In this blog I'm going to take a look at what config settings I need to add to control the choice between dynamic and static proxy generation.

I'm using the Microsoft Enterprise Application Blocks to handle configuration, and I'm using log4net to take care of logging issues. NVelocity is being used to construct the source code for the proxy. None of that will change in the refactoring that is to follow. In fact, very little has to change in the event model to turn the system into a dual static/dynamic proxy generator. What changes is in the issue of how to handle the prodicates when you are using a dispatch interface. More on that to follow.

#### static code gen via CSharp compiler

The static code generation process has been described in a quite a bit of detail in previous posts, but in essence it works by scanning through all of the types in an assembly, looking for ones that are adorned wit the DbcAttribute. For each of those, it scans through each of the InvariantAttributes, and then through each of the members in the class to get their details and any predicates that are attached to them. It then creates a proxy class that imitates the target type, except that prior to each invocation it checks a set of pre-conditions, and afterwords checks post-conditions. This proxy type is kept around until all of the assemblies types have been scanned, and then a new proxy assembly is compiled and saved to disk. This Proxy assembly is then used instead of the target type.

The CSharpCompiler provides a set of options to allow you to keep the source code used to create the assembly, and to create debug information to tie the assembly to the source code at run-time. This is useful for debugging the DBC system, but should not be necessary when using the framework in the field. If errors occur they will be on either side of the proxy (assuming I debug the proxies properly) and the user shouldn't want to see the source for the proxy itself. We therefore need to be able to turn this off, along with debug information.

Another feature of the compiler is the ability to dispense an in-memory only assembly that is available for the lifetime of the process. This is just what we need for dynamic proxy generation.

#### New library for dynamic proxies

One refactoring that is inevitable is that we now need two front-ends to the DBC system. A command line tool for static proxy generation that can be invoked from VS.NET or NAnt. We also need something that can be used in-proc to dispense dynamic proxies on demand. This can't be another process unless you want to use remoting to access your objects. You may want to do that, but you need to have some control of that situation, and it would be a little intrusive to have that decision taken away from you.

#### Dynamic proxy code generation pattern

The process for the dynamic proxy is much the same as for the static proxy, it just tweaks the compiler settings a little, and provides some speed ups for handling the storage and retrieval of assemblies for types that have already been code generated. The procedure is as follows:

-   client requests an objects of type X
-   creation process is intercepted by the CLR, because the DbcAttributes is declared on the object or one of ins ancestors.
-   The DbcAttributes provides an object that can be used to intercept calls to the object, and it passes the creation of that object off to the dynamic proxy code generator.
-   The dynamic proxy CG checks in a HashTable whether the target type has been requested previously, if so it instantiates the generated proxy and returns.
-   if no type has been generated for this type it creates a scanner and a code generator as per the static proxy CG, and requests the scanner to scan the type.
-   After the type has been scanned, there will be exactly one element in the ProcessedTypes context variable in the CG.
-   The dynamic proxy CG then requests that the CG generate an assembly for the type, specifying that the assembly must be in-memory only.
-   The assembly is generated, and it is stored along with the target type in the HashTable for future reference.
-   The new proxy type is dispensed by the DbcAttribute, and the target object creation commences as normal.
-   Next time a call on the target object is performed the proxy object is allowed to intercept the call, and run its checks.
-   voila!

This seems almost exactly how I want the dynamic proxy to work. The client doesn't have an option but to use it if it is available. This convenience comes at a price. That price is detachment from the state of the target object. If you want to do any interesting kinds of test on the current state of the target object, you need a reference access to the various public members of the type.

Without access to the target instance you can't make pre or post or invariant checks, because you can't access the state to see how it has changed or take snapshots of the initial state. It is in effect unusable. So does that mean that the dynamic proxy is incompatible with DBC?

The problem here is not in the idea of a dynamically generated proxy, it is in the *kind* of proxy we are using, and in its relationship to the target object. It is not connected to the target object in any way - it could even be on a different machine from the target. Even if it was directly connected (within the enabling framework) it wouldn't be of much use since it is designed to deal in IMessage objects, not target object instances.

The IMessage instance is a property bag that contains name value pairs for each of the parameters that is passed into a single method called "Invoke" which is able to then process the parameters. This pattern will be familiar to those who ever wrote COM components that needed to be compatible with VB - it is a dispatch interface. This sort of thing is great if you want to log the values of parameter calls, or to perform rudimentary checks on the incoming parameters.

We want to go a lot further than that. You can't make many assertions about how an object behaves just by describing its input and output values. And **that's the problem that I have with standard interfaces** - apart from a name which may or may not mean anything they only have a signature. A signature is just a list of the parameters and return types. Nice to have obviously, but not a lot of value when it comes time to work out what happens inside the implementation(s) of the signature.

So, we need direct access to the target object to be able to go any further. Does that mean that the context bound object approach is dead in the water. I'm not sure and this is fairly sparsely documented area of the framework so I haven't been able to track down an answer to that question yet. Answers on a postcard if you know a definitive answer to this. I am going to assume so for the time being. This hasn't been a wasted time - we've learned a useful fact about the limitations of dynamic proxies - namely that they are not compatible with aspect oriented programming paradigms. If anything they can the end-point of an AOP proxy chain, but they cannot sit anywhere in the middle of a chain of responsibility. It's a depressing fact of life - but useful to know.

What else can we deduce from this? We know that any kind of DBC proxy is going to need access to the state that is somehow deterministic. The key concept is state here. Anything that transforms the state of the target object also changes the semantics. Imagine, for example that the DBC proxy sat at the far end of an AOP chain - it will have an instance to a target object but the target object will delegate all the way down to the real target object at the other end of the chain. All of the state inquiry methods are present, but are converted into IMessage objects and passed through the chain of proxies before arriving at the real target object. The AOP chain can modify the data going into the real target, and modify the results coming out of it. They can also change the timing characteristic making a synchronous call where previously the interface was not, or vice versa. They could transform XML documents or add and subtract values from parameters. The point is, when you are out of touch with the target object, you have no guarantees event hat the parameters you are making tests against are the same as are received by the real target object. You consequently face a situation where the semantics are similar but potentially subtly modified, and you have to track that in your assertions.

This may sound like a rather academic discussion of the potential to modify an interface to have diferent semantics, but that is the essence of the adapter design pattern, and is an occupational hazard with SOA architectures. Don't forget that when you invoke an API on a third party software system, you think you know what is happening, but you often don't. You generally have some documentation that acts as a contract saying what goes on inside the service when the service gets invoked. We all know that such documentation often gets out of date, and we also know that there is little you can do to stop a well-meaning-fool from breaking your system. That's Murphy's law at work again. If something can go wrong, it generally will. And normally it is introduced by someone who thought they were solving some other problem at the time.

So published interfaces aren't worth the paper they are written on, especially if you're playing a game of chinese wispers through layers of other people's code. We need a system that is direct and compulsory, with no middlemen to dilute the strength of the assertions that you make on a component.

Next time I will describe how I solve this problem - probably by paying homage to the [Gang Of Four](http://en.wikipedia.org/wiki/Design_Patterns)...
