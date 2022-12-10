---
title: Designing a LINQ Query Provider
date: 2007-06-09 13:09
author: Andrew Matthews
tags: LINQ
slug: designing-a-linq-query-provider
status: published
---

The process of creating a LINQ query provider is reasonably straightforward. Had it been documented earlier, there would have doubtless been dozens of providers written by now. Here's the broad outline of what you have to do.

1.  Find the best API to talk to your target data store.
2.  Create a factory or context object to build your queries.
3.  Create a class for the query object(s).
4.  Choose between IQueryable\<T\> and IOrderedQueryable\<T\>.
5.  Implement this interface on the query class.
6.  Decide how to present queries to the data store.
7.  Create an Expression Parser class.
8.  Create a type converter.
9.  Create a place to store the LINQ expressions.
10. Wrap the connecting to and querying of the data store.
11. Create a result deserialiser.
12. Create a result cache.
13. Return the results to the caller.

What It Means
-------------

These steps provide you with a high-level guide to the problems you have to solve when creating a query provider for the first time. In the sections below I've tried to expand on how you will solve the problem. In many cases I've explained from the viewpoint I took when implementing LINQ to RDF. Specifically, that means my problem was to create a query provider that supported a rich textual query language communicated via an SDK, and retrieved results in a format that needed subsequent conversion back into .NET objects.

### Find the best API to talk to your target data store.

Normally there is going to be some kind of API for you to request data from your data store. The main reason for creating a LINQ query provider is that the API reflects the underlying technology to much, and you want a more full encapsulation of the technology. For instance, standard APIs in the Semantic web space deal with triples and URIs. When you're an object oriented developer, you want to be dealing with *objects* not triples. That almost definitely means that there will be some kind of conversion process needed to deal with the entities of the underlying data store. In many cases there will be several APIs to choose between, and the choice you make will probably be due to performance or ease of interfacing with LINQ. If there is no overall winner, then prepare to provide multiple query types for all the ways you want to talk to the data store. :-)

### Create a factory or context object to build your queries.

This class will perform various duties for you to help you keep track of the objects you've retrieved, and to write them back to the data store (assuming you choose to provide round-trip persistence). this class is equivalent to the Context class in LINQ to SQL. This class can provide you with an abstract class factory to perform the other tasks, like creating type converters, expression translators, connections, command objects etc. It doesn't have to be very complex, but it IS useful to have around.

In the case of LinqToRdf, I pass the class factory a structure that tells it where the triple store is located (local or remote, in-memory or persistent) and what query language to use to to query it.

### Create a class for the query object(s).

This class is the brains of the operation, and is where the bulk of your work will be.

This is the first main step in the process of creating a query provider. You will have to implement one of the standard LINQ query interfaces on it, and either perform the query from this class, or use it to coordinate those components that will do the querying.

LINQ talks to this query class directly, via the CreateQuery method, so this is the class that will have to implement the IQueryable or IOrderedQueryable interface to allow LINQ to pass in the expression trees. Each grammatical component of the query is passed into CreateQuery in turn, and you can store that somewhere for later processing.

### Choose between IQueryable\<T\> and IOrderedQueryable\<T\>.

This is a simple choice. Do you want to be able to order the results that you will be passing back? If so use IOrderedQueryable, and you will then be able to write queries using the orderby keyword. Declare your query class to implement the chosen interface.

### Implement this interface on the query class.

Now you've decided which interface to use, you have to implement this interface on the query class  from point 3. Most of the work is in the CreateQuery and GetEnumerator methods.

CreateQuery gets called once for each of the major components of the query. So for a query like this:

    var q = (from t in qry
        where t.Year == "2006" &&
        t.GenreName == "History 5 | Fall 2006 | UC Berkeley"
        orderby t.FileLocation
        select new {t.Title, t.FileLocation}).Skip(10).Take(5);

