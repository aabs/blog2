---
title: Knowledge Graphs 3 - Using a Triple Store
author: Andrew Matthews
date: 2019-09-13
---

<!-- wp:paragraph -->
<p><a href="https://andrewmatthews.blog/2019/09/13/knowledge-graphs-2-playing-on-the-cli/">Last time</a> I showed you how to use CLI tools to build out your RDF data to more depth using Turtle files and how to query it using the Apache Jena CLI toolchain using SPARQL Query language.  This time I'll show how to insert and retrieve data from a remote triple store.  I'll continue using the CLI tools for now.</p>
<!-- /wp:paragraph -->

<!-- wp:more -->
<!--more-->
<!-- /wp:more -->

<!-- wp:list -->
<ul><li><a href="https://andrewmatthews.blog/2019/09/12/knowledge-graphs-101/">Knowledge Graphs 101</a></li><li><a href="https://andrewmatthews.blog/2019/09/13/knowledge-graphs-2-playing-on-the-cli/">Knowledge Graphs 2 – Playing on the CLI</a></li><li><a href="https://andrewmatthews.blog/2019/09/13/knowledge-graphs-3-using-a-triple-store/">Knowledge Graphs 3 – Using a Triple Store</a></li><li><a href="https://andrewmatthews.blog/2019/09/16/knowledge-graphs-4-querying-your-knowledge-graph-using-net/">Knowledge Graphs 4 – Querying your knowledge graph using .NET</a></li><li><a rel="noreferrer noopener" href="https://andrewmatthews.blog/2019/10/03/knowledge-graphs-5-modelling-with-rdfs/" target="_blank">Knowledge Graphs 5 – Modelling with RDFS</a></li><li><a href="https://andrewmatthews.blog/2019/10/03/knowledge-graphs-6-semantics/">Knowledge Graphs 6 - Semantics</a></li><li><a href="https://aabs.wordpress.com/2019/11/06/knowledge-graphs-7-named-graphs/">Knowledge Graphs 7 - Named graphs</a></li></ul>
<!-- /wp:list -->

<!-- wp:heading -->
<h2>Start a Triple Store</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>A quick recap - a Triple Store is a type of graph database conforming to standards provided by the W3C, for storing RDF data.  The standards proscribe various aspects of how the DB behaves, including how it responds to queries, formats result set and how it supports bulk data transport.  I may dig into that in more detail in a later post.  </p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>To get up and running quickly, get yourself a copy of docker and docker-compose.  Once you have done so, create a <code>docker-compose.yaml</code> with this manifest.   This installs Blazegraph DB.  The technology in Blazegraph is rumoured to be the same technology behind AWS Neptune (since AWS is rumoured to have hire a bunch of engineers from the company behind Blazegraph).</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">version: '3.7'
services:
    blazegraph:
        image: metaphacts/blazegraph-basic:2.2.0-20160908.003514-6
        hostname: blazegraph
        container_name: blazegraph
        ports:
            - "8889:8080"
            - "8890:80"</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>To run the triple store, in-memory, invoke docker-compose like so:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">$> docker-compose up -d

Creating network "blog_default" with the default driver
Creating blazegraph ... done</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>Let's hit the store with a query.  I don't expect to get anything back yet, but I do expect not to get any errors:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">rsparql --service='http://localhost:8889/blazegraph/namespace/kb/sparql/update' --query=./soccer/queries/get_teams.rq

--------
| team |
========
--------</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>Fine. it's up and running.  Now create a turtle file called <code>add_teams.rq</code>.  </p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code {"language":"jscript","makeURLsClickable":false} -->
<pre class="wp-block-syntaxhighlighter-code">PREFIX s: &lt;http://tempuri.com/soccer/>
PREFIX rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#>

INSERT DATA {
    s:ArsenalFC a s:Team;
        s:homeCity s:London;
        rdfs:label "Arsenal F.C." .

    s:ChelseaFC a s:Team;
        s:homeCity s:London;
        rdfs:label "Chelsea F.C." .

    s:LiverpoolFC a s:Team;
        s:homeCity s:Liverpool;
        rdfs:label "Liverpool F.C." .
}</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>This we will use to push some data into the store.  We use another tool from the Jena tool set, called <code>rupdate</code>, which allows the use of the <a href="https://www.w3.org/TR/sparql11-update/">SPARQL Update</a> class of operations - in other words, it allows us to insert, update and delete RDF in our triple store.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">rupdate --service='http://localhost:8889/blazegraph/namespace/kb/sparql/update' --update=./add_teams.rq</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>Now when we re-present our query earlier, it should give us something interesting back.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">rsparql --service='http://localhost:8889/blazegraph/namespace/kb/sparql/update' --query=./get_teams.rq

