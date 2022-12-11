---
title: Knowledge Graphs 7 - Named Graphs
date: 2019-11-06 14:08
author: aabs
category: Semantic Web
ignored-tags: knowledge graphs, RDF
slug: knowledge-graphs-7-named-graphs
status: published
attachments: 2019/11/kamen-atanassov-xhqhvakoazg-unsplash.jpg
---

Knowledge Graphs provide a neat and easy way to segment your data, called
'*Named Graphs*'. This post shows how you access them, and different uses they
may be put to.




This is part 7 of an ongoing series providing a little background on *Knowledge Graphs*. The aim is to let software developers get up to speed as fast as possible. No theory, no digressions, and no history. Just practical knowledge.

-   [Knowledge Graphs 101](https://andrewmatthews.blog/2019/09/12/knowledge-graphs-101/)
-   [Knowledge Graphs 2 – Playing on the CLI](https://andrewmatthews.blog/2019/09/13/knowledge-graphs-2-playing-on-the-cli/)
-   [Knowledge Graphs 3 – Using a Triple Store](https://andrewmatthews.blog/2019/09/13/knowledge-graphs-3-using-a-triple-store/)
-   [Knowledge Graphs 4 – Querying your knowledge graph using .NET](https://andrewmatthews.blog/2019/09/16/knowledge-graphs-4-querying-your-knowledge-graph-using-net/)
-   [Knowledge Graphs 5 – Modelling with RDFS](https://andrewmatthews.blog/2019/10/03/knowledge-graphs-5-modelling-with-rdfs/)
-   [Knowledge Graphs 6 - Semantics](https://andrewmatthews.blog/2019/10/03/knowledge-graphs-6-semantics/)
-   [Knowledge Graphs 7 - Named graphs](https://aabs.wordpress.com/2019/11/06/knowledge-graphs-7-named-graphs/)

Named graphs are a useful feature, providing ways to segregate and independently managed subsets of the data. At first glance they seem akin to tables in SQL. But they TOTALLY AREN'T. Let's take a look at what they are, and how different folks use them.

Inserting data into a NAMED GRAPH
---------------------------------

Inserting data into a named graph is easy - you enclose the triples you wish to create in a graph block:

```
PREFIX s: <http://tempuri.com/soccer/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

INSERT DATA {
    GRAPH s:ArsenalFC {
        s:ArsenalFC a s:Team;
            s:homeCity s:London;
            rdfs:label "Arsenal F.C." .
    }

    GRAPH s:ChelseaFC {
        s:ChelseaFC a s:Team;
            s:homeCity s:London;
            rdfs:label "Chelsea F.C." .
    }

    GRAPH s:LiverpoolFC {
        s:LiverpoolFC a s:Team;
            s:homeCity s:Liverpool;
            rdfs:label "Liverpool F.C." .
    }
}
```

This creates three graphs (or adds to them if they already existed) with subsets of the data. Here, we are putting  `s:ArsenalFC` data just in the graph of the same name. That's convenient, because you only need to know the name of the team to know what graph its data is stored in.

Finding Graphs and Their Data
-----------------------------

You can query for the graph URI at the same time as binding any other variable in the data. Here, I will get the team data and the graph URI out together:

```
PREFIX s: <http://tempuri.com/soccer/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT *
WHERE {
    GRAPH ?graph {
        ?team a s:Team;
            s:homeCity ?city;
            rdfs:label ?name .
    }
}
```

which gives us

```
------------------------------------------------------------------
| team          | graph         | city        | name             |
==================================================================
| s:ArsenalFC   | s:ArsenalFC   | s:London    | "Arsenal F.C."   |
| s:ChelseaFC   | s:ChelseaFC   | s:London    | "Chelsea F.C."   |
| s:LiverpoolFC | s:LiverpoolFC | s:Liverpool | "Liverpool F.C." |
------------------------------------------------------------------
```

So, quite naturally, if I wanted to restrict myself to everything we know about Arsenal, that's quite easy:

```
PREFIX s: <http://tempuri.com/soccer/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT *
WHERE {
    GRAPH s:ArsenalFC {
        ?s ?p ?o .
    }
}
```

giving us

```
---------------------------------------------
| s           | p          | o              |
=============================================
| s:ArsenalFC | s:homeCity | s:London       |
| s:ArsenalFC | rdf:type   | s:Team         |
| s:ArsenalFC | rdfs:label | "Arsenal F.C." |
---------------------------------------------
```

### Everything everything

If you want to get everything back from your triple store, and this varies somewhat between triple stores, then you need to get the union of named graphs combined with the **default graph**.

```
PREFIX s:
PREFIX rdfs:

SELECT *
WHERE {
  {
    GRAPH ?g {
        ?s ?p ?o .
    }
  }
  UNION
  {
    ?s ?p ?o .
  }
}
```

The way this works is defined in the \[SPARQL spec\](https://www.w3.org/TR/sparql11-query/\#queryDataset), but there still seems to be some variance in implementations between vendors. For example, we see \[this\](https://docs.aws.amazon.com/neptune/latest/userguide/best-practices-sparql-query.html) guidance from Amazon. They have chosen to return the  `RDF Merge `of all named graphs in addition to the default graph.

### Another way to pull from a named graph

Another convenient syntax for pulling from a specific named graph is shown here. Let's get back everything from Liverpool this time:

```
PREFIX s: <http://tempuri.com/soccer/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT *
FROM s:LiverpoolFC
WHERE {
  ?s ?p ?o .
}
```

```
-------------------------------------------------
| s             | p          | o                |
=================================================
| s:LiverpoolFC | s:homeCity | s:Liverpool      |
| s:LiverpoolFC | rdf:type   | s:Team           |
| s:LiverpoolFC | rdfs:label | "Liverpool F.C." |
-------------------------------------------------
```

This approach to pulling all the data back from a graph is one of several approaches to *bulk retrieval*. This is a convenient way to perform local analysis or processing on a cohesive subset of the data.

Common Uses for Named Graphs
----------------------------

Now we've seen a few different ways to insert and retrieve data from a named graph, let's take a brief, non-judgemental, looks at the various ways that people use the named graph feature.

### Bulk Retrieval

One simple purpose to named graphs is to lump together a bunch of data that you are likely to want to get back at the same time. SPARQL 1.1 Query standard provides a simple RESTful mechanism to pull the entire contents of a graph in one pass.

```
GET /rdf-graph-store?graph=http%3A//www.example.com/other/graph HTTP/1.1
   Host: example.com
   Accept: text/turtle; charset=utf-8
```

This is particularly useful if you want to be able to dynamically process the contents of the graph by walking it locally. It allows you to employ graph algorithms that would be prohibitively expensive if you had to factor in network latency for walking each edge of the graph.

### Tracking Where Data Came From

If you can provide information, such as as a URL, to identify where the contents of a graph came from, then it can often be useful to keep track of that for provenance purposes. Many common frameworks will load incoming data from a file loader into a named graph where the URI of the graph identifies where the data came from. This is popular in the Linked Data community, where the gathering and merging of data from multiple sources means the provenance and trustworthiness of data sources must be tracked, in case of disputed conclusions.

### Replicate the data in a Graph

Another way to use a named graph is as a temporary storage mechanism, allowing the state of the graph to be captured, duplicated or transmitted. This might be done to allow in-place modifications with the option of rollback.

### Tracking data versions and updates

Similarly, one might systematically label duplicate copies of data to allow the tracking of how the data changed over time. This is similar to approach above.

### Control Access to data

Some triple store platforms allow the definition of security access controls on a per-graph basis. In that case the named graph can be used to support mechanisms like tenancy and ownership of data.

### Attach Metadata to the graph rather than its contents

Lastly, the cool thing about having all your data in a graph identified by a URI is that you can then make a whole bunch of statements about that graph.

```
PREFIX s: <http://tempuri.com/soccer/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX staff: <http://industrialinference.com/staff/>

INSERT DATA {
    GRAPH s:ArsenalFC_Imported {
        s:ArsenalFC a s:Team;
            s:homeCity s:London;
            rdfs:label "Arsenal F.C." .
        # etc etc etc
    }
    # . . .
    GRAPH s:Stats_Import_Metadata {
        s:ArsenalFC_Imported a :Graph;
            s:statsKind "Goal Averages";
            s:keyEntityDescribed s:ArsenalFC;
            dc:creator staff:andrewm;
            dc:publisher "Football Association";
            dc:date  "2017-01-07";
            dc:title "Arsenal Stats";
            dc:description "Arsenal Stats from FA site" ;
            dc:language "en" .
        # etc etc etc
    }
}
```

The potential for this kind of easily augmented and expanded metadata is limitless. There's a single place to go for all the metadata, and it can tell you with a short query what kinds of data we have in graphs. Let's see what Goal Averages stats we have on Arsenal:

```
PREFIX s: <http://tempuri.com/soccer/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>

SELECT *
WHERE {
    GRAPH s:Stats_Import_Metadata {
        ?statsDataSet
            s:statsKind "Goal Averages";
            s:keyEntityDescribed s:ArsenalFC;
            dc:creator ?creator;
            dc:publisher ?publisher;
            dc:date ?creationDate;
            dc:title ?title;
            dc:description ?description .
    }
}
```

Summary
-------

In this installment, I showed you Named Graphs, how to insert data into them, how to get it back out, then mentioned a few cool ways to use them to help organise your data.

There's surely a lot more to say about this topic, but I was in danger of getting writer's block. Instead, please let me know what topics you are interested in so I can cover them at some point.

Next time, I hope to investigate the topic of inference, showing a few ways this can be done, and introducing you to a little side project I have been working on that might one day yield a useful inference engine in .NET.
