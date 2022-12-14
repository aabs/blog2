---
title: Søren on DBC
date: 2008-05-05
author: Andrew Matthews
category: .NET, functional programming, programming
ignored-tags: .NET, DBC
slug: s%c3%b8ren-on-dbc
status: published
---

Recently, [Søren Skovsbøll](http://skarpt.dk/blog) wrote a excellent follow up to a little post I did a while back on using [C\# 3.0 expression trees](http://industrialinference.com/2008/01/16/complex-assertions-using-c-30/) for representing predicates in design by contract. The conclusion of that series was that C\# was inadequate in lots of ways to the task of doing design by contract. Having said that, you can still achieve a lot using serialisation of object states and storage of predicates for running before and after a scope.

Søren was not happy with the format of errors being reported, nor the potential for massive serialisation blowout. Rather than comment on the blog, he went away and did something about it. And it's pretty good! Go [take a look](http://skarpt.dk/blog/?p=14), and then pick up the baton from him. Your challenge is to extract the parmeter objects from the expression trees of the predicates and take lightweight snapshots of the objects refered to. You also need a "platform independent" way to serialize objects for this scheme (i.e. one that doesn't depend on XmlSerialisation or WCF data contracts.

Think you can do it? Apply here! :P
