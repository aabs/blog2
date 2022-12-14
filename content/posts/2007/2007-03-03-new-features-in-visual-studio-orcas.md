---
title: New Features in Visual Studio Orcas
date: 2007-03-03
author: Andrew Matthews
ignored-tags: cool, programming, software
slug: new-features-in-visual-studio-orcas
status: published
---

\[digg=http://www.digg.com/software/New\_Features\_in\_Visual\_Studio\_Orcas\]

I've been taking the new Visual Studio Preview for a spin, and it's got some pretty nice new additions. These aren't just the headline features that have been publicized elsewhere, but the thoughtful additions to usability that will make our lives a little bit easier. They should also help us to make our code a lot cleaner and less complex. We see the introduction of easy performance reporting and differential comparison of profiling sessions. We also see the introduction of code metrics analysis. The March 2007 CTP also sees the long awaited intellisense support for LINQ in C\# as well as some other nice features for exporting code and projects as templates.

![](http://farm1.static.flickr.com/172/408594508_8afcfddf30.jpg?v=0)

The performance report comes with a single click. It helps you to target your optimizations.

![](http://farm1.static.flickr.com/138/408594815_8eb065aa41.jpg?v=0)

After you've done your optimizations, you can rerun your profiler and do a comparison to see how well your efforts worked.

![](http://farm1.static.flickr.com/176/408594556_b56c2a7373.jpg?v=0)

The code analysis tools now offer code complexity metrics that will indicate whether your code needs simplification or refactoring.

![](http://farm1.static.flickr.com/184/408594845_fb08bca9a7.jpg?v=0)

The refactoring tools have not received much attention, and still lag behind the likes of R\#. There are a quite a few refactoring code snippets, that may allow us to craft our own refactorings. If so, then we have a power that has not been seen outside of UML tools like Rational XDE.

![](http://farm1.static.flickr.com/184/408594459_6cc72d1e37.jpg?v=0)

The tools for architects have come along way. It's clear that they are targeting the aims of the Dynamic Systems Initiative ([DSI](http://www.microsoft.com/windowsserversystem/dsi/default.mspx)). This is a very exciting piece of work, and will revolutionize development when it reaches fruition. Here you can see an Application diagram with a set of property pages allowing the architect to define the system properties required for deployment of a windows application called Test1.

![](http://farm1.static.flickr.com/125/408594887_c32c05b821.jpg?v=0)

The class diagram now allows you to directly enter your method definitions in the class details pane. Code is generated on the fly in the code window. I'm not sure if this is new, but I can't recall seeing anything like this in 2005.

![](http://farm1.static.flickr.com/127/408594784_60b6e4a1b1.jpg?v=0)

While you're editing the properties of your methods, you can also directly edit the code commentary as well. Now there's no excuse…

![](http://farm1.static.flickr.com/176/408594436_cdeb2f8306.jpg?v=0)

There is a new feature allowing you to search for web services defined in other projects, to insert them as web references in the current project. Great productivity feature for distributed applications.

![](http://farm1.static.flickr.com/149/408594907_2c3ac7c23f.jpg?v=0)

The class view pane gets a new search box that allows you to search for classes fields and properties. This is really useful, and can save programmers hours of hunting on large projects. (provided they haven't got R\# of course)

![](http://farm1.static.flickr.com/172/408594769_100e449729.jpg?v=0)

Yes! LINQ intellisense. Nuff said.

![](http://farm1.static.flickr.com/123/408594610_ec509452e9.jpg?v=0)

Orcas also introduces a nice Export template feature that allows you to develop a project or group of classes for exporting as a *new item* template. This feature is a great way to allow architects to ease the development cycle. They can produce pieces of reference code and distribute them to the rest of their development team.

![](http://farm1.static.flickr.com/183/408594650_00deeb5cbd.jpg?v=0)

Just select the classes that you want to export.

![](http://farm1.static.flickr.com/123/408594697_2802b6fe3d.jpg?v=0)

Give an explanation of what they are intended to do.

![](http://farm1.static.flickr.com/43/408594735_d5fa629de3.jpg?v=0)

And visual studio goes through them creating placeholders for class and namespace identifiers. These can then be filled in when the developer creates a new item.

![](http://farm1.static.flickr.com/167/408594586_9815afd310.jpg?v=0)

there are still problems that need to be sorted out though. Like project properties...

These are a few of the things that I noticed immediately. I'm sure there are more to come. The documentation has not been overhawled much, and the LINQ section is still mostly empty pages. But my initial impression is that Orcas is going to be a delight to work with, for the whole team.
