---
title: Semantic Web Visual Designer for Visual Studio .NET
date: 2007-10-24 00:48
author: Andrew Matthews
category: .NET, programming, Semantic Web
slug: semantic-web-visual-designer-for-visual-studio-net
status: published
attachments: 2007/10/image-thumb.png, 2007/10/image.png
---

Just posting a quick update about progress with [LinqToRdf](http://code.google.com/p/linqtordf/) and a side-project I'm working on to create a visual design tool to allow you to do visual editing of ontologies in Visual Studio .NET 2008. Since I'm a very creative person, I've decided to call it LinqToRdfDesigner. :-)

The designer uses Microsoft's [DSL tools](http://msdn2.microsoft.com/en-au/library/bb126235(VS.80).aspx) system to produce attractive visual designs:

[![image]({static}2007/10/image-thumb.png){width="553" height="502"}]({static}2007/10/image.png)

So far, I've got it producing [N3 notation](http://aabs.wordpress.com/semantic-web/the-n3-cheat-sheet/) from models, like so:

    @prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
    @prefix daml: <http://www.daml.org/2001/03/daml+oil#> .
    @prefix log: <http://www.w3.org/2000/10/swap/log#> .
    @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
    @prefix owl:  <http://www.w3.org/2002/07/owl#> .
    @prefix xsdt: <http://www.w3.org/2001/XMLSchema#>.
    @prefix : <http://aabs.purl.org/ontologies/2007/04/music#> .

    :Item a owl:Class .
    :Title a owl:Class .
    :name
        rdfs:domain :Title;
        rdfs:range :string.
    :Book a owl:Class ;
        rdfs:subClassOf :Item .
    :Member a owl:Class .
    :Library a owl:Class .
    :catalog
        rdfs:domain :Library;
        rdfs:range :Title.
    :stockItem
        rdfs:domain :Library;
        rdfs:range :Item.
    :member
        rdfs:domain :Library;
        rdfs:range :Member.
    :Loan a owl:Class .
    :commenced
        rdfs:domain :Loan;
        rdfs:range :DateTime.
    :Reservation a owl:Class .
    :made
        rdfs:domain :Reservation;
        rdfs:range :DateTime.

[](http://11011.net/software/vspaste)

Not all of the relationships are complete yet, but it shouldn't be too hard. Next step is to produce the C\# entity model as well. This should have the nice side benefit that the ontology and the object model are always kept in sync. Eventually, it will expand to include more of the [OWL specification](http://www.w3.org/2004/OWL/) than can currently be easily modeled in object oriented languages like C\#.

So, what do you think? Would you be more inclined to use semantic web tools if the steps needed to get started were already familiar to you, and you didn't need to go too deeply into the [W3C standards](http://www.w3.org/)? Would you be willing to pay for it? how much would you be willing to pay? Please respond to this with your thoughts.