----------------
| team         |
================
| :ArsenalFC   |
| :ChelseaFC   |
| :LiverpoolFC |
----------------</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>Great.  Now we have data going to and from our triple store, let's expand our graph with some other interesting data.  Put this in a file <code>add_players.rq</code> and send it to Blazegraph the same as before.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code {"language":"jscript"} -->
<pre class="wp-block-syntaxhighlighter-code">PREFIX s: &lt;http://tempuri.com/soccer/>
PREFIX rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#>
PREFIX foaf: &lt;http://xmlns.com/foaf/0.1/>

INSERT DATA {
    s:BerndLeno a s:Footballer;
        foaf:givenName "Bernd";
        foaf:familyName "Leno".

    s:HectorBellerin a s:Footballer;
        foaf:givenName "Hector";
        foaf:familyName "Bellerin".

    s:KieranTierney a s:Footballer;
        foaf:givenName "Kieran";
        foaf:familyName "Tierney".

    s:KepaArrizabalaga a s:Footballer;
        foaf:givenName "Kepa";
        foaf:familyName "Arrizabalaga".

    s:AntonioRudiger a s:Footballer;
        foaf:givenName "Antonio";
        foaf:familyName "Rudiger".

    s:MarcosAlonso a s:Footballer;
        foaf:givenName "Marcos";
        foaf:familyName "Alonso".

    s:Alisson a s:Footballer;
        foaf:givenName "Alisson".

    s:NathanielClyne a s:Footballer;
        foaf:givenName "Nathaniel";
        foaf:familyName "Clyne".

    s:Fabinho a s:Footballer;
        foaf:givenName "Fabinho".
}</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>We should now be able to pull back the player data.  Again, create an <code>rq</code> file and send it to Blazegraph using <code>rsparql</code>.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code {"language":"jscript"} -->
<pre class="wp-block-syntaxhighlighter-code">PREFIX s: &lt;http://tempuri.com/soccer/>

SELECT ?player
WHERE {
    ?player a s:Footballer .
}
LIMIT 10</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">rsparql --service='http://localhost:8889/blazegraph/namespace/kb/sparql' --query=./queries/get_players.rq

----------------------
| player             |
======================
| s:Alisson          |
| s:AntonioRudiger   |
| s:BerndLeno        |
| s:Fabinho          |
| s:HectorBellerin   |
| s:KepaArrizabalaga |
| s:KieranTierney    |
| s:MarcosAlonso     |
| s:NathanielClyne   |
----------------------</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:heading {"level":3} -->
<h3>Beware of non-unicode tooling</h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>All of the RDF standards are designed to be Unicode aware from the bottom up.  When using Jena, though, you may find it doesn't understand Unicode.  I initially wrote some RDF with accented characters.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">    s:AntonioRüdiger a s:Footballer;
        foaf:givenName "Antonio";
        foaf:familyName "Rüdiger".</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>When I tried to update the triple store I got the following, not very useful, error message.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">rupdate --service='http://localhost:8889/blazegraph/namespace/kb/sparql/update' --update=./queries/02.add-players.rq
org.apache.jena.atlas.web.HttpException: 400 - Bad Request
        at org.apache.jena.riot.web.HttpOp.exec(HttpOp.java:1093)
        at org.apache.jena.riot.web.HttpOp.execHttpPost(HttpOp.java:721)
        at org.apache.jena.riot.web.HttpOp.execHttpPost(HttpOp.java:517)
        at org.apache.jena.riot.web.HttpOp.execHttpPost(HttpOp.java:473)
        at org.apache.jena.sparql.modify.UpdateProcessRemote.execute(UpdateProcessRemote.java:81)
        at arq.rupdate.exec(rupdate.java:94)
        at arq.rupdate.exec(rupdate.java:80)
        at jena.cmd.CmdMain.mainMethod(CmdMain.java:93)
        at jena.cmd.CmdMain.mainRun(CmdMain.java:58)
        at jena.cmd.CmdMain.mainRun(CmdMain.java:45)
        at arq.rupdate.main(rupdate.java:44)</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:heading {"level":3} -->
<h3>GUI Experiences</h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>I personally enjoy working on the CLI, but you might be more visual then me.  Blazegraph provides a web based UI for you to query and update.  It's helpful if you need to quickly explore to find out what kind of data it contains.</p>
<!-- /wp:paragraph -->

<!-- wp:image {"id":7382} -->
<figure class="wp-block-image"><img src="https://aabs.files.wordpress.com/2019/09/image-1.png?w=955" alt="" class="wp-image-7382"/><figcaption>A simple UI comes out of the box with Blazegraph</figcaption></figure>
<!-- /wp:image -->

<!-- wp:heading {"level":3} -->
<h3>Querying a more complex graph</h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>Now let's link up the teams and players using contracts, so that we can show how a knowledge graph allows us to query through complex relationships.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code {"language":"jscript"} -->
<pre class="wp-block-syntaxhighlighter-code">PREFIX s: &lt;http://tempuri.com/soccer/>
PREFIX xsd: &lt;http://www.w3.org/2001/XMLSchema#>

