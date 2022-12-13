---
title: Knowledge Graphs 6 - Semantics
date: 2019-10-03
author: Andrew Matthews
category: programming
tags: ["entailment", "inference", "knowledge graphs", "rdf", "rdfs", "semantic web"]
slug: knowledge-graphs-6-semantics
status: published
attachments: 2019/10/donald-giannatti-zhptmnzz-nm-unsplash-1.jpg, 2019/10/donald-giannatti-zhptmnzz-nm-unsplash.jpg
series: ["Working with Knowledge Graphs"]
---

With this installment we finally get to the part of knowledge graphs that I
personally find really exciting: Semantics. In this installment, I will
introduce some of the simple rules of entailment that are a part of the RDFS
standard.




This is part 6 of an ongoing series providing a little background on ‘*knowledge graphs*‘. The aim is to let software developers get up to speed as fast as possible. No theory, no digressions, and no history. Just practical knowledge.

-   [Knowledge Graphs 101](https://andrewmatthews.blog/2019/09/12/knowledge-graphs-101/)
-   [Knowledge Graphs 2 – Playing on the CLI](https://andrewmatthews.blog/2019/09/13/knowledge-graphs-2-playing-on-the-cli/)
-   [Knowledge Graphs 3 – Using a Triple Store](https://andrewmatthews.blog/2019/09/13/knowledge-graphs-3-using-a-triple-store/)
-   [Knowledge Graphs 4 – Querying your knowledge graph using .NET](https://andrewmatthews.blog/2019/09/16/knowledge-graphs-4-querying-your-knowledge-graph-using-net/)
-   [Knowledge Graphs 5 – Modelling with RDFS](https://andrewmatthews.blog/2019/10/03/knowledge-graphs-5-modelling-with-rdfs/)
-   [Knowledge Graphs 6 - Semantics](https://andrewmatthews.blog/2019/10/03/knowledge-graphs-6-semantics/)
-   [Knowledge Graphs 7 - Named graphs](https://aabs.wordpress.com/2019/11/06/knowledge-graphs-7-named-graphs/)

This is the barest tip of the iceberg of reasoning about data that is possible with RDF. I hope to be able to convey some of the power possible in this technology that are so hard to find anywhere else. I describe how this secret sauce allows us to incrementally build meaning into our data, as our understanding of it grows - another thing that is hard to do with many other popular technologies.

Properties Redux
----------------

Remember from last time how to define a class and some properties on it:

```
:Player a rdfs:Class .
:Team a rdfs:Class .

:playsFor a rdf:Property;
    rdfs:domain :Player;
    rdfs:range  :Team .
```

And how we can define property hierarchies if we want to:

```
:worksFor rdfs:domain :Person;
    rdfs:range :Organisation .
:playsFor rdfs:subClassOf :worksFor .
```

And how to define instances of those classes and properties:

```
<http://dbpedia.org/resource/George_Best> :playsFor <http://dbpedia.org/page/Manchester_United_F.C.> .
```

Let's unpack some of what I said. There are two classes in the default namespace,  `:Player` and  `:Team `, that can be related using the  `:playsFor` property.

I then defined a new property called  `:worksFor` that just links people to organisations. I then said that if a player plays for a team, then they work for the team. Yes, I know there are exceptions to this in the real world, but you get the idea, right? There are people who work for the team that don't play for it, like coaches and medics etc, so  `:worksFor` is a super-property to  `:playsFor `.

I then used the  `:playsFor` property to link two new resources in our graph;  `http://dbpedia.org/resource/George_Best` and  `http://dbpedia.org/page/Manchester_United_F.C.` both taken from the RDF graph that comes from wikipedia, called *dbpedia.*

RDFS Entailment
---------------

While I was able to capture a little microcosm of the world of soccer, I'm sure you can see that there is **more in there** if we only had to means to get at it. RDFS provides some of the means to do that. It defines an *[Entailment Regime](https://www.w3.org/TR/rdf11-mt/#rdfs-entailment)* for the new property and class building blocks. See [here](https://www.w3.org/TR/sparql11-entailment/#RDFSEntRegime) also.

An entailment regime is, in essence, a set of rules for what additional conclusions are valid given some basic initial statements. Often those rules follow one of the familiar syllogism structures:  `All A are B, x is A, therefore x is B `.

Here's an example of one of the rules, called  `rdfs11 `, that describes the transitivity of subclass relationships:

```
if ( xxx rdfs:subClassOf yyy && yyy rdfs:subClassOf zzz)
then (xxx rdfs:subClassOf zzz)
```

Which is another way of saying that it is logically correct to add  `xxx rdfs:subClassOf zzz` to your graph whenever you see  `xxx rdfs:subClassOf yyy and yyy rdfs:subClassOf zzz` in your triple store.

Conveniently, these rules can be converted to SPARQL update statements:

```
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

INSERT
{
    GRAPH <http://industrialinference.com/inferred/> {
    ?xxx rdfs:subClassOf ?zzz .
    }
}
WHERE
{
    ?xxx rdfs:subClassOf ?yyy .
    ?yyy rdfs:subClassOf ?zzz .
}
```

The beauty of this is that, you can query for data that you never anticipated. Here's a trivial little example to demonstrate. Imagine on day one of your project, you stored data matching the simple schema above.

```
:bob a :Player .
```

Initially, you can't do much with the data other than store and retrieve it. But once you start to annotate your data with further relationships, things can get interesting. Imagine we say later on that a Player is a kind of Person. We don't need to modify any of our data, just add another triple:

```
:Player rdfs:subClassOf :Person .
```

Now, whenever we query for all people, we get back the players as well. I can't overstate how important this is! Suddenly, we are getting different fuller results because entailment allowed us to deduce new facts from our data.

``` {.wp-block-verse}
We didn't change our data, nor our applications or data access code to get this.  All we had to do was supply more details about our types and their relationships.
```

There is a similar rule to  `rdfs11` called  `rdfs5` that applies the same transitive reasoning to property relationships:

```
if (xxx rdfs:subPropertyOf yyy && yyy rdfs:subPropertyOf zzz )
then (xxx rdfs:subPropertyOf zzz)
```

which translates in SPARQL like so:

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

INSERT
{
    GRAPH <http://industrialinference.com/inferred/> {
        ?xxx rdfs:subPropertyOf ?zzz .
    }
}
WHERE
{
    ?xxx rdfs:subPropertyOf ?yyy .
    ?yyy rdfs:subPropertyOf ?zzz .
}
```

When we have  `rdfs5` in place, and we query who  `:worksFor` Manchester United, we will also get back the players like George Best, in addition to the coaching, management and medical staff.

Another vital pair of rules are  `rdfs2` and  `rdfs3 `. They look like this:

```
if (aaa rdfs:domain xxx && yyy aaa zzz )
then (yyy rdf:type xxx)

if (aaa rdfs:range xxx && yyy aaa zzz )
then (zzz rdf:type xxx)
```

Which means that if you know the definitions of the types of resources at either end of a property, you can assign them to the resources mentioned in actual instance data. Remember where I said:

```
<http://dbpedia.org/resource/George_Best> :playsFor <http://dbpedia.org/page/Manchester_United_F.C.> .
```

since I defined the property  `:playsFor` like this:

```
:playsFor a rdf:Property;
    rdfs:domain :Player;
    rdfs:range  :Team .
```

Then  `rdfs2/3` allows me to add the following triples to my store:

```
<http://dbpedia.org/resource/George_Best> a :Player .
<http://dbpedia.org/page/Manchester_United_F.C.> a :Team .
```

Not only that, but because we defined the  `:subPropertyOf` rule for  `:worksFor` then  `rdfs5` allows me to add these triples as well:

```
<http://dbpedia.org/resource/George_Best> :worksFor
    <http://dbpedia.org/page/Manchester_United_F.C.> .
<http://dbpedia.org/resource/George_Best> a :Person .
<http://dbpedia.org/page/Manchester_United_F.C.> a :Organisation .
```

So, you see there is a lot we can deduce from a bit of schema and a little bit of data. More importantly, you might choose to just store the raw triple saying, george best plays for man united, without any other metadata about what it means.

Later on, you can incrementally add this extra information. As you go, you will find more and more insights start to come out of your data, and you can answer more and more questions. For example, with just the initial raw data, I couldn't say that George Best was a Person and not a Car or Engine. After defining the *meaning* of  `:playsFor` I will know all this and more.

Summary
-------

This is the briefest possible introduction to *Entailment* I could provide. I hope it has shown you that the rules provide *meaning* to relationships, and that those rules if applied judiciously allow you to get data out that you didn't put in. They allow you to answer questions that were unanticipated when you put your data in. They allow you to declaratively adorn your raw data with metadata later on, and use that metadata with entailment rules to enrich your data in unforeseen ways.

As I mentioned, this is but the merest whiff of what is possible, and as this series progresses I hope to cover some of the awesomeness that is OWL2, as well as introduce you to inference engines - the systems that can sit in the background applying the rules of entailment for you.

For now, if you want to understand the rules and see how they might be applied, take a look at [this little project](https://github.com/aabs/inference-engine) I knocked up in my spare time. It's a poor man's inference engine, but hopefully it shows how you might periodically materialise entailments in your database.

#### Appendix A - [RDFS Entailment Rules](https://www.w3.org/TR/rdf11-mt/#rdfs-entailment)

Here's the [full list](https://www.w3.org/TR/rdf11-mt/#rdfs-entailment) of entailments for RDFS.

  --------------------------------------------------------------------------------------------------------------------
  **ID**                  **If S contains:**                                  **then S RDFS entails recognizing D:**
  ----------------------- --------------------------------------------------- ----------------------------------------


  **rdfs1**               any IRI aaa in D                                    aaa  `rdf:type rdfs:Datatype . `

  **rdfs2**               aaa  `rdfs:domain ` xxx  `. `\                          yyy  `rdf:type ` xxx  `. `
                          yyy aaa zzz  `. `

  **rdfs3**               aaa  `rdfs:range ` xxx  `. `\                           zzz  `rdf:type ` xxx  `. `
                          yyy aaa zzz  `. `

  **rdfs4a**              xxx aaa yyy  `.`                                     xxx  `rdf:type rdfs:Resource . `

  **rdfs4b**              xxx aaa yyy `.`                                      yyy  `rdf:type rdfs:Resource . `

  **rdfs5**               xxx  `rdfs:subPropertyOf ` yyy  `. `\                   xxx  `rdfs:subPropertyOf ` zzz  `. `
                          yyy  `rdfs:subPropertyOf ` zzz  `. `

  **rdfs6**               xxx  `rdf:type rdf:Property .`                       xxx  `rdfs:subPropertyOf ` xxx  `. `

  **rdfs7**               aaa  `rdfs:subPropertyOf ` bbb  `. `\                   xxx bbb yyy  `. `
                          xxx aaa yyy  `. `

  **rdfs8**               xxx  `rdf:type rdfs:Class .`                         xxx  `rdfs:subClassOf rdfs:Resource . `

  **rdfs9**               xxx  `rdfs:subClassOf ` yyy  `. `\                      zzz  `rdf:type ` yyy  `. `
                          zzz  `rdf:type ` xxx  `. `

  **rdfs10**              xxx  `rdf:type rdfs:Class .`                         xxx  `rdfs:subClassOf ` xxx  `. `

  **rdfs11**              xxx  `rdfs:subClassOf ` yyy  `. `\                      xxx  `rdfs:subClassOf ` zzz  `. `
                          yyy  `rdfs:subClassOf ` zzz  `. `

  **rdfs12**              xxx  `rdf:type rdfs:ContainerMembershipProperty .`   xxx  `rdfs:subPropertyOf rdfs:member . `

  **rdfs13**              xxx  `rdf:type rdfs:Datatype .`                      xxx  `rdfs:subClassOf rdfs:Literal . `
  --------------------------------------------------------------------------------------------------------------------
