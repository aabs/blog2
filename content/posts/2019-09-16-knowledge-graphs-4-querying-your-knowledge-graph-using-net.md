---
title: Knowledge Graphs 4 - Querying your knowledge graph using .NET
date: 2019-09-16 12:54
author: aabs
category: .NET, programming, Semantic Web
tags: .NET, knowledge graphs, RDF
slug: knowledge-graphs-4-querying-your-knowledge-graph-using-net
status: published
attachments: 2019/09/jonas-jacobsson-hdjeq7-a-yq-unsplash.jpg
---

This installment leaves the CLI behind to show how we consume a knowledge graph
within our programmatic environments. The framework I use to work with RDF is
[dotNetRdf](http://www.dotnetrdf.org/).




This is part 4 of an ongoing series providing a little background on '*knowledge graphs*'. The aim is to let software developers get up to speed as fast as possible. No theory, no digressions, and no history, just practical knowledge.

-   [Knowledge Graphs 101](https://andrewmatthews.blog/2019/09/12/knowledge-graphs-101/)
-   [Knowledge Graphs 2 – Playing on the CLI](https://andrewmatthews.blog/2019/09/13/knowledge-graphs-2-playing-on-the-cli/)
-   [Knowledge Graphs 3 – Using a Triple Store](https://andrewmatthews.blog/2019/09/13/knowledge-graphs-3-using-a-triple-store/)
-   [Knowledge Graphs 4 – Querying your knowledge graph using .NET](https://andrewmatthews.blog/2019/09/16/knowledge-graphs-4-querying-your-knowledge-graph-using-net/)
-   [Knowledge Graphs 5 – Modelling with RDFS](https://andrewmatthews.blog/2019/10/03/knowledge-graphs-5-modelling-with-rdfs/)
-   [Knowledge Graphs 6 - Semantics](https://andrewmatthews.blog/2019/10/03/knowledge-graphs-6-semantics/)
-   [Knowledge Graphs 7 - Named graphs](https://aabs.wordpress.com/2019/11/06/knowledge-graphs-7-named-graphs/)

There are a couple of different ways to make queries and get results back from SPARQL. They have different strengths, so I will show both and try to briefly explain where they would be best used. First let's get the preliminaries out of the way.

Get dotNetRdf with Nuget
------------------------

DotNetRdf is a framework for RDF processing that has been around for a while. it covers quite a few of the usage scenarios you are likely to have, but for my purposes, it is its SPARQL capabilities and its local in-memory graph capabilities that I care about. To get started, create a .NET project and add the nuget package.

```
dotnet add package dotNetRDF --version 2.2.0
```

Remote Connections and Connection Strings
-----------------------------------------

When working with SPARQL in dotNetRdf, the easiest way to go is to create a

```
var rqp = new RemoteQueryProcessor(new SparqlRemoteEndpoint(new Uri("https://my.remote.endpoint/sparql")))
```

Similarly, when you are aiming to insert or update data, you use a remote update processor.

```
var rup = new RemoteUpdateProcessor(new SparqlRemoteUpdateEndpoint(new Uri("https://my.remote.endpoint/sparql")))
```

How to perform a basic query
----------------------------

When you query, all the same principles apply as when you work with a relational database in SQL. You establish a connection to the remote store. Then, you build queries using predefined templates. You use a dedicated API to insert variables and params into the query as you build it. As with SQL, don't allow SQL/SPARQL injection attacks. Instead, use the automatic escaping facilities of the query API to convert your query parameters to a format compatible with SPARQL.

```
var QueryProcessor = new RemoteQueryProcessor(
    new SparqlRemoteEndpoint(
        new Uri("https://my.remote.endpoint/sparql")));
SparqlParameterizedString queryString = new SparqlParameterizedString(); //1
queryString.Namespaces.AddNamespace("ex", new Uri("http://example.org/ns#")); //2
queryString.CommandText = "SELECT * WHERE { ?s ex:property @value }";//3
queryString.SetUri("value", new Uri("http://example.org/value"));//4
SparqlQueryParser parser = new SparqlQueryParser();//5
SparqlQuery query = parser.ParseFromString(queryString);//6
var results = (SparqlResultSet) QueryProcessor.ProcessQuery(query); //7
foreach (var result in results)//8
{
    Console.WriteLine($"s is {result["s"].ToValuedNode()}");//9
}
```

Let's take each of these things in turn.

1.  The  `SparqlParameterisedString` is a bit like a cross between a string builder and a query parser. It is able to escape params as they are inserted and manage the collection of namespaces used. It makes sure that when the query template is expanded, all of the URIs, and data types used in the query make sense. It also makes sure that all arguments are bound to some value.
2.  Here we add a namespace to allow its prefix to be used in the Turtle and TriG parts of the SPARQL query.
3.  This is the actual body of the SPARQL Query. Notice that the query arguments are prefixed with the  `@` symbol. Variables in the query are prefixed by  `? `. These are what get filled in by the query engine, to yield different results.
4.  Here we supply a value to bind to the query argument  `@value `. This is a URI, but is doesn't need to be. You could call the  `SetLiteral` function instead to supply a data argument to the query, which is handy when inserting data into the graph.
5.  The parser builds an in memory graph based representation of the query, for validation and for expansion of all parameters.
6.  The query is parsed and all parameters are escaped and inserted into the query with proper quoting applied. It makes sure that all arguments are bound to some value.
7.  The query is passed to the query processor for transmission to the remote triple store. Depending on what kind of SPARQL query you use, the results are sent back in different forms. In this case, we get the results back in tabular form because we used the SELECT query form.
8.  The results table (sets of bindings) are enumerable
9.  The individual results are indexed by ordinal or name (just like a DataSet). The data does need to be converted out of RDF literal format (based on XML Schema Datatypes).

If you have any familiarity with implementing data access frameworks you will see parallels between this little sequence, and the equivalent process used for frameworks like ADO.NET or ODBC/JDBC. When all's said and done, the problem is much the same whether you are using relational or graph based databases.

Inserting data into your graph
------------------------------

Inserting data into the knowledge graph is similar:

```
var UpdateProcessor = new RemoteUpdateProcessor(
    new SparqlRemoteUpdateEndpoint(
        new Uri("https://my.remote.endpoint/sparql"))); //1
SparqlParameterizedString queryString = new SparqlParameterizedString();
queryString.Namespaces.AddNamespace("ex", new Uri("http://example.org/ns#"));
queryString.CommandText = @"INSERT DATA
                    {
                        @playerId rdf:type n:Player ;
                            foaf:givenName @givenName;
                            foaf:familyName @familyName.
                    }
                "; //2
queryString.SetUri("playerId", new Uri("http://example.org/player/5"));
queryString.SetLiteral("givenName", "eric");//3
queryString.SetLiteral("familyName", "Cantona);
var parser = new SparqlUpdateParser();
var query = parser.ParseFromString(queryString);
query.Process(UpdateProcessor);//4
```

This process is very much the same, but using the Update side of the API rather than the query one.

1.  Create an update processor to talk to the same endpoint
2.  This query uses the  `INSERT DATA` query form. This adds a graph pattern to the knowledge graph.
3.  In addition to URI arguments to the query template, you can add literal data to the query. Normally it gets the escaping right. There are ways to override if you are using something obscure for your data types.
4.  As with something like ADO.NET, you present updates and don't get a result set.

Making sense of results
-----------------------

A  `SparqlResultSet` is formatted according to the [specification here](https://www.w3.org/TR/sparql11-results-json/). The section  `#select_bindings` describes how the results are formatted as they are passed back. Essentially, they are in much the same format that they use when they are in the triple store. For our immediate purposes, that means they are either a  `Uri` node or a  `Literal` Node. There are other types, but I'm ignoring them for now.

I usually have some sort of switch statement to extract data from the result bindings. I normally use type information gleaned from reflection or some other kind of mapping API to tell me how to extract and convert the data when filling the properties of some result POCO.

```
protected object GetNodeValue(Type propertyType, INode node)
{
    var vn = node.AsValuedNode();
    if (propertyType == typeof(bool))
    {
        return vn.AsBoolean();
    }

    if (propertyType == typeof(DateTime))
    {
        return vn.AsDateTime();
    }

    if (propertyType == typeof(DateTimeOffset))
    {
        return vn.AsDateTimeOffset();
    }

    if (propertyType == typeof(decimal))
    {
        return vn.AsDecimal();
    }

    if (propertyType == typeof(double))
    {
        return vn.AsDouble();
    }

    if (propertyType == typeof(float))
    {
        return vn.AsFloat();
    }

    if (propertyType == typeof(int))
    {
        return vn.AsInteger();
    }

    if (propertyType == typeof(string))
    {
        return vn.AsString();
    }

    if (propertyType == typeof(TimeSpan))
    {
        return vn.AsTimeSpan();
    }

    throw new RdfTypeUnknownException($"Unable to inject RDF literals into properties of type: {propertyType.FullName}");
}
```

These low level data conversion APIs I quickly hide behind a higher level fluent API, to allow me to build a function to quickly extract the data repeatably:

```
private void CreateProjectors()
{
    teamProjector = Project.Onto<TeamOfPlayer>()
        .WithInstanceId("PlayerId")
        .Mapping("rdfs:label", "Name")
        ;

    playerProjector = Project.Onto<Player>()
        .WithInstanceId("PlayerId")
        .Mapping("foaf:givenName", "GivenName")
        .Mapping("foaf:familyName", "FamilyName")
        .Filling("Teams",
                    teamProjector.BuildSequence(),
                    wc => wc.Incoming("n:withPlayer").Outgoing("n:withTeam"));
}
```

This mapper example also uses a graph walking system I will cover in a later installment.

Pulling graphs to avoid cross-product result sets
-------------------------------------------------

The standard SPARQL  `SELECT` query gets results back in a tabular form. That means that if you present it with a query like this:

```
SELECT ?teamId ?playerId
WHERE {
    ?teamId a s:Team;
    ?playerId a s:Player;
        s:playsFor ?team .
}
```

If you have a lot of players playing for the team, the team related result fields will get duplicated for each player. Probably not a problem if your data quantities are small, but when they get big the wasted bandwidth might be significant.

I find that the main annoyance comes when you try to extract your results out into an object graph of POCOs (plain old C\# objects), where you ideally only want one team for all of the players. In that case you need potentially quite complex logic to help you ignore the redundant fields passed back for most of the players. This get ridiculously complex beyond a couple of links.

Instead of trying to recreate a graph structure (of POCOs) out of a tabular data structure, which doesn't really scale, it is often easier to just pull a whole graph back from the triple store in one pass. That's what the  `CONSTRUCT` and  `CONSTRUCT WHERE` query forms come in.

 `CONSTRUCT` returns to you the graph structure that you bound in your graph matching query. The result returned from the Query processor is, rather than a  `SparqlResultSet `, a  `Graph` which is pretty much a little in-memory triple store you can mine for the data you need to rebuild your object graph. Here's an example from the world of soccer, where we want to build a graph for a specific player, pulling back all the teams that they currently might play for.

```
CONSTRUCT {
    ?playerId a n:Player;
        foaf:givenName ?playerGivenName;
        foaf:familyName ?playerFamilyName.

    ?c a n:Contract;
        n:withPlayer ?playerId;
        n:withTeam ?teamId.

    ?teamId a n:Team;
        rdfs:label ?teamName.
}
WHERE
{
    BIND(@player as ?playerId)
    ?playerId a n:Player;
        foaf:givenName ?playerGivenName;
        foaf:familyName ?playerFamilyName.
    OPTIONAL
    {
        ?teamId a n:Team;
            rdfs:label ?teamName.

        ?c a n:Contract;
            n:withPlayer ?playerId;
            n:withTeam ?teamId.
    }
```

I've found this a very powerful way to pull back a whole bunch of related data in a single pass, when I can anticipate that the data will be needed, or where the latency cost of repeated calls to the database is too much to bear.

Summary
-------

This is a pretty code intensive post, and to make it short enough I've had to leave some things to your imagination. I showed how to connect to the query and update APIs of a triple store using dotNetRdf. I showed the anatomy of typical  `INSERT` and  `SELECT` queries. I showed some of the typical boilerplate related to getting data into a POCO format from XSD data. This is normally handled for you by platforms like WCF etc, but here we have to do it ourselves. Lastly I showed a neat way to pull back a graph, which is much nicer for deserializing POCOs.

Next time I will show how I create a simple API to walk a ***local*** in-memory graph (in a way similar to [Gremlin](https://en.wikipedia.org/wiki/Gremlin_(programming_language))) to allow me to easily extract data from the graph when I know what I am looking for.

Meanwhile, please let me know if this series is useful to you in what you are doing.
