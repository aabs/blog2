---
title: Orcas Beta 2 Features - Split View
date: 2007-07-30 15:39
author: aabs
tags: ASP.NET
slug: orcas-beta-2-features-split-view
status: published
attachments: 2007/07/image-thumb1.png, 2007/07/image-thumb2.png, 2007/07/image1.png
---

In Beta 2, MS have given ASP.NET web forms and controls the Cider treatment. That is - you are shown the design and markup views side by side just as in the visual designer for WPF. This is called "Split View", and can be extremely useful - unless your page uses controls that don't behave well in design view. In that case you're probably going to want to turn them off.

[![image]({static}2007/07/image-thumb1.png){width="315" height="88"}]({static}2007/07/image1.png)

If you need to turn off the default split view, to prevent VS from hanging for several minutes till it's rendering attempts timeout, then you will need to go into the Options dialog and change the settings. Goto **Tools\>Options\>HTML Designer** and select the **Source View** setting. That will change the default mode that the page will open in. It's a great improvement on VS2005, where if you double clicked on a web form you had little option but to wait for it to timeout.

![image]({static}2007/07/image-thumb2.png){width="644" height="375"}

If you've got a wide screen display, you might want to check "**Split views vertically**", to allow you to see more lines of source.
