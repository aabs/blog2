---
title: Keeping a Developer's Lab Book
date: 2006-11-21 05:14
author: Andrew Matthews
tags: programming, Work
slug: keeping-a-developers-lab-book
status: published
---
Attachments: 2006/11/labbook1.PNG

Despite having used a laptop at work for years, I've always kept a paper notebook by my side. I depend on these notebooks. I even purchased the whole UK supply of Paperchase's 500 page, leatherette, squared, rounded notebooks. These beauties are un-dog-ear-able, perfect for UML diagrams, lightweights and relatively inexpensive. The supply in the UK was dwindling when I discovered them in Cambridge. Apparently the Japanese manufactured them, and the Americans were buying whatever stocks were left. I acted fast and bought the outstanding stock from all the major branches in the UK. It only filled a small box, but ought to keep me supplied with notebooks for about the next 15 years. I doubt that with the current screen resolution, tablet PCs are going to topple them in my affections any time soon.

Anyway, I soon found that it's all very well to have a notebook, but to make good use of it you should treat it as a kind of lab book. When I am stumped by a problem that I have been trying to tackle, I often find that deadline induced panic can lead me to blindly try every possible solution, one after the other, churning the code up and getting me nowhere. I find that at times like those I can enforce a bit of discipline on myself by using a lab book methodology to state the problem and work through to the solution. Obviously, the kind of information that a developer and a scientist at the bench need to maintain are very different, but the nature of what they do is similar. They march out into the unknown, partially armed with nothing to defend them but what they already know and some discipline. The timescales that developers are expected to deliver results in are much shorter, which is why they tend to panic and cut corners more often.

I start out by stating the problem. The key thing here is not to state what you think is causing the problem. Don't say "*the XML file is not well formed*", put "*I can't load the config file*" or better still "*the program won't start*". A lot of the advice for keeping a lab book stems from laboratory work, where to make an experiment repeatable you must keep notes on what you are going to do and what the outcome was. Similarly, in a programmer's notebook you need to keep track of what you did and the outcome in order to be able to rule out paths of enquiry. I generally tend to use the following headings:

1.  PROBLEM
2.  KNOWN
3.  IDEAS
4.  TESTS
5.  QUESTIONS

Each of these helps you to keep track of what you know about the problem, what ideas you had, and how they panned out. I've used this successfully on both bug solving and design issues.

In the PROBLEM area I make a statement of what the problem is, without making any assumptions about the cause of the problem. That can often lead me to make pretty dumb statements in this section initially. Later on, when you know more you can extend this or revise it with a more accurate statement of the problem. The key thing is not to prejudice the whole problem solving process by ruling out whole lines of enquiry prematurely.

After stating the problem, I make as many entries in the KNOWN section as I can. These will be bare statements of what I can be absolutely sure is true. Generally in the course of diagnosing a bug, I will already have tried a few things, before I resort to the lab book. I take note of these, plus anything else I know, such as requirements or constraints in the case of designs. Looking at these will eventually force you to produce a few ideas. These go in the IDEAS section.

Eventually, whether bug-squashing or designing, you will be faced with a problem and you'll be at a loss. You need to get your head around the problem. That's what the KNOWN section helps you to do. Ultimately, and inevitably, you will have an idea (probably lots of them). You write them down in the IDEAS section. This can be any kind of prejudiced statement you like. It is the correct place for statements like "*The XML file is not well formed".* It's a hypothesis that you will need to check out. In the case that ideas come like buses, you might want to note them all at once. Then check each one at a time, or pursue a promising line of enquiry first, then go back to the ideas backlog if you don't get anywhere. You might also find that while your idea is easy to formulate, it can be hard to test. That's where the TESTS section comes in.

In TESTS you describe ways to validate the hypothesis you made in the ideas section. You use these to make additions to the KNOWN section. Every time you perform one of the tests you should be able to add something to the KNOWN section. If you weren't able to add anything to KNOWN, then your test was wasted. Quite often one of these tests will yield the solution you are after. If you are designing, these tests might be in the form of a proof of concept for a design or idiom.

If all else fails you need to start thinking about what you don't know. The QUESTIONS section allows you to make use of questions as a way to prompt you to add new things to the known section or to devise new tests to get something to put in the known section. It is a kick start on your imagination – I always find that if I get to this stage, my questions never struggle to come out and before long they start turning into ideas.

You can think of it as an algorithm for generating knowledge about a domain. It's very simple, and not exactly the heavyweight scientific method, but I know that when you get this method out, there isn't a problem you can't solve.

[![labbook1.PNG]({static}2006/11/labbook1.PNG)]({static}2006/11/labbook1.PNG "labbook1.PNG")
[**Figure 1. A little flowchart showing how you feed information into the known section.**]{style="font-size:9pt;color:#4f81bd;"}

Update \[23rd April 2007\]

Paperchase Australia now has the leatherette notebooks back on sale, after an absence of a couple of years. Good news for the scribblers out there. Bad news for Moleskine and other makers of crap (but stylishly expensive) notebooks.
