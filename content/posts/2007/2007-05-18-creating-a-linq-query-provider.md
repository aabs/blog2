---
title: Creating A LINQ Query Provider
date: 2007-05-18
author: Andrew Matthews
ignored-tags: artificial intelligence, C#, Computer Science, databases, LINQ, ORM, programming, software
slug: creating-a-linq-query-provider
status: published
---

As promised last time, I have extended the query mechanism of my little
application with a LINQ Query Provider. I based my initial design on the method
published by
[Bart De Smet](http://community.bartdesmet.net/blogs/bart/archive/2007/04/05/the-iqueryable-tales-linq-to-ldap-part-0.aspx),
but have extended that framework, cleaned it up and tied it in with the original
object deserialiser for [SemWeb](http://razor.occams.info/code/semweb/) (a
semantic web library by [Joshua Tauberer](http://razor.occams.info/blog)).

In this post I'll give you some edited highlights of what was involved. You may
recal that last post I provided some unit tests that i was working with. For the
sake of initial simplicity (and to make it easy to produce queries with SemWeb's
GraphMatch algorithm) I restricted my query language to make use of Conjunction,
and Equality. here's the unit test that I worked with to drive the development
process. What I produced last time was a simple scanner that went through my
podcasts extracting metadata and creating objects of type Track.

    [TestMethod] public void QueryWithProjection() { CreateMemoryStore(); IRdfQuery<Track> qry = new RdfContext(store).ForType<Track>(); var q = from t in qry where t.Year == 2006 && t.GenreName == "History 5 | Fall 2006 | UC Berkeley" select new {t.Title, t.FileLocation}; foreach(var track in q){ Trace.WriteLine(track.Title + ": " + track.FileLocation); } }

This method queries the Tracks collection in an in-memory triple store loaded
from a file in N3 format. It searches for any UC Berkley pod-casts produced in
2006, and performs a projection to create a new anonymous type containing the
title and location of the files.

I took a leaf from the book of LINQ to SQL to crate the query object. In LINQ to
SQL you indicate the type you are working with using a Table\<T\> class. In my
query context class, you identify the type you are working with using a
ForType\<T\>() method. this method instantiates a query object for you, and (in
future) will act as an object registry to keep track of object updates.

The RDFContext class is very simple:

    public class RdfContext : IRdfContext { public Store Store { get { return store; } set { store = value; } } protected Store store; public RdfContext(Store store) { this.store = store; } public void AcceptChanges() { throw new NotImplementedException(); } public IRdfQuery<T> ForType<T>() { return new RdfN3Query<T>(store); } }

As you can see, it is pretty bare at the moment. It maintains a reference to the
store, and instantiates query objects for you. But in future this would be the
place to create transactional support, and perhaps maintain connections to
triple stores. By and large, though, this class will be pretty simple in
comparison to the query class that is to follow.

I won't repeat all of what Bart De Smet said in his excellent series of articles
on the production of LINQ to LDAP. I'll confine myself to this implementation,
and how it works. So we have to start by creating our Query Object:

    public class RdfN3Query<T> : IRdfQuery<T> { public RdfN3Query(Store store) { this.store = store; this.originalType = typeof (T); parser = new ExpressionNodeParser<T>(); }

First it stores a reference to the triple store for later use. In a more real
world implementation this might be a URL or connection string. But for the sake
of this implementation, we can be happy with the Memory Store that is used in
the unit test. next we keep a record of the original type that is being queried
against. this is important because later on you may also be dealing with a new
anonymous type that will be created by the projection. This will not have any of
the Owl\*Attribute classes with which to work out URLs for properties and to
perform deserialisation.

The two most important methods in IQueryable\<T\> are CreateQuery and
GetEnumerable. CreateQuery is the place where LINQ feeds you the expression tree
that it has built from your initial query. You must parse this expression tree
and store the resultant query somewhere for later use. I created a string called
query to keep that in, and created a class called ExpressionNodeParser to walk
the expression tree to build tyhe query string. This is equivalent to the stage
where the SQL SELECT query gets created in DLINQ. My CreateQuery looks like
this:

    public IQueryable<TElement> CreateQuery<TElement>(Expression expression) { RdfN3Query<TElement> newQuery = new RdfN3Query<TElement>(store); newQuery.OriginalType = originalType; newQuery.Project = project; newQuery.Properties = properties; newQuery.Query = Query; newQuery.Logger = logger; newQuery.Parser = new ExpressionNodeParser<TElement>(new StringBuilder(parser.StringBuilder.ToString())); MethodCallExpression call = expression as MethodCallExpression; if (call != null) { switch (call.Method.Name) { case "Where": Log("Processing the where expression"); newQuery.BuildQuery(call.Parameters[1]); break; case "Select": Log("Processing the select expression"); newQuery.BuildProjection(call); break; } } return newQuery; }

You create new query because you may be doing a projection, in which case the
type you are enumerating over will not be the original type that you put into
ForType\<T\>(). Instead it may be the anonymous type from the projection. You
transfer the vital information over to the new Query object, and then handle the
expression that has been passed in. I am handling two methods here: Where and
Select. There are others I could handle, such as OrderBy or Take, but that will
have to be for a future post.

Where is the part where the expression representing the query is passed in.
Select is passed the tree representing the projection (if there is one). The
work is passed off to BuildQuery and BuildProjection accordingly. these names
were gratefully stolen from LINQ to LDAP.

BuildQuery in LINQ to LDAP is a fairly complicated affair, but in LINQ to RDF I
have paired it right downb to the bone.

    private void BuildQuery(Expression q) { StringBuilder sb = new StringBuilder(); ParseQuery(q, sb); Query = Parser.StringBuilder.ToString(); Trace.WriteLine(Query); }

We create a StringBuilder that can be passed down into the recursive descent
tree walker to gather the fragments of the query as each expression gets parsed.
the result is then stored in the Query property of the Query object.
BuildProjection looks like this:

    private void BuildProjection(Expression expression) { LambdaExpression le = ((MethodCallExpression)expression).Parameters[1] as LambdaExpression; if (le == null) throw new ApplicationException("Incompatible expression type found when building a projection"); project = le.Compile(); MemberInitExpression mie = le.Body as MemberInitExpression; if (mie != null) foreach (Binding b in mie.Bindings) FindProperties(b); else foreach (PropertyInfo i in originalType.GetProperties()) properties.Add(i.Name, null); }

Much of it is taken directly from LINQ to LDAP. I have adapted it slightly
because I am targeting the May 2007 CTP of LINQ. I've done this only because I
have to use VS 2005 during the day, so I can't use the March 2007 version of
Orcas.

ParseQuery is used by BuildQuery to handle the walking of the expression tree.
Again that is very simple since most of the work is now done in
ExpressionNodeParser. It looks like this:

    private void ParseQuery(Expression expression, StringBuilder sb) { Parser.Dispatch(expression); }

Parser.Dispatch is a gigantic switch statement that passes off the expression
tree to handler methods:

    public void Dispatch(Expression expression) { switch (expression.NodeType) { case ExpressionType.Add: Add(expression); break; case ExpressionType.AddChecked: AddChecked(expression); break; case ExpressionType.And: And(expression); break; case ExpressionType.AndAlso: AndAlso(expression); //...

Each handler method then handles the root of the expression tree, breaking it up
and passing on what it can't handle itself. For example, the method AndAlso just
takes the left and right side of the operator and recursively dispatches them:

    public void AndAlso(Expression e) { BinaryExpression be = e as BinaryExpression; if (be != null) { Dispatch(be.Left); Dispatch(be.Right); } }

The equality operator is the only operator that currently gets any special
effort.

    public void EQ(Expression e) { BinaryExpression be = e as BinaryExpression; if (be != null) { MemberExpression me = be.Left as MemberExpression; ConstantExpression ce = be.Right as ConstantExpression; QueryAppend(tripleFormatStringLiteral, InstancePlaceholderName, OwlClassSupertype.GetPropertyUri(typeof(T), me.Member.Name), ce.Value.ToString()); } MethodCallExpression mce = e as MethodCallExpression; if (mce != null && mce.Method.Name == "op_Equality") { MemberExpression me = mce.Parameters[0] as MemberExpression; ConstantExpression ce = mce.Parameters[1] as ConstantExpression; QueryAppend(tripleFormatStringLiteral, InstancePlaceholderName, OwlClassSupertype.GetPropertyUri(typeof(T), me.Member.Name), ce.Value.ToString()); } }

The equality expression can be formed either through the use of a binary
expression with NodeType.EQ or as a MethodCallExpression on op\_Equality for
type string. If the handler for the MethodCallExpression spots op\_Equality it
passes the expression off to the EQ method for it to render instead. EQ
therefore needs to spot which type of Node it's dealing with to know how to get
the left and right sides of the operation. In a BinaryExpression there are Right
and Left properties, whereas in a MethodCallExpression these will be found in a
Parameters collection. In our example they get the same treatment.

You'll note that we assume that the left operand is a MemberExpression and the
right is a ConstantExpression. That allows us to form clauses like this:

    where t.Year == 2006

but it would fail on all of the following:

    where t.Name.ToUpper() == "SOME STRING" where t.Name == t.Other where t.Year.ToString() == "2006"

Each of these cases will have to be handled individually, so the number of cases
we need to handle can grow. As Bart De Smet pointed out, some of the operations
might have to be performed after retrieval of the results since semantic web
query languages are unlikely to have complex string manipulation and arithmetic
functions. Or at least, not yet.

The QueryAppend forms an N3 Triple out of its parameters and appends it to the
StringBuilder that was passed to the Parser initially. At the end of the
recursive tree walk, this string builder is harvested and preprocessed to make
it ready to pass to the triple store. In my previous post I described an
ObjectDeserialisationsSink that was passed to SemWeb during the query process to
harvest the results. This has been reused to gather the results of the query
from within our query.

I mentioned earlier that the GetEnumerator method was important to IQueryable.
An IQueryable is a class that can defer execution of its query till someone
attempts to enumerate its results. Since that's done using GetEnumerator the
query must be performed in GetEnumerator. My implementation of GetEnumerator
looks like this:

    IEnumerator<T> IEnumerable<T>.GetEnumerator() { if (result != null) return result.GetEnumerator(); query = ConstructQuery(); PrepareQueryAndConnection(); PresentQuery(query); return result.GetEnumerator(); }

result is the List\<TElement\> variable where I cache the results for later use.
What that means is that the query only gets run once. Next time the
GetEnumerator gets called, result is returned directly. This reduces the cost of
repeatedly enumerating the same query. Currently the methods ConstructQuery,
PrepareQueryAndConnection, and PresentQuery are all fairly simple affairs that
exist more as placeholders so that I can reuse much of this code for a LINQ to
SPARQL implementation that is to follow.

As you've probably worked out, there is a huge amount of detail that has to be
attended to, but the basic concepts are simple. the reason why more people
haven't written LINQ query providers before now is simply that fact that there
is no documentation about how to do it. When you try though, you may find it
easier than you thought.

There is a great deal more to do to LINQ to RDF before something it is ready for
production use, but as a proof of concept that semantic web technologies can be
brought into the mainstream it serves well. Thereason why we use ORM systems
such as LINQ to SQL is to help us overcome the Impedance Mismatch that exists
between the object and relational domains. An equally large mismatch exists
between the Object and Semantic domains. tools like LINQ to RDF will have to
overcome the mismatch in order for them to be used outside of basic domain
models.
