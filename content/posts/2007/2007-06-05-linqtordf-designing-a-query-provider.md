---
title: LinqToRdf - Designing a Query Provider
date: 2007-06-05
author: Andrew Matthews
ignored-tags: C#, Computer Science, LINQ, programming
slug: linqtordf-designing-a-query-provider
status: published
---

When I started implementing the SPARQL support in LINQ to RDF, I decided that I needed to implement as much of the [standard query operators](http://download.microsoft.com/download/5/8/6/5868081c-68aa-40de-9a45-a3803d8134b8/standard_query_operators.doc) as possible. SPARQL is a very rich query language that bears a passing syntactical resemblance to SQL. It didn't seem unreasonable to expect most of the operators of LINQ to SQL to be usable with SPARQL. With this post I thought I'd pass on a few design notes that I have gathered during the work to date on the SPARQL query provider.

The different components of a LINQ query get converted into successive calls to your query class. My class is called SparqlQuery\<T\>. If you had a query like this:

    [TestMethod]
    public void SparqlQueryOrdered()
    {
        string urlToRemoteSparqlEndpoint = @"http://someUri";
        TripleStore ts = new TripleStore();
        ts.EndpointUri = urlToRemoteSparqlEndpoint;
        ts.QueryType = QueryType.RemoteSparqlStore;
        IRdfQuery<Track> qry = new RDF(ts).ForType<Track>();
        var q = from t in qry
            where t.Year == 2006 &&
            t.GenreName == "History 5 | Fall 2006 | UC Berkeley"
            orderby t.FileLocation
            select new {t.Title, t.FileLocation};
        foreach(var track in q){
            Trace.WriteLine(track.Title + ": " + track.FileLocation);
        }
    }

This would roughly equate to the following code, using the extension method syntax:

    [TestMethod]
    public void SparqlQueryOrdered()
    {
        ParameterExpression t;
        string urlToRemoteSparqlEndpoint = http://someUri;
        TripleStore ts = new TripleStore();
        ts.EndpointUri = urlToRemoteSparqlEndpoint;
        ts.QueryType = QueryType.RemoteSparqlStore;
        var q = new RDF(ts).ForType<Track>()
            .Where<Track>(/*create expression tree*/)
            .OrderBy<Track, string>(/*create  expression tree*/)
            .Select(/*create  expression tree*/;
        foreach (var track in q)
        {
            Trace.WriteLine(track.Title + ": " + track.FileLocation);
        }
    }

The bold red method calls are the succession of calls to the query's CreateQuery method. That might not be immediately obvious from looking at the code. In fact it's downright unobvious! There's compiler magic going on in this, that you don't see. Anyway, what happens is that you end up getting a succession of calls into your IQueryable\<T\>.CreateQuery() method. And that's what we are mostly concerned about when creating a query provider.

The last I blogged about the CreateQuery method I gave a method with a switch statement that identified the origin of the call (i.e. Where, OrderBy, Select or whatever) and dispatched the call off to be immediately processed. I now realise that that is not the best way to do it. If I try to create my SPARQL query in one pass, I will not have much of a chance to perform optimization or disambiguation. If I generate the projection before I know what fields were important, I would probably end up having to get everything back and filter on receipt of all the data. I think Bart De Smet was faced with that problem with LINQ to LDAP (LDAP doesn't support projections) so he had to get everything back. SPARQL does support projections, and that means I can't generate the SPARQL query string till after I know what to get back from the Select call.

My solution to this is to keep all the calls into the CreateQuery in a Hashtable so that I can use them all together in the call to GetEnumerator. That gives me the chance to do any amount of analysis on the expression trees I've got stored, before I convert them into a SPARQL query. The CreateQuery method now looks like this:

    protected Dictionary<string, MethodCallExpression> expressions;

    public IQueryable<S> CreateQuery<S>(Expression expression)
    {
        SparqlQuery<S> newQuery = CloneQueryForNewType<S>();

        MethodCallExpression call = expression as MethodCallExpression;
        if (call != null)
        {
            Expressions[call.Method.Name] = call;
        }
        return newQuery;
    }

[](http://11011.net/software/vspaste)

This approach helps because it makes it much simpler to start adding the other query operators.

I also been doing a fair bit of tidying up as I go along. My GetEnumerator method now reflects the major grammatical components of the SPARQL spec for SELECT queries.

    private void CreateQuery(StringBuilder sb)
    {
        if(Expressions.ContainsKey("Where"))
        {
            // first parse the where expression to get the list of parameters to/from the query.
            StringBuilder sbTmp = new StringBuilder();
            ParseQuery(Expressions["Where"].Parameters[1], sbTmp);
            //sbTmp now contains the FILTER clause so save it somewhere useful.
            Query = sbTmp.ToString();
            // now store the parameters where they can be used later on.
            queryGraphParameters.AddAll(Parser.Parameters);
        }
        CreateProlog(sb);
        CreateDataSetClause(sb);
        CreateProjection(sb);
        CreateWhereClause(sb);
        CreateSolutionModifier(sb);
    }

[](http://11011.net/software/vspaste)The If clause checks whether the query had a where clause. If it did, it parses it, creating the FILTER expression, and in the process gathering some valuable information about what members from T were referenced in the where clause. This information is useful for other tasks, so it gets done in advance of creating the Where clause.
