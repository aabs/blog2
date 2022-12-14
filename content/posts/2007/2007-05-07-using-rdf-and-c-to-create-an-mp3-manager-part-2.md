---
title: Using RDF and C# to create an MP3 Manager - Part 2
date: 2007-05-07
author: Andrew Matthews
ignored-tags: C#, Computer Science, ORM, programming, software
slug: using-rdf-and-c-to-create-an-mp3-manager-part-2
status: published
---

I've been off the air for a week or two - I've been hard at work on the final stages of a project at work that will go live next week. I've been on this project for almost 6 months now, and next week I'll get a well earned rest. What that means is I get to do some dedicated Professional Development (PD) time which I have opted to devote to Semantic Web technologies. That was a hard sell to the folks at Readify, what with Silverlight and .NET 3 there to be worked on. I think I persuaded them that consultancies without SW skills will be at a disadvantage in years to come.

Anyway, enough of that - onto the subject of the post, which is the next stage of my mini-series about using semantic web technologies in the production of a little MP3 file manager.

At the end of the last post we had a simple mechanism for serialising objects into a triple store, with a set of services for extracting relevant information out of an object, and to tie it to predicates defined in on ontology. In this post I will show you the other end of the process. We need to be able to query against the triple store and get a collection of objects back.

The query I'll show you is very simple, since the main task for this post is object deserialisation, once we can shuttle objects in and out of the triple store then we can focus on beefing up the query process.

Querying the triple store

For this example I just got a list of artists for the user and allowed them to select one. That artist was then fed into a graph match query in SemWeb, to bring back all of the tracks whose artist matches the one chosen.

The query works in the usual way - get a connection to the data store, create a query, present it and reap the result for conversion to objects:

`private IList<Track> DoSearch(){  MemoryStore ms = Store.TripleStore;  ObjectDeserialiserQuerySink<Track> sink = new ObjectDeserialiserQuerySink<Track>();     string qry = CreateQueryForArtist(artists[0].Trim());     Query query = new GraphMatch(new N3Reader(new StringReader(qry)));     query.Run(ms, sink);     return tracksFound = sink.DeserialisedObjects;}`

We'll get on the the ObjectDeserialiserQuerySink in a short while. The process of creating the query is really easy, given the simple reflection facilities I created last time. I'm using the N3 format for the queries, for the sake of simplicity - we could just as easily used SPARQL. We start with a prefix string to give us a namespace to work with, we then enumerate the persistent properties of the Track type. For each property we then insert a triple meaning "whatever track is select - get its property as well". Lastly, we add the artist name ass a known fact, allowing us to specify exactly what tracks we were talking about.

`private static string CreateQueryForArtist(string artistName){     string queryFmt = "@prefix m: <http: aabs.purl.org/ontologies/2007/04/music#> .\n";     foreach (PropertyInfo info in OwlClassSupertype.GetAllPersistentProperties(typeof(Track)))     {           queryFmt += string.Format("?track <{0}> ?{1} .\n", OwlClassSupertype.GetPropertyUri(typeof(Track), info.Name), info.Name);  }     queryFmt += string.Format("?track <{0}> \"{1}\" .\n", OwlClassSupertype.GetPropertyUri(typeof(Track), "ArtistName"), artistName);     return queryFmt;}`

Having created a string representation of the query we're after we pass it to a GraphMatch object, which is a kind of query were you specify a graph that is a kind of prototype for the structure of the results desired. I also created a simple class called ObjectDeserialiserQuerySink:

`public class ObjectDeserialiserQuerySink<T> : QueryResultSink where T : OwlClassSupertype, new(){  public List<T> DeserialisedObjects     {         get { return deserialisedObjects; }     }      private List<T> deserialisedObjects = new List<T>();     public ObjectDeserialiserQuerySink()  {  }   public override bool Add(VariableBindings result)  {           T t = new T();           foreach (PropertyInfo pi in OwlClassSupertype.GetAllPersistentProperties(typeof(T)))    {                 try                 {                       string vn = OwlClassSupertype.GetPropertyUri(typeof (T), pi.Name).Split('#')[1];                      string vVal = result[pi.Name].ToString();                       pi.SetValue(t, Convert.ChangeType(vVal, pi.PropertyType), null);                 }                 catch (Exception e)      {        Debug.WriteLine(e);                       return false;                 }    }           DeserialisedObjects.Add(t);           return true;  }}`

For each match that the reasoner is able to find, a call gets made to the Add method of the deserialiser with a set of VariableBindings. Each of the variable bindings corresponds to solutions of the free variables defined in the query. Since we generated the query out of the persistent properties on the Track type the free variables matched will also correspond to the persistent properties of the type. What that means is that it is a straightforward job to deserialise a set of VariableBindings into an object.

That's it. We now have a simple triple store that we can serialise objects into and out of, with an easy persistence mechanism. But there's a lot more that we need to do. Of the full CRUD behaviour I have implemented Create and Retrieve. That leave Update and Delete. As we saw in one of my previous posts, that will be a mainly manual programmatical task since semantic web ontologies are to a certain extend static. What that means is that they model a domain as a never changing body of knowledge about which we may deduce more facts, but where we can't unmake (delete) knowledge.

The static nature of ontologies seems like a bit of handicap to one who deals more often than not with transactional data - since it means we need more than one mechanism for dealing with data - deductive reasoningh, and transactional processing. With the examples I have given up till now I have been dealing with in-memory triple stores where the SemWeb API is the only easy means of updating and deleting data. When we are dealing with a relational database as our triple store, we will have the option to exploit SQL as another tool for managing data.

Powered by [ScribeFire](http://scribefire.com/).
