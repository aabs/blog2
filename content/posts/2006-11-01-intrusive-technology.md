---
title: Intrusive Technology
date: 2006-11-01 08:55
author: Andrew Matthews
ignored-tags: Computer Science
slug: intrusive-technology
status: published
---

What is the ideal of good design?

There are limitless answers to this question. Most of them focus on the day to day business of writing software – and aim to minimize the effects of bad design choices through application of a simple principle. The patchwork of these principles when applied in a harmonious way is hoped to give health and vigour to a system. When you write software, you generally hope to extend its lifespan beyond the short term - to help it become a living thing. You want it to be perfectly adapted to its environment and to be able to cope with the stresses of its environment. There is an element of truth in what I said to Mitch the other day – a new system is like a child. You let go of it reluctantly but with a mixture of hope and misgiving.

Here is another principle which I want to add to the mix, which I try to apply to my designs. It subsumes the principle of loose coupling, and service orientation. It grows out of object orientation, but where OO is done for its own sake, this principle uses it to forward its own agenda. I'm talking about the principle of ***hiding your design decisions***.

There is a subtle distinction between this principle and that of ***information hiding*** (encapsulation). The usual motive for encapsulation is to help enforce interface contracts. If you expose implementation details, you are inviting others to sidestep or ignore the rules of your component, and weakening it. That's a valid use of encapsulation and I use it wherever possible. Hiding design decisions has a similar but broader objective. It seeks to prevent binding you to a technology and the idiomatic designs of that technology. It uses encapsulation to hide features of an implementation so that no features of a design can be explicitly bound to. Binding to a design prevents you from using any other. Can't be good can it? You can't step back if you realize that the design doesn't fulfill all of your requirements.

When you try to hide your design decisions you have to go beyond mere encapsulation to find a way of exposing functionality in a way that doesn't expose idioms to the outside world. That means not only not exposing properties, methods and types to the outside world but not exposing the ways you fulfill your contracts. I'll give a few examples to show you what I mean. Take Object Relational Mapping (ORM or O/R) systems. In one ORM that I wrote some years back I provided a mechanism to define queries that could be presented to the ORM, a so-called object query language just like the one that sits under DLINQ. For convenience I provided a mechanism to allow the query to convert itself to SQL with an API like this:

public string ToSqlString(){…}

It seemed OK, and it was endorsed as a design by Ambler. I was now able to recursively expand expressions into a format that was comprehensible to ADO.NET, thereby allowing me to feed these queries through to a subsystem that spoke to the database. The problem was that I later wanted to be able to target XML databases and files. By making this design decision, I had bound a layer of my framework to a specific technology. Now when I wanted to add XML capabilities to the framework I had to add another API:

public string ToXPathString(){…}

Not exactly the model of good design, eh? Now every new technology I used got exposed by the very interface that was supposed to be encapsulating it. The design was encapsulated in the sense that the properties and types were not exposed. But what if I wanted to start working with the Frobnut system, that took a special sort of FooBar object query. Now I had to start exposing that at the query level.

It can't go on like that. So where exactly did I go wrong? I had allowed the technology to intrude. Intrusion of a technology is a major cause of inflexible designs. The system lost its adaptability. Our streamlined shark had become a barnacle encrusted whale.

The answer to that specific problem was to use some kind of translator mechanism. The SQL or XPath specific subsystems could use it to do their conversions, without the top level knowing or caring about how. But the spirit of the solution was more abstract: I found a way to remove the technological intrusions and in so doing I made the system more flexible and extensible.

Another more religious example is related to the whole DataSets vs. XmlDocument vs. Domain Objects debate. I recently finished a project for a client here in Melbourne. They had a pretty nice system for encapsulating the communications between their system and third party systems. They used SOAP, XMLRPC and Screen scrapers to harvest information and do transactions, and they converted the results to a typed DataSet for internal use. The issue for me is why they would expose the results as a DataSet in the first place? Sure, there is then a means to get at the contents of the data with type safety. But why on earth would you want to impersonate a relational database, when that is about the only format that they didn't receive data in?

What is so special about databases anyway, that we should use them as the preferred format for incoming data? We are coding in the object domain and as we all know there is an object-relational mismatch. So we have to go to extra lengths to work with the data anyway. Here is another example where to hide a design feature at one level they introduced a design flaw at another. They introduced a technological intrusion that was unwarranted. In fact, technological intrusions are almost always unwarranted. Good framework design limits technological effects to the narrowest boundaries.

In that example the data was coming in in numerous formats, and being converted into a dataset to provide a canonical format for the data. I believe that ***the domain object is the canonical format for the object domain***. If you want to provide a technologically neutral format for a stream of incoming data – the domain object or data transfer object is the format of choice. Performance considerations were secondary in that case because while we could do the conversion in a few milliseconds, connecting to and querying the third party services took many seconds. So I could see no justification for the design decision.