Your query class will get called five times. Once each for the extension methods that are doing the work behind the scenes: Where, OrderBy, Select, Skip and Take. If you're not aware of the use of Extension methods in the design of LINQ, go over to the LINQ project site on Microsoft and peruse the documents on the *Standard Query Operators.* The integrated part of LINQ is a kind of syntactic sugar that masks the use of extension methods to make successive calls on an object in a way which is more attractive than plain static calls.

My initial attempt at handling the expressions passed in through CreateQuery was to treat the whole process like a Recursive Descent compiler. Later on I found that to optimize the queries a little, I needed to wait till I had all of the expressions before I started processing them. The reason I did this is that I needed to know what parameters were going to be used in the projection (The Select part) before I could generate the body of the graph specification that is mostly based on the where expression.

[](http://11011.net/software/vspaste)

### Decide how to present queries to the data store.

Does the API use a textual query language, a query API or its own Expression tree system? This will determine what you do with the expressions that get sent to you by LINQ. If it is a textual query language, then you will need to produce some kind of text from the expression trees in the syntax supported by the data store (like SPARQL or SQL). If it is an API, then you will need to interpret the expression trees and convert them into API calls on the data store. Lastly, if the data store has it's own expression tree system, then you need to create a tree out of the LINQ expression tree, that the data store will be able to convert or interpret on its own (Like NHibernate).

SPARQL is a textual query language so my job was to produce SPARQL from a set of expression trees. Yours may be to drive an API, in which case you will have to work out how to invoke the methods on your API appropriately in response to the nodes of the expression tree.

### Create an Expression interpreter class.

I found it easier to break off various responsibilities into separate classes. I did this for filter clause generation, type conversion, connections, and commands. I described that in my previous post, so I won't go into much depth here. Most people would call this a Visitor class, although I think in terms of recursive descent (since that's not patented). I passed down a StringBuilder with each recursive call to the Dispatch method on the expression translator. The interpreter inserts textual representations of the properties you reference in the query, the constant values they are compared against and it appends textual representation of the operators supported by the target query language. If necessary this is where you will use a type converter class to convert the format of any literals in your expressions.

### Create a type converter.

I had to create a type converter because there are a few syntactic conventions about use of type names in SPARQL. In addition, DateTime types are represented differently between SPARQL and .NET. You may not have this problem (although I bet you will) and if that's so, then you can get away with a bit less complexity.

