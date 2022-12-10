---
title: Almost ready to go open source
date: 2005-06-12 02:13
author: Andrew Matthews
tags: DBC
slug: almost-ready-to-go-open-source-3
status: published
---

I have been tweeking and fiddling with the framework in readiness for making it open source. There are still quite a few things I ought to do before making any attempt to publicise it. I thought that since I've been very remiss in not posting to this blog lately I could do some posting. How better than to list what I've got to do before the system is unveiled to the public? I know I'm not exactly going about this in the true open-source way, but I guess I'm a little wary about releasing my code to the public without having crossed as many 't's and dotted as many 'i's as I can find. I'm sure there are plenty of improvements that people will find when I release them, but I don't want any of them to be dumb or outmoded errors!

Anyway, enough of such insecurities! Here's what I have to do before D-day:

-   See if I can create a WIX installer that works. Currently I seem to be having problems with adding assemblies to the GAC. My best guess is that WIX is not able to add .NET 2.0 assemblies to the GAC because it's trying to use some sort of reflection on an incompatible assembly.
-   Create a user tutorial. I'll probably do that in this blog. It should be a pretty easy task, since I've gone to great lengths to make the framework as transparent as possible.
-   Document the API using NDoc. As ever, I've been slack in commenting my code. I guess I'll start with the main APIs and then keep at it in the months after release.
-   Run it through FxCop and make sure there are no obvious errors.
-   Run regression tests on the static code generation system! This is potentially of less value than the dynamic code generation system so I have ignored it for a while.
-   Make sure it still compiles on .NET 1.1! And how about Mono? I haven't seen any major commercial projects requiring Mono, but that may change...
-   Make sure that the compilation with NAnt works as well as the VS.NET 2005 beta 2 builds. Especially if WIX is not an option. I need to make tragets that will crerate binary and source distributions for release. This should then be used to upload overnight snapshots to the web each night.
-   Convert the system to work with CruiseControl.NET. I have (so far) had around 5 interviews with ThoughtWorks, so I really ought to be as obsequious as possible to boost my chances with them! ;-)

Once these tasks have been performed, then I ought to post it online and start trying to publicise it a bit more.
I can then think a bit more about using the framework in earnest. I want this system because I have an object relation mapping (ORM) system that is just short of being releasable and I would like to augment it with DBC to see whether I can productise it that way. For more information on ORMs, google for Scott Ambler's original postings on a design for a robust persistence layer. I also want to make the second release of the framework self-hosting. That is - I want to use DBC within the DBC framework itself. How much more could I practice what I preach, eh?
