---
title: Using RDF and C# to create an MP3 Manager - Part 3
date: 2007-05-08 09:07
author: Andrew Matthews
tags: C#, Computer Science, LINQ, programming, software
slug: using-rdf-and-c-to-create-an-mp3-manager-part-3
status: published
---

Last time I hurriedly showed you how you can perform the next step of converting a triple store into an ORM system of sorts. The purpose of all this activity, and the reason I left off blogging about LINQ was that I am working on a system to allow me to use LINQ with a triple store and reasoner. The benefit of doing so is that we should have a lot of the benefits of the modern relational world with the power and connectivity of the new world of the semantic web. In this post I shall outline the steps required to start working with LINQ to RDF (as I've chosen to call it through lack of imagination).

I've been using test driven development throughout, so I already have a few 'integration' unit tests to show you:

`[TestMethod] public void Query() {   string urlToRemoteSparqlEndpoint = "http://localhost/MyMusicService/SparqlQuery.ashx";   RdfContext<Track> ctx = new RdfSparqlContext<Track>(urlToRemoteSparqlEndpoint);   var titles = from t in ctx     where t.Year > 1998 &&     t.GenreName == "Ambient Techno" ||     t.GenreName == "Chillout"     select t.Title;   foreach(string title in titles)     Console.WriteLine(title); }`

In English, this means that rather than manipulating a local triple store, I want the RdfSparqlContext to compose a SPARQL query and present it to the query endpoint found at location urlToRemoteSparqlEndpoint. I then want it to deserialise the results returned and store them in titles. This is a nice mixture of new features from .NET 3.5, combined with some of the features I've already developed for object deserialisation.

With the example above I am concerned more with the querying aspect of LINQ (it being a query language n' all!) but that is not much use to me in the world of transactional web development where I find myself mired for the moment, so we need full CRUD behaviour from this system. Here's a unit test for object update.

`[TestMethod] public void Update() {   string urlToRemoteSparqlEndpoint = @"http://localhost/MyMusicService/SparqlQuery.ashx";   RdfContext<Track> ctx = new RdfSparqlContext<Track>(urlToRemoteSparqlEndpoint);   var q = from t in ctx     where t.Year > 1998 &&     t.GenreName == "Ambient Techno" ||     t.GenreName == "Chillout"     select t;   foreach (Track t in q)     t.Rating = 5;   ctx.AcceptChanges(); }`

Here, I'm getting a bunch of objects back from the triple store, modifying their Rating property and then asking for those changes to be stored. This follows the usage patterns for LINQ to SQL.

To satisfy these unit tests (plus ones for the rest of the CRUD behaviour and with support for N3, in-memory and RDBMS based local triple stores is what I'm aiming to complete - eventually. Here's the general scheme for implementing querying using LINQ. It assumes that RDF data structures are taken unmodified from the SemWeb library.

-   Create a Query Object (I guess this would be our RdfContext class above)
-   Implement IQueryable\<T\> on it.
-   When the enumerable is requested, convert the stored expression tree into the target language
-   Present it to whatever store or endpoint is available,
-   Deserialise the results into objects
-   Yield the results (probably as they are being deserialised)

This is a very broad outline of the tasks. I'll explain in a lot more depth in subsequent posts, as I tackle each step.
