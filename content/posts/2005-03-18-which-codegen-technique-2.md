---
title: Which codegen technique?
date: 2005-03-18 15:53
author: Andrew Matthews
ignored-tags: DBC
slug: which-codegen-technique-2
status: published
---

Now that I've come up with a few requirements, and shown you how I am going to partition the problem, I think it might be about time to discuss some of our technological options.

I said previously that I had a serviceable NVelocity wrapper, that I could use for the code generation. I have other options too, though, and some of them might be better in the long run, than sticking with NVelocity. So I weighed them up, and found that there were many conflicting factors.

My codegen options are:

-   Write code to a text file using Stream.WriteLine
-   Templating language (such as NVelocity)
-   XSLT transformation
-   CodeDOM code emission

I'm sure there are more options than these, but these are my main four. I judged them using the following criteria:

-   Speed
-   Ease of use
-   Flexibility
-   Readability
-   Debugability

My [comparison](http://aabs.aspxconnection.com/table1.html) is here. You can see that, as with most design decisions, there is a trade off to be made between speed and ease of development versus power and flexibility. With these sorts of decisions (especially when I know there are architectural factors involved) I tend to defer them until the last moment, or until something else places the casting vote. Of course, in the wider world of work, you normally get this sort of decision made for you by a pointy-haired marketing manager, who uses an etch-a-sketch as a laptop. Still, here I have the freedom to make my own decisions, and coolness and power will definitely win out over speed to market, or understandability.

Rant Over.

Apart from the CodeDOM option, I have used all of these techniques many times over the years. I've even used VIM macros to generated code. I've transformed XSD & DTD files into C++ serialization wrappers, and with Velocity and NVelocity I have done tons of code generation and generated literally millions of lines of code. The point is that the first three are tried and tested, with templates being my personal favourite. CodeDOM is not so dissimilar to systems I have used for HTML generation and XML tree navigation, so I guess it to is just another form of something familiar. Does that mean it doesn't win on the cool front? Fraid so. When it comes down to it, there are a few optimizations that can mitigate the startup, processing and resource management costs of using a template interpreter language such as NVelocity. The power and flexibility that we get in return is hard to refuse.

As you probably guessed I am going to opt for NVelocity, since I have a perfectly good system that I don't want to write again. I would like to have a framework to place it in that I can use with other code generation techniques if they seem worthwhile. Next time I will describe my code generation patterns and show how we can develop a limitless array of code generation handlers to allow people to use my system with XSLT or whatever. Later on I may even need to use this in conjunction with CodeDOM to perform dynamic proxy generation in a way similar to ServicedObjects in COM+.