INSERT DATA
{

    [] a s:PlayerContract; s:withTeam s:ArsenalFC; s:withPlayer s:BerndLeno;
        s:from "2019-01-01"^^xsd:date; s:to "2020-01-01"^^xsd:date.
    [] a s:PlayerContract; s:withTeam s:ArsenalFC; s:withPlayer s:HectorBellerin;
        s:from "2019-01-01"^^xsd:date; s:to "2020-01-01"^^xsd:date.
    [] a s:PlayerContract; s:withTeam s:ArsenalFC; s:withPlayer s:KieranTierney;
        s:from "2019-01-01"^^xsd:date; s:to "2020-01-01"^^xsd:date.

    [] a s:PlayerContract; s:withTeam s:ChelseaFC; s:withPlayer s:KepaArrizabalaga;
        s:from "2019-01-01"^^xsd:date; s:to "2020-01-01"^^xsd:date.
    [] a s:PlayerContract; s:withTeam s:ChelseaFC; s:withPlayer s:AntonioRudiger;
        s:from "2019-01-01"^^xsd:date; s:to "2020-01-01"^^xsd:date.
    [] a s:PlayerContract; s:withTeam s:ChelseaFC; s:withPlayer s:MarcosAlonso;
        s:from "2019-01-01"^^xsd:date; s:to "2020-01-01"^^xsd:date.

    [] a s:PlayerContract; s:withTeam s:LiverpoolFC; s:withPlayer s:Alisson;
        s:from "2019-01-01"^^xsd:date; s:to "2020-01-01"^^xsd:date.
    [] a s:PlayerContract; s:withTeam s:LiverpoolFC; s:withPlayer s:NathanielClyne;
        s:from "2019-01-01"^^xsd:date; s:to "2020-01-01"^^xsd:date.
    [] a s:PlayerContract; s:withTeam s:LiverpoolFC; s:withPlayer s:Fabinho;
        s:from "2019-01-01"^^xsd:date; s:to "2020-01-01"^^xsd:date.
}
</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>This contract data links the team with the player, allowing us to ask some more interesting questions.  Let's start off by finding all the players who  play for Arsenal.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">PREFIX s: &lt;http://tempuri.com/soccer/>

SELECT ?player
WHERE {
    ?player a s:Footballer .
    [] a s:PlayerContract;
        s:withTeam s:ArsenalFC;
        s:withPlayer ?player .
}
LIMIT 10</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>This is pretty straightforward, requiring little traversal of the graph.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">rsparql --service='http://localhost:8889/blazegraph/namespace/kb/sparql' --query=./queries/arsenal_players.rq

--------------------
| player           |
====================
| s:BerndLeno      |
| s:HectorBellerin |
| s:KieranTierney  |
--------------------</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>Let's see if we can find a list of all the players in London?  In fact we don't care about the URL of the player, just their first and last name.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">PREFIX s: &lt;http://tempuri.com/soccer/>
PREFIX foaf: &lt;http://xmlns.com/foaf/0.1/>

SELECT ?givenName ?familyName
WHERE {
    ?player a s:Footballer ;
        foaf:givenName ?givenName;
        foaf:familyName ?familyName .
    ?team a s:Team;
        s:homeCity s:London .
    _:contract a s:PlayerContract;
        s:withTeam ?team;
        s:withPlayer ?player .
}
LIMIT 10</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>Remember from last time, how I mentioned that the way to think of query writing in SPARQL is to show what structures from the graph you want, providing what you know and leaving blanks (in the form of variables) for what you don't.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>In the query above, the only concrete thing I provide is that the team home city must be London.  From there it navigates the graph to find what matches. <code>London - team - contract - player - givenName</code></p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>The queries are now starting to look a bit less trivial.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">rsparql --service='http://localhost:8889/blazegraph/namespace/kb/sparql' --query=./queries/london_players.rq

------------------------------
| givenName | familyName     |
==============================
| "Antonio" | "Rudiger"      |
| "Bernd"   | "Leno"         |
| "Hector"  | "Bellerin"     |
| "Kepa"    | "Arrizabalaga" |
| "Kieran"  | "Tierney"      |
| "Marcos"  | "Alonso"       |
------------------------------</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>Needless to say, it wouldn't be that much more difficult to link in more info about the national side these players play for.  We could then ask fruity questions like "<em>Get me the personal details of danish footballers playing for a london based club</em>".</p>
<!-- /wp:paragraph -->

<!-- wp:heading -->
<h2>Summary</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>I've shown in this installment how to fire up a proper triple store using Docker and   insert and retrieve data from it using the CLI tools.  I showed how you can incrementally build up your data, and then use SPARQL to query through complex relationships with ease.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>Next time I will do this with Amazon Neptune, which won't be that much different in terms of SPARQL, so I will hook up some C# code to do it for me.</p>
<!-- /wp:paragraph -->