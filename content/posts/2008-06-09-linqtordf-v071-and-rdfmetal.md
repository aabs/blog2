---
title: LinqToRdf v0.7.1 and RdfMetal
date: 2008-06-09 22:20
author: aabs
category: .NET, programming, science, Semantic Web, SemanticWeb
slug: linqtordf-v071-and-rdfmetal
status: published
attachments: 2008/06/clip-image0015.png, 2008/06/clip-image0015-thumb.png
---

I've just uploaded [version 0.7.1](http://linqtordf.googlecode.com/files/LinqToRdf-0.7.1.msi) of LinqToRdf. This bug fix release corrects an issue I introduced in version 0.7. The issue only seemed to affect some machines and stems from the use of the GAC by the WIX installer (to the best of my knowledge). I've abandoned GAC installation and gone back to the original approach.

Early indications (Thanks, Hinnerk) indicate that the issue has been successfully resolved. Please let me know if you are still experiencing problems. Thanks to 13sides, Steve Dunlap, Hinnerk Bruegmann, Kevin Richards and [Paul Stovell](http://www.paulstovell.com/blog/) for bringing it to my attention and helping me to overcome the allure of the GAC.

Kevin also reported that he's hoping to use LinqToRdf on a project involving the Biodiversity Information Standards ([TDWG](http://www.tdwg.org/)). It's always great to hear how people are using the framework. Please drop me a line to let me know how you are using LinqToRdf.

Kevin might find feature [\#13](http://code.google.com/p/linqtordf/issues/detail?id=13&colspec=ID%20Type%20Summary%20Priority) useful. It will be called ***RdfMetal*** in honour of SqlMetal. It will automate the process of working with remotely managed ontologies. RdfMetal will completely lower any barriers to entry in semantic web development. You will (in principle) no longer need to know the formats, protocols and standards of the semantic web in order to consume data in it.

[![clip\_image001\[5\]]({static}2008/06/clip-image0015-thumb.png){width="533" height="207"}]({static}2008/06/clip-image0015.png)

Here's an example of the output it generated from DBpedia.org for the FOAF ontology:

    ./RdfMetal.exe -e:http://DBpedia.org/sparql -i -n http://xmlns.com/foaf/0.1/ -o foaf.cs

Which produced the following source:

    namespace Some.Namespace
    {
    [assembly: Ontology(
        BaseUri = "http://xmlns.com/foaf/0.1/",
        Name = "MyOntology",
        Prefix = "MyOntology",
        UrlOfOntology = "http://xmlns.com/foaf/0.1/")]


        public partial class MyOntologyDataContext : RdfDataContext
        {
            public MyOntologyDataContext(TripleStore store) : base(store)
            {
            }
            public MyOntologyDataContext(string store) : base(new TripleStore(store))
            {
            }

                    public IQueryable<Person> Persons
                    {
                        get
                        {
                            return ForType<Person>();
                        }
                    }

                    public IQueryable<Document> Documents
                    {
                        get
                        {
                            return ForType<Document>();
                        }
                    }

                    // ...

        }

    [OwlResource(OntologyName="MyOntology", RelativeUriReference="Person")]
    public partial class Person
    {
      [OwlResource(OntologyName = "MyOntology", RelativeUriReference = "surname")]
      public string surname {get;set;}
      [OwlResource(OntologyName = "MyOntology", RelativeUriReference = "family_name")]
      public string family_name {get;set;}
      [OwlResource(OntologyName = "MyOntology", RelativeUriReference = "geekcode")]
      public string geekcode {get;set;}
      [OwlResource(OntologyName = "MyOntology", RelativeUriReference = "firstName")]
      public string firstName {get;set;}
      [OwlResource(OntologyName = "MyOntology", RelativeUriReference = "plan")]
      public string plan {get;set;}
      [OwlResource(OntologyName = "MyOntology", RelativeUriReference = "knows")]
      public Person knows {get;set;}
      [OwlResource(OntologyName = "MyOntology", RelativeUriReference = "img")]
      public Image img {get;set;}
      [OwlResource(OntologyName = "MyOntology", RelativeUriReference = "myersBriggs")]
      // ...
    }

    [OwlResource(OntologyName="MyOntology", RelativeUriReference="Document")]
    public partial class Document
    {
      [OwlResource(OntologyName = "MyOntology", RelativeUriReference = "primaryTopic")]
      public LinqToRdf.OwlInstanceSupertype primaryTopic {get;set;}
      [OwlResource(OntologyName = "MyOntology", RelativeUriReference = "topic")]
      public LinqToRdf.OwlInstanceSupertype topic {get;set;}
    }

    // ...

As you can see, it's still pretty rough, but it allows me to write queries like this:

    [TestMethod]
    public void TestGetPetesFromDbPedia()
    {
        var ctx = new MyOntologyDataContext("http://DBpedia.org/sparql");
        var q = from p in ctx.Persons
                where p.firstName.StartsWith("Pete")
                select p;
        foreach (Person person in q)
        {
            Debug.WriteLine(person.firstName + " " + person.family_name);
        }
    }

[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)

RdfMetal will be added to the v0.8 release of LinqToRdf in the not too distant
future. If you have any feature requests, or want to help out, please reply to
this or better-still join the
[LinqToRdf discussion group](http://groups.google.com/group/linqtordf-discuss)
and post there.
