---
title: Formatting in Data Bound Controls
date: 2006-09-06 14:15
author: Andrew Matthews
ignored-tags: ASP.NET, programming
slug: formatting-in-data-bound-controls
status: published
---

I recently ran across a problem with data bound controls in ASP.NET, where I set the string formatting specification (by the book) and nothing happened. If you come across this problem you are probably missing the HtmlEncode attribute on your column specification. Without this the braces are probably encoded and thus the formatting string is unrecognisable to the control. Consider adding the []{style="font-size:10px;font-family:Courier New;"}[HtmlEncode]{style="color:red;"}[="false" ]{style="color:blue;"}to your binding specifications - it worked for me.
