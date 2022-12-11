---
title: Why type safety in configuration is a good thing
date: 2006-11-01 16:39
author: Andrew Matthews
ignored-tags: C#, Computer Science, Configuration
slug: why-type-safety-in-configuration-is-a-good-thing
status: published
---

How many times have you seen a piece of code like this?

`bool shouldUseXyzService = bool.Parse(WebConfiguration.AppSettings["shouldUseXyzService"]); if(shouldUseXyzService){…}`

It's a familiar thing to most programmers. And most programmers never stop to think about just how evil it is. In my last few posts I've been suggesting that we ought to be using something like this:

`if(SomeConfiguration.ShouldUseXyzService){…}`

Why is it better?

##### Type Safety.

The key reason is automatic type safety. Type safety ensures that when you make a call to another component you get the data you are after in the format you wanted. Imagine if you had to check for 'y', 'yes', 'true', '1' and so on. It wouldn't take you long before you started making sure that you had a single representation of true. And that's what type safety ensures in the case of a config system.

There is another form of type safety at stake. The config data might be in the wrong format. You code ought to have looked like this:

`try{    bool shouldUseXyzService = bool.Parse(WebConfiguration.AppSettings["shouldUseXyzService"] .Trim().ToLower());    if(shouldUseXyzService){…} }catch(FormatException e){…}`

What do you do if the config is in the wrong format? Rethrow? Set a default value? Rethrowing means your app is toast. Setting a default value will yield unpredictable behavior, especially when the config files are different between production and release builds. You never have this kind of production weirdness with typed configuration objects because that sort of syntactic error never makes it through a compilation.

##### Performance

Unless you have a mechanism to load a cache the contents of the configuration file in memory, you are inevitably going to have to make a file access every time you access the config variable. With most built-in config systems, you will get that for free. But most config files are stored in a name value dictionary format of some sort – a hash table. Accessing a hashtable every time you want to get at a variable is very expensive compared to the kind of inlined access you would get if you were accessing a const or read-only variable on an abstract type.

A built in config system (such as the one found in .NET) is not going to know what type your data is in, so it can't store a typed representation of the data for fast access. Instead it will store the data in a string. That means that you have to parse your data every time you access it. In the case of a bool above it might be reasonably straightforward to parse it, but your still talking about a lot of CPU cycles wasted for no advantage. Imagine if your config was a date time or currency value that had a lot of logic required to convert into local specific object representations. In those cases the simplicity of the .Parse(…) API hides a major time waster.

##### No test guarantees

When you run a set of tests over a piece of code – it gives you an assurance that the code works. You can deploy it to production and it will behave in the same way there. When you have a set of guiding policy variables that are not part of the test regime you are already losing some of the safety that you have with fully tested code.

##### Readability

I doubt that there would be any debate that the typed configuration object code above is more readable than the first or second untyped examples. The intent is clear, the format is understood by the runtime and it gets intellisense support. The typed configuration object has another level of readability. If you put a whole bunch of related configurations together in a class called XyzServiceConfigurations it is much easier for developers to know where to go to get a specific setting. I've seen a few systems that define a Constants class, but generally these classes are not broken up into semantically meaningful units. Why? I don't know. We can go further by defining relationships between config objects we can dispense them in consistent ways using class factories.

Designers should really be looking for justifications for untyped config systems, not the reverse.
