---
title: First Light!!!!!!!!
date: 2005-08-17 20:07
author: Andrew Matthews
tags: ORM
slug: first-light
status: published
---

No posts have been forthcoming on this blog, so far, but that doesn't mean I've been idle. Far from it! I've been hard at work till late at night working on the tidying up of the source code. Part of that involved coming up with a new name for the system. There is already a system on GotDotNet (seems like an orphan, but who can tell) called Norm, that is a .NET ORM system.

So I have renamed AabsNorm "Koan" which seems quite apt - a complex puzzle whose solution expands your perceptions. Very apt.

Anyway, Koan saw first light today with end to end operations retrieving a collection of data from the SqlServer 2000 Northwind database. That's more of an achievement that you might think. It involves reading schema data from the database, generation of a domain model, construction of object based queries, dynamic creation of targeted SQL queries for the target database, presentation of the target query to the back end API (ADO.NET/XML RAW in this case) retrieval of the data from the database, deserialisation of the data into domain objects and registration of those objects in an instance registry for sharing across AppDomain boundaries. All in all, things are going well. Most of the central code of the system now passes FxCop's analysis (at least in terms of naming conventions, validation, etc) so the code is way more readable than a month ago. I have also been working on Oaf, the Orm Abstraction Framework - Object Queries on Steroids!

There's still a long way to go. Pressing tasks involve targeting of OleDb rather than SqlClient APIs that will enable you to access anything for which a data provider has been written, specifically Access and MySql, the two other platforms I really want Koan to work on. That will take some time to achieve, but will be worth it in the end.
