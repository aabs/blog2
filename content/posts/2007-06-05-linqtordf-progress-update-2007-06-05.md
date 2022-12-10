---
title: LinqToRdf - Progress Update 2007-06-05
date: 2007-06-05 09:57
author: Andrew Matthews
tags: C#, LINQ, programming
slug: linqtordf-progress-update-2007-06-05
status: published
---

I've been given a week by work to try to make some progress on the LINQ to RDF query provider, and I'm glad to say that the query generation phase is now pretty much complete for SPARQL. It's amazing what a difference a full day can make to your progress, compared to trying to get as much done as I can when I'm on the train.

Last week when I blogged, I had the rough outlines of a SPARQL query, but it was missing quite a bit. There were also a few bits that were just plain wrong, such as commas separating SELECT parameters. That's been corrected now. The properties in the GraphPattern are also restricted to those that are mentioned in the FILTER clause, or the projection.

I've also added support for the OrderBy, Take and Skip operators, which correspond to the "ORDER BY", "LIMIT" and "OFFSET" clauses in SPARQL. The unit test I'm working with is looking pretty overweight now:

    [TestMethod]
    public void SparqlQueryWithTheLot()
    {
        string urlToRemoteSparqlEndpoint = @"http://someUri";
        TripleStore ts = new TripleStore();
        ts.EndpointUri = urlToRemoteSparqlEndpoint;
        ts.QueryType = QueryType.RemoteSparqlStore;
        IRdfQuery<Track> qry = new RDF(ts).ForType<Track>();
        var q = (from t in qry
            where t.Year == 2006 &&
            t.GenreName == "History 5 | Fall 2006 | UC Berkeley"
            orderby t.FileLocation
            select new {t.Title, t.FileLocation}).Skip(10).Take(5);
        foreach(var track in q){
            Trace.WriteLine(track.Title + ": " + track.FileLocation);
        }
    }

[](http://11011.net/software/vspaste)

Here's a sample of the query string that gets produced for it:

    @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
    @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
    @prefix xsdt: <http://www.w3.org/2001/XMLSchema#> .
    @prefix fn: <http://www.w3.org/2005/xpath-functions#>  .
    @prefix a: <http://aabs.purl.org/ontologies/2007/04/music#> .

    SELECT ?FileLocation ?Title
    WHERE {
    ?t a:year ?Year .
    ?t a:genreName ?GenreName .
    ?t a:fileLocation ?FileLocation .
    ?t a:title ?Title .
    FILTER {
    ((?Year)=(2006^^xsdt:int))&&((?GenreName)=("History 5 | Fall 2006 | UC Berkeley"^^xsdt:string))
    }
    }
    ORDER BY ?FileLocation
    LIMIT 5
    OFFSET 10

[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)Which is almost exactly what we want. I'm thinking it's about time to set up some kind of SPARQL server to test the queries for real. We also have to check whether the ObjectDeserialisationSink is capable of deserialising results from a SPARQL query as well as an RSQuary query.
