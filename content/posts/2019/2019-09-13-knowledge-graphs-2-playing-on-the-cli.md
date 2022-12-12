---
title: "Knowledge Graphs 2 - Playing on the CLI"
date: 2019-09-13
author: Andrew Matthews
tags: ["rdf", "knowledge graphs", "sparql"]
---

Last time I showed how to write RDF in Turtle, and how to make very simple queries in SPARQL. What I didn't show was how to get your hands dirty. Specifically, I want to show you how to try things out on the ~~cheap~~ command line. I will show examples of how to build out your RDF data to more depth using Turtle files, and how to use the Jena framework to create queries against that data, so you can work out ahead of time how to navigate your graph of data.




-   [Knowledge Graphs 101](https://andrewmatthews.blog/2019/09/12/knowledge-graphs-101/)
-   [Knowledge Graphs 2 – Playing on the CLI](https://andrewmatthews.blog/2019/09/13/knowledge-graphs-2-playing-on-the-cli/)
-   [Knowledge Graphs 3 – Using a Triple Store](https://andrewmatthews.blog/2019/09/13/knowledge-graphs-3-using-a-triple-store/)
-   [Knowledge Graphs 4 – Querying your knowledge graph using .NET](https://andrewmatthews.blog/2019/09/16/knowledge-graphs-4-querying-your-knowledge-graph-using-net/)
-   [Knowledge Graphs 5 – Modelling with RDFS](https://andrewmatthews.blog/2019/10/03/knowledge-graphs-5-modelling-with-rdfs/)
-   [Knowledge Graphs 6 - Semantics](https://andrewmatthews.blog/2019/10/03/knowledge-graphs-6-semantics/)
-   [Knowledge Graphs 7 - Named graphs](https://aabs.wordpress.com/2019/11/06/knowledge-graphs-7-named-graphs/)

Step 1 - Get some local tools
-----------------------------

Assuming you are running on Linux, or have WSL installed on windows, you can easily get up and running using the Apache Jena toolkit.

To install Jena on Ubuntu/MacOS using LinuxBrew or HomeBrew.

```
$> brew install jena
```

To test it is installed, check it like so:

```
$> sparql -version
Jena:       VERSION: 3.12.0
Jena:       BUILD_DATE: 2019-05-27T16:07:27+0000
```

The `sparql`CLI tool is used to issue SPARQL queries against a local copy of the data. There is a corresponding tool called `rsparql`that allows you to query using the SPARQL Protocol with a remote W3C compliant triple store.

That's all we need to get started. Let's create a knowledge graph! This knowledge graph will be in the sporting domain, and I will build on it in future posts.

Step 2 - Query local data
-------------------------

Create a file called `soccer.ttl`to contain your data. I use Visual Studio Code, since there are some nice syntax highlighting plugins for Turtle files, but any editor will do.

```
@prefix : <http://tempuri.com/soccer/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix time: <http://www.w3.org/2006/time#>.
@prefix foaf: <http://xmlns.com/foaf/0.1/> .

:ArsenalFC a :Team;
    :homeCity :London;
    rdfs:label "Arsenal F.C." .

:LiverpoolFC a :Team;
    :homeCity :Liverpool;
    rdfs:label "Liverpool F.C." .

:PremierLeague a :FootballLeague;
    :hasMember :ArsenalFC, :LiverpoolFC .

:BerndLeno a :Footballer;
    foaf:givenName "Bernd";
    foaf:familyName "Leno".
:HectorBellerin a :Footballer;
    foaf:givenName "Héctor";
    foaf:familyName "Bellerín".
:KieranTierney a :Footballer;
    foaf:givenName "Kieran";
    foaf:familyName "Tierney".

:KepaArrizabalaga a :Footballer;
    foaf:givenName "Kepa";
    foaf:familyName "Arrizabalaga".

:AntonioRüdiger a :Footballer;
    foaf:givenName "Antonio";
    foaf:familyName "Rüdiger".

:MarcosAlonso a :Footballer;
    foaf:givenName "Marcos";
    foaf:familyName "Alonso".


:Alisson a :Footballer;
    foaf:givenName "Alisson".
:NathanielClyne a :Footballer;
    foaf:givenName "Nathaniel";
    foaf:familyName "Clyne".
:Fabinho a :Footballer;
    foaf:givenName "Fabinho".

[] a :PlayerContract; :withTeam :ArsenalFC; :withPlayer :BerndLeno;
    :from "2019-01-01"^^xsd:date; :to "2020-01-01"^^xsd:date.
[] a :PlayerContract; :withTeam :ArsenalFC; :withPlayer :HectorBellerin;
    :from "2019-01-01"^^xsd:date; :to "2020-01-01"^^xsd:date.
[] a :PlayerContract; :withTeam :ArsenalFC; :withPlayer :KieranTierney;
    :from "2019-01-01"^^xsd:date; :to "2020-01-01"^^xsd:date.

[] a :PlayerContract; :withTeam :ChelseaFC; :withPlayer :KepaArrizabalaga;
    :from "2019-01-01"^^xsd:date; :to "2020-01-01"^^xsd:date.
[] a :PlayerContract; :withTeam :ChelseaFC; :withPlayer :AntonioRüdiger;
    :from "2019-01-01"^^xsd:date; :to "2020-01-01"^^xsd:date.
[] a :PlayerContract; :withTeam :ChelseaFC; :withPlayer :MarcosAlonso;
    :from "2019-01-01"^^xsd:date; :to "2020-01-01"^^xsd:date.

[] a :PlayerContract; :withTeam :LiverpoolFC; :withPlayer :Alisson;
    :from "2019-01-01"^^xsd:date; :to "2020-01-01"^^xsd:date.
[] a :PlayerContract; :withTeam :LiverpoolFC; :withPlayer :NathanielClyne;
    :from "2019-01-01"^^xsd:date; :to "2020-01-01"^^xsd:date.
[] a :PlayerContract; :withTeam :LiverpoolFC; :withPlayer :Fabinho;
    :from "2019-01-01"^^xsd:date; :to "2020-01-01"^^xsd:date.
```

Now let's write a simple SPARQL query, and store it in a query file (`*.rq`):

```
PREFIX : <http://tempuri.com/soccer/>

SELECT ?team
WHERE {
    ?team a :Team .
}
LIMIT 10
```

Use the `sparql`tool to make the query:

```
$> sparql --data=soccer.ttl --query=get_teams.rq

----------------
| team         |
================
| :ArsenalFC   |
| :ChelseaFC   |
| :LiverpoolFC |
----------------
```

Perhaps we want to find only the London teams? See how easy it is to *declare what must be true*, rather than perform some filtration operation? Of course, SPARQL does have FILTER operations, but you can go a long way without resorting to it.

```
PREFIX : <http://tempuri.com/soccer/>

SELECT ?team
WHERE {
    ?team a :Team ;
        :homeCity :London .
}
LIMIT 10
```

The results are as you would expect:

```
sparql --data=soccer.ttl --query=london_teams.rq
--------------
| team       |
==============
| :ChelseaFC |
| :ArsenalFC |
--------------
```

Summary
-------

In this installment, I showed how to build out your RDF data to more depth using Turtle files. I show how to use the Jena framework to create queries against that data, so you can work out ahead of time how to navigate the graph of data. In later installments I will show how to using dotNetRdf to query and update data into a remote triple store.

Please let me know if you have any questions or if any of the ideas are not clear. Also, let me know if there are aspects of knowledge graphs that you would like to hear more about.
