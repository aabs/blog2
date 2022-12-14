---
title: IHttpModule not running after conversion to IIS 7 and .NET 3.5
date: 2007-11-16
author: Andrew Matthews
category: .NET
slug: ihttpmodule-not-running-after-conversion-to-iis-7-and-net-35
status: published
attachments: 2007/11/image-thumb3.png, 2007/11/image-thumb1.png, 2007/11/image-thumb4.png, 2007/11/image5.png, 2007/11/image1.png, 2007/11/image.png, 2007/11/image3.png, 2007/11/image-thumb2.png, 2007/11/image2.png, 2007/11/image-thumb5.png, 2007/11/image-thumb.png, 2007/11/image4.png
---

I recently ran into this problem with one of our clients. It's the sort of thing that I take ages to track down a solution to, and then once I have solved it, I immediately forget what the solution is. So I'm putting it here as an aid memoire.

The client had a module that they were using to create a custom Principal object derived from a FormsPrincipal. I found that after I had converted the project to work with VS.NET 2008 beta 2, it stopped working, giving me a GenericPrincipal instead. I had converted the client's project to .NET 3.5 from .NET 2.0 and I was also using IIS 7 where they were using IIS 6 in production and IIS 5 for dev. There were a few variables that made it not very straightforward to solve, not least of which is that nothing is easy to find in IIS 7 (when you're so used to IIS 6).



First step: find the blasted thing that shows you what managed modules you've got.

[![image]({static}2007/11/image-thumb.png){width="239" height="355"}]({static}2007/11/image.png)



Double click on it, and you will be shown a list of what modules apply for the application you're working with.

Sort the modules by type.

[![image]({static}2007/11/image-thumb1.png){width="213" height="132"}]({static}2007/11/image1.png)

What I found was that my web.config file had entries for two modules:

[![image]({static}2007/11/image-thumb2.png){width="314" height="94"}]({static}2007/11/image2.png)

But IIS 7 claimed I had only one.

[![image]({static}2007/11/image-thumb3.png){width="363" height="47"}]({static}2007/11/image3.png)

I tried a load of different things, like rearranging the order of the modules, putting tracing on the lifecycle events of the module, and adding more detailed version info on the fully qualified type name of the module. All to no avail. Then I noticed that IIS offered the ability to add you own modules.

[![image]({static}2007/11/image-thumb4.png){width="178" height="135"}]({static}2007/11/image4.png)

So I clicked on the "Add Managed Module..." link, and entered the details that were already in the web.config file, and hey presto! It replaced the contents of the modules section in the web.config with exactly the same data. But this time it was also reflected in the modules area of IIS 7.

[![image]({static}2007/11/image-thumb5.png){width="354" height="63"}]({static}2007/11/image5.png)

Don't ask me why - it's probably something to do with the IIS 7 metabase, but I don't know. Certainly, it wasn't anything wrong with the config file.
