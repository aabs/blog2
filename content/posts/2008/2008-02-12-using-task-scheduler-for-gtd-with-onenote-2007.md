---
title: Using Task Scheduler For GTD with OneNote 2007
date: 2008-02-12
author: Andrew Matthews
category: SemanticWeb
slug: using-task-scheduler-for-gtd-with-onenote-2007
status: published
attachments: 2008/02/image4.png, 2008/02/image-thumb2.png, 2008/02/image.png, 2008/02/image-thumb.png, 2008/02/image-thumb3.png, 2008/02/image5.png, 2008/02/image-thumb4.png, 2008/02/image1.png, 2008/02/image-thumb5.png, 2008/02/image2.png, 2008/02/image3.png, 2008/02/image-thumb1.png
---

[Aymeric Gaurat-Apelli](http://aymeric.gaurat.net/), against my will, has got me hooked on using OneNote, and like many people I started using it for organisation with [GTD](http://www.google.com.au/url?sa=t&ct=res&cd=1&url=http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FGetting_Things_Done&ei=SMmwR-ngHqTIswKI0qnwCQ&usg=AFQjCNHi9227WDd1uvPMy9kZTRrMcKJIxA&sig2=k1UKesK9RZVMxE_zsdAEXA). I set up my OneNote the way that Rob from [7Breaths](http://www.blog.7breaths.co.uk) described in his [great blog series](http://www.blog.7breaths.co.uk/2007/04/gtd-with-onenote-set-up.html). But I found that I still need a little prompting from time to time. So I found a neat way to shove OneNote in my face at the beginning and end of every day to 'gently' persuade me to gather and process my tasks for the day.

If you've got your OneNote set up according to Rob's method, you'll have a TODAY section, and in that you'll gather your daily notes, clippings etc for later processing and organisation. I just added a couple of pages and then I invoke them at preset times of the day. Here's how you do it.

First Create your page in the TODAY section. It doesn't matter what you call it. I called mine the "*Brain Dump Area*":

[![image]({static}2008/02/image-thumb.png){width="570" height="414"}]({static}2008/02/image.png)

See what I mean about gentle? Next I create a scheduled task using the (for Vista) Task Scheduler. You'll find this in your admin tools menu off the start menu:

[![image]({static}2008/02/image-thumb1.png){width="426" height="128"}]({static}2008/02/image1.png)

in the task pane, select "Create Basic Task"

[![image]({static}2008/02/image-thumb2.png){width="272" height="197"}]({static}2008/02/image2.png)

Give it a name

[![image]({static}2008/02/image-thumb3.png){width="714" height="496"}]({static}2008/02/image3.png)

Select a daily task, run on whatever schedule you like, then click through to actions, and select the "Start a Program" option

[![image]({static}2008/02/image-thumb4.png){width="334" height="92"}]({static}2008/02/image4.png)

You'll be presented with an option to enter the program location, some command line arguments and an optional area to select where the program gets run. Locate your instance of OneNote (mine's at "C:\\Program Files\\Microsoft Office\\Office12\\ONENOTE.EXE") and enter its path in the program area. Then go to OneNote and navigate to the page you created, and right click on the page tab. Select the "Copy Hyperlink to this Page" option, and then go back to Task Scheduler.

[![image]({static}2008/02/image-thumb5.png){width="296" height="230"}]({static}2008/02/image5.png)

In the "Add Arguments (optional):" text box enter: **/hyperlink ""** and between the quotes paste the hyperlink from the page you created in OneNote. Mine looked like this:

**/hyperlink "onenote://C:/Users/Andrew%20Matthews/Documents/OneNote%20Notebooks/GettingThingsDone/
TODAY.one\#Brain%20Dump%20Area&section-id={DD18A524-CB73-47D9-A152-778C2116DA01}&
page-id={0F370401-83D6-4BB3-B2CC-7266A16395B7}&end"**

Yours will be different, but similar. Click through to the finish button, and you're done. If you right click on the task entry and select Run, you can see what it will do. It starts OneNote selecting the Brain Dump Page for immediate display.

Now all I have to do is resist the urge to hit Snooze, and I'll be really organised.
