---
title: Knowledge Graphs 2 – Playing on the CLI
author: Andrew Matthews
date: 2019-09-13
---

<!-- wp:paragraph -->
<p>Last time I showed how to write RDF in Turtle, and how to make very simple queries in SPARQL.  What I didn't show was how to get your hands dirty.  Specifically, I want to show you how to try things out on the <s>cheap</s> command line.   I will show examples of how to build out your RDF data to more depth using Turtle files, and how to use the Jena framework to create queries against that data, so you can work out ahead of time how to navigate your graph of data. </p>
<!-- /wp:paragraph -->

<!-- wp:more -->
<!--more-->
<!-- /wp:more -->

<!-- wp:list -->
<ul><li><a href="https://andrewmatthews.blog/2019/09/12/knowledge-graphs-101/">Knowledge Graphs 101</a></li><li><a href="https://andrewmatthews.blog/2019/09/13/knowledge-graphs-2-playing-on-the-cli/">Knowledge Graphs 2 – Playing on the CLI</a></li><li><a href="https://andrewmatthews.blog/2019/09/13/knowledge-graphs-3-using-a-triple-store/">Knowledge Graphs 3 – Using a Triple Store</a></li><li><a href="https://andrewmatthews.blog/2019/09/16/knowledge-graphs-4-querying-your-knowledge-graph-using-net/">Knowledge Graphs 4 – Querying your knowledge graph using .NET</a></li><li><a rel="noreferrer noopener" href="https://andrewmatthews.blog/2019/10/03/knowledge-graphs-5-modelling-with-rdfs/" target="_blank">Knowledge Graphs 5 – Modelling with RDFS</a></li><li><a href="https://andrewmatthews.blog/2019/10/03/knowledge-graphs-6-semantics/">Knowledge Graphs 6 - Semantics</a></li><li><a href="https://aabs.wordpress.com/2019/11/06/knowledge-graphs-7-named-graphs/">Knowledge Graphs 7 - Named graphs</a></li></ul>
<!-- /wp:list -->

<!-- wp:heading -->
<h2>Step 1 - Get some local tools</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>Assuming you are running on Linux, or have WSL installed on windows, you can easily get up and running using the Apache Jena toolkit.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>To install Jena on Ubuntu/MacOS using LinuxBrew or HomeBrew.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">$> brew install jena</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>To test it is installed, check it like so:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">$> sparql -version
Jena:       VERSION: 3.12.0
Jena:       BUILD_DATE: 2019-05-27T16:07:27+0000</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>The <code>sparql</code> CLI tool is used to issue SPARQL queries against a local copy of the data.  There is a corresponding tool called <code>rsparql</code> that allows you to query using the SPARQL Protocol with a remote W3C compliant triple store.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>That's all we need to get started.  Let's create a knowledge graph!   This knowledge graph will be in the sporting domain, and I will build on it in future posts. </p>
<!-- /wp:paragraph -->

<!-- wp:heading -->
<h2>Step 2 - Query local data</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>Create a file called <code>soccer.ttl</code> to contain your data.  I use Visual Studio Code, since there are some nice syntax highlighting plugins for Turtle files, but any editor will do.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">@prefix : &lt;http://tempuri.com/soccer/> .
@prefix rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix xsd: &lt;http://www.w3.org/2001/XMLSchema#> .
@prefix rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#> .
@prefix owl: &lt;http://www.w3.org/2002/07/owl#> .
@prefix time: &lt;http://www.w3.org/2006/time#>.
@prefix foaf: &lt;http://xmlns.com/foaf/0.1/> .

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
    :from "2019-01-01"^^xsd:date; :to "2020-01-01"^^xsd:date.</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>Now let's write a simple SPARQL query, and store it in a query file (<code>*.rq</code>):</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">PREFIX : &lt;http://tempuri.com/soccer/>

SELECT ?team
WHERE {
    ?team a :Team .
}
LIMIT 10</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>Use the <code>sparql</code> tool to make the query:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">$> sparql --data=soccer.ttl --query=get_teams.rq

----------------
| team         |
================
| :ArsenalFC   |
| :ChelseaFC   |
| :LiverpoolFC |
----------------</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>Perhaps we want to find only the London teams?  See how easy it is to <em>declare what must be true</em>, rather than perform some filtration operation?  Of course, SPARQL does have FILTER operations, but you can go a long way without resorting to it.</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">PREFIX : &lt;http://tempuri.com/soccer/>

SELECT ?team
WHERE {
    ?team a :Team ;
        :homeCity :London .
}
LIMIT 10</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>The results are as you would expect:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code -->
<pre class="wp-block-syntaxhighlighter-code">sparql --data=soccer.ttl --query=london_teams.rq
--------------
| team       |
==============
| :ChelseaFC |
| :ArsenalFC |
--------------</pre>
<!-- /wp:syntaxhighlighter/code -->

<p><!--EndFragment--></p>

<!-- wp:heading -->
<h2>Summary</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>In this installment, I showed how to build out your RDF data to more depth using Turtle files.  I show how to use the Jena framework to create queries against that data, so you can work out ahead of time how to navigate the graph of data.  In later installments I will show how to using dotNetRdf to query and update data into a remote triple store.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>Please let me know if you have any questions or if any of the ideas are not clear.  Also, let me know if there are aspects of knowledge graphs that you would like to hear more about.</p>
<!-- /wp:paragraph -->