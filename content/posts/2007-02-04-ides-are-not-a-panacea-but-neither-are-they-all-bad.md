---
title: IDEs are not a panacea, but neither are they all bad
date: 2007-02-04 20:57
author: Andrew Matthews
ignored-tags: programming
slug: ides-are-not-a-panacea-but-neither-are-they-all-bad
status: published
---

It seems I touched a bit of a [raw](http://alecthegeek.wordpress.com/2004/06/17/108747492485585638/) nerve with Alec when I pointed out that some IDEs are less [crap](http://alecthegeek.wordpress.com/2007/02/04/all-ides-are-crap/) than others. Specifically, I was referring to the ones that have major corporate clout invested in their production. He pointed out that they require standardisation of tools within a development team as well as standardisation of APIs, SCM tools, documentation, and build tools. He also points out that they obscure information from the developer that is necessary for the proper understanding of a complex system.

As I pointed out in my [first post](http://aabs.wordpress.com/2007/02/02/why-open-source-software-development-environments-are-crap/) on this topic, a good IDE doesn't obscure information - it makes it more accessible. That's why one of the first features integrated into an IDE is documentation. Even open source tools such as \#develop provide that as a feature. Intellisense (the provision of context sensitive information as a tool tip) which one won't find in tools such as emacs or vim, is another early inclusion in the feature set. They are not an obfuscatory feature, they do the opposite of what Alec alleges. Even if that were the case, which I doubt, there is a need in non-trivial systems for abstraction of layers. These days that is most often achieved through the layered design of systems. That is a deliberate ploy by programmers to hide information from themselves to avoid information overload.

Standardisation of tools is not generally a bad thing either. If you are working as part of a distributed open source development team, there is less face to face collaboration and problem solving. In that case, you might not be aware of the value of having the same toolset as your colleague until you ask them to help you solve a problem you're working on. Them being able to use your IDE as though it were ther own is a positive thing. If all members of a co-located team were using different tools, the options for collaboration are lessened. Not a good thing in my experience.

Directory naming dependencies are a product of hard coding of configuration files rather than the use of IDEs. You can hard code your constants without the help of an IDE quite easily, I find. Enforced change control is absolutely vital whatever your working on. Large or small, pro or amateur, corporate or not. I wouldn't work in a team that didn't enforce such a thing. To me it's unthinkable. Am I understanding Alec right? Is he saying a common source code control policy is a bad thing?

Documenting code for the purposes of code reuse is helped by most IDEs - VS.NET is able to flag such omissions as errors if you want. Getting code that is reusable is much harder, and neither an IDE or a bitty development environment (BDE) will help you there! Most IDEs can support build scripts. VS.NET can provide intellisense for NAnt build scripts or MSBuild scripts. If you want to provide a centralised build server you can use either of these, and in fact the most successful approach I've seen for build servers is where NAnt delegates building projects to an IDE, while it takes care of other environmental issues such as packaging, testing and deployment.

What I wonder is whether I am so firmly embedded in the non-open-source development process that I have become spoilt, and can't function without the aid of tools that help to augment my memory and perception. Would I be a better programmer if I was happy to switch to a different command line tool for each task that I routinely perform?
