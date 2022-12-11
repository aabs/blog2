---
title: Temporary logging in VS.NET 2008 using Tracepoints
date: 2007-12-14 11:45
author: aabs
category: programming
slug: temporary-logging-in-vsnet-2008-using-breakpoints
status: published
attachments: 2007/12/image-thumb2.png, 2007/12/image1.png, 2007/12/image2.png, 2007/12/image-thumb1.png, 2007/12/image-thumb.png, 2007/12/image.png
---

I'm not sure whether this feature existed before VS.NET 2008 - it may even be common knowledge that has just passed me by. But I think it's just as cool as hell!

In a source file if you create a breakpoint, you get offered a 'When Hit...' menu option.

[![image]({static}2007/12/image-thumb.png){width="205" height="210"}]({static}2007/12/image.png)

When you click on that you get the following dialog box allowing you to create a breakpoint that does debug window logging!

[![image]({static}2007/12/image-thumb1.png){width="508" height="426"}]({static}2007/12/image1.png)

you can get temporary (and very detailed) logging by selecting the 'Print a message' checkbox. You also have the option to run a Macro

[![image]({static}2007/12/image-thumb2.png){width="490" height="519"}]({static}2007/12/image2.png)

There's no limit to what you could do with this lot. And the beauty of it is that you don't have to litter your code with unnecessary logging statements (especially in JS) unless you want to. So if you're performing diagnostics on a problem function, you can add these tracepoints and get lots of info, and then with a Ctl-Sh-F9 you can remove them all without having to recompile.

Nice. You can also add it from the context menu under the breakpoint menu option as 'insert a tracepoint'