My type converter is just a hash table mapping from .NET primitives to XML Schema data types. In addition I made use of some custom attributes to allow me to add extra information about how the types should be handled. here's what the look up table works with:

    public enum XsdtPrimitiveDataType : int
    {
        [Xsdt(true, "string")]
        XsdtString,
        [Xsdt(false, "boolean")]
        XsdtBoolean,
        [Xsdt(false, "short")]
        XsdtShort,
        [Xsdt(false, "int")]
        XsdtInt,

The XsdtAttribute is very simple, but provides a means, if I need it, to add more sophistication at a later date:

    [AttributeUsage(AttributeTargets.Field)]
    public class XsdtAttribute : Attribute
    {
        public XsdtAttribute(bool isQuoted, string name)
        {
            this.isQuoted = isQuoted;
            this.name = name;
        }

isQuoted allows me to tell the type converter whether to wrap a piece of data in double quotes, and the name parameter indicates what the type name is in the XML Schema data types specification. Your types will be different, but the principle will be the same, unless you are dealing directly with .NET types.

I set up the lookup table like this:

    public XsdtTypeConverter()
    {
        typeLookup.Add(typeof(string), XsdtPrimitiveDataType.XsdtString);
        typeLookup.Add(typeof(Char), XsdtPrimitiveDataType.XsdtString);
        typeLookup.Add(typeof(Boolean), XsdtPrimitiveDataType.XsdtBoolean);
        typeLookup.Add(typeof(Single), XsdtPrimitiveDataType.XsdtFloat);

[](http://11011.net/software/vspaste)

That is enough for me to be able to do a one-way conversion of literals when creating the query.

### Create a place to store the LINQ expressions.

As I mentioned above, you may need to keep the expressions around until all calls into CreateQuery have been made. I used another lookup table to allow me to store them till the call to GetEnumerator.

    protected Dictionary<string, MethodCallExpression> expressions;

    public IQueryable<S> CreateQuery<S>(Expression expression){
        SparqlQuery<S> newQuery = CloneQueryForNewType<S>();
        MethodCallExpression call = expression as MethodCallExpression;
        if (call != null){
            newQuery.Expressions[call.Method.Name] = call;
        }
        return newQuery;
    }

You may prefer to have named variables for each source of expression. I just wanted to have the option to gather everything easily, before I had provided explicit support for it.

### Wrap the connecting to and querying of the data store.

This is a matter of choice, but if you wrap the process of connecting and presenting queries to your data store inside of a standardized API, then you will find it easier to port your code to new types of data store later on. I found this when I decided that I wanted to support at least 4 different types of connectivity and syntax in LinqToRdf. I also chose to (superficially) emulate the ADO.NET model (Connections, Commands, CommandText etc) there was no real need to do this, I just thought it would be more familiar to those from an ADO.NET background. the emulation is totally skin deep though, there being no need for transactions etc, and with LINQ providing a much neater way to present parameters than ADO.NET will ever have.

When you implement the IQueryable interface, you will find that you have two versions of GetEnumerator, a generic version and an untyped version. Both of these can be served by the same code. I abstracted this into a method called RunQuery.

    protected IEnumerator<T> RunQuery()
    {
        if (Context.ResultsCache.ContainsKey(GetHashCode().ToString()))
            return (IEnumerator<T>)Context.ResultsCache[GetHashCode()
              .ToString()].GetEnumerator();
        StringBuilder sb = new StringBuilder();
        CreateQuery(sb);
        IRdfConnection<T> conn = QueryFactory.CreateConnection(this);
        IRdfCommand<T> cmd = conn.CreateCommand();
        cmd.CommandText = sb.ToString();
        return cmd.ExecuteQuery();
    }

The first thing it does is look to see whether it's been run before. If it has, then any results will have been stored in the Context object (see point 2) and they can be returned directly.

If there are no cached results, then it passes a string builder into the CreateQuery object that encapsulates the process of creating a textual query for SPARQL. The query class also has a reference to a class called QueryFactory, that was created for it by the Context object. This factory allows it to just ask for a service, and get one that will work for the query type that is being produced. This is the Abstract Factory pattern at work, which is common in ORM systems and others like this.

The IRdfConnection class that this gets from the QueryFactory encapsulates the connection method that will be used to talk to the triple store. The IRdfCommand does the same for the process of asking for the results using the SPARQL communications protocol.

ExecuteQuery does exactly what you would expect. One extra facility that is exploited is the ability of the IRdfCommand to store the results directly in the context so that we can check next time round whether to go to all this trouble.

I wrote my implementation of CreateQuery(sb) to conform fairly closely to the grammar spec of the SPARQL query language. Here's what it looks like:

    private void CreateQuery(StringBuilder sb)
    {
        if (Expressions.ContainsKey("Where"))
        {
            // first parse the where expression to get the list
            // of parameters to/from the query.
            StringBuilder sbTmp = new StringBuilder();
            ParseQuery(Expressions["Where"].Parameters[1], sbTmp);
            //sbTmp now contains the FILTER clause so save it
            // somewhere useful.
            FilterClause = sbTmp.ToString();
            // now store the parameters where they can be used later on.
            if (Parser.Parameters != null)
                queryGraphParameters.AddAll(Parser.Parameters);
            // we need to add the original type to the prolog to allow
            // elements of the where clause to be optimised
            namespaceManager.RegisterType(OriginalType);
        }
        CreateProlog(sb);
        CreateDataSetClause(sb);
        CreateProjection(sb);
        CreateWhereClause(sb);
        CreateSolutionModifier(sb);
    }

I've described this in more detail in my previous post, so I'll not pursue it any further. The point is that this is the hard part of the provider, where you have to make sense of the expressions and convert them into something meaningful. For example the CreateWhereClause looks like this:

    private void CreateWhereClause(StringBuilder sb)
    {
        string instanceName = GetInstanceName();
        sb.Append("WHERE {\n");
        List<MemberInfo> parameters = new List<MemberInfo>(
          queryGraphParameters.Union(projectionParameters));
        if (parameters.Count > 0)
        {
            sb.AppendFormat("_:{0} ", instanceName);
        }
        for (int i = 0; i < parameters.Count; i++)
        {
            MemberInfo info = parameters[i];
            sb.AppendFormat("{1}{2} ?{3} ", instanceName,
              namespaceManager.typeMappings[originalType] + ":",
              OwlClassSupertype.GetPropertyUri(originalType,
                info.Name, true), info.Name);
            sb.AppendFormat((i < parameters.Count - 1) ? ";\n" : ".\n");
        }
        if (FilterClause != null && FilterClause.Length > 0)
        {
            sb.AppendFormat("FILTER(\n{0}\n)\n", FilterClause);
        }
        sb.Append("}\n");
    }

[](http://11011.net/software/vspaste)

 The meaning of most of this is specific to SPARQL and won't matter to you, but you should take note of how the query in the string builder is getting built up piece by piece, based on the grammar of the target query language.

### Create a Result Deserialiser.

Whatever format you get your results back in, one thing is certain. You need to convert those back into .NET objects. SemWeb exposes the SPARQK results set as a set of Bindings between a

    public override bool Add(VariableBindings result)
    {
        if (originalType == null) throw new ApplicationException
             ("need a type to create");
        object t = Activator.CreateInstance(instanceType);
        foreach (PropertyInfo pi in instanceType.GetProperties())
        {
            try
            {
                string vn = OwlClassSupertype.GetPropertyUri(OriginalType, pi.Name).Split('#')[1];
                string vVal = result[pi.Name].ToString();
                pi.SetValue(t, Convert.ChangeType(vVal, pi.PropertyType), null);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return false;
            }
        }
        DeserialisedObjects.Add(t);
        return true;
    }

[](http://11011.net/software/vspaste)

InstanceType is the type defined in the projection provided by the Select expression. Luckily LINQ will have created this type for you. You can pass the type (as a generic type parameter) to the deserialiser. the process is quite simple. In LinqToRdf, the following steps are performed:

1.  create an instance of the projected type (or the original type if using an identity projection)
2.  for each public property on the projected type
    1.  Get the matching property from the original type (which has the OwlAttributes on each property)
    2.  Lookup the RDFS property name used for the property we're attempting to fill
    3.  Lookup the value for that property from the result set
    4.  Assign it to the newly created instance
3.  Add the instance to the DeserialisedObjects collection

The exact format your results come back in will be different, but again the principlple remains the same - create the result object using the Activator, fill each of its public properties with values from the result set. Repeat until all results have been converted to .NET objects.

### Create a Result Cache.

One advantage of being able to intercept calls to GetEnumerator is that you have the option to cache the results of the query, or to cache the intermediate query strings you used to get them. This is one of the great features of LINQ (and ORM object based queries generally).

In the case of Semantic web applications we don't necessarily expect the data in the store to be changing frequently, so I have opted to store the .NET objects returned from the previous query (if there is one).  I suspect that I will opt to unmake this decision, since in the case of active data stores there is no guarantee that the results will remain consistent. It is still a major time saving to be able to run the query using the query string generated the first time round. In the case of LINQ to RDF using SPARQL this corresponds to around 67ms to generate the query. Admittedly the query including connection processing and deserialisation takes a further 500ms for a small database, but there are further optimizations that can be added at a later date.

### Return the Results to the Caller.

This is the last stage. Just get the results that you stored in the Context and return an enumerator from the collection. If you have the luxury to be able to use cursors or some other kind of incremental retrieval from the data store, then you will want to consider whether to use a custom iterator to deserialise objects on the fly.
