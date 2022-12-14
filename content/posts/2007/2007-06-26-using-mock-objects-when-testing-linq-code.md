---
title: Using Mock Objects When Testing LINQ Code
date: 2007-06-26
author: Andrew Matthews
ignored-tags: C#, LINQ, programming
slug: using-mock-objects-when-testing-linq-code
status: published
---

I was wondering the other day whether LINQ could be used with NMock easily. One problem with testing code that has not been written to work with unit tests is that if you test business logic, you often end up making multiple round-trips to the database for each test run. With a very large test suite that can turn a few minute's work into hours for a test suite. the best approach to this is to use mock data access components to dispense canned results, rather than going all the way through to the database.

After a little thought it became clear that all you have to do is override the ***IOrderedQueryable\<T\>.GetEnumerator()*** method to return an enumerator to a set of canned results and you could pretty much impersonate a LINQ to SQL Table (which is the ***IOrderedQueryable*** implementation for LINQ to SQL). I had a spare few minutes the other day while the kids were going to sleep and I decided to give it a go, to see what was involved.

I'm a great believer in the medicinal uses of mock objects. Making your classes testable using mocking enforces a level of encapsulation that adds good structure to your code. I find that the end results are often much cleaner if you design your systems with mocking in mind.

Lets start with a class that you were querying over in your code. This is the type that you are expecting to get back from your query.

    public class MyEntity
    {
        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        public int Age
        {
            get { return age; }
            set { age = value; }
        }

        public string Desc
        {
            get { return desc; }
            set { desc = value; }
        }

        private string name;
        private int age;
        private string desc;
    }

[](http://11011.net/software/vspaste)

Now you need to create a new context object derived from the DLINQ ***DataContext*** class, but providing a new constructor function. You can create other ways to insert the data you want your query to return, but the constructor is all that is necessary for this simple example.

    public class MockContext : DataContext
    {
        #region constructors

        public MockContext(IEnumerable col):base("")
        {
            User = new MockQuery<MyEntity>(col);
        }
        // other constructors removed for readability
        #endregion
        public MockQuery<MyEntity> User;
    }

[](http://11011.net/software/vspaste)

Note that you are passing in an untyped ***IEnumerable*** rather than an ***IEnumerable\<T\>*** or a concrete collection class. The reason is that when you make use of projections in LINQ, the type gets transformed along the way. Consider the following:

    var q = from u in db.User
            where u.Name.Contains("Andrew") && u.Age < 40
            select new {u.Age};

[](http://11011.net/software/vspaste)

The result of ***db.User*** is an ***IOrderedQueryable\<User\>*** query class which is derived from ***IEnumerable\<User\>***. But the result that goes into ***q*** is an ***IEnumerable*** of some anonymous type created specially for the occasion. there is a step along the way when the ***IQueryable\<User\>*** gets replaced with an ***IQueryable\<AnonType\>***. If I set the type on the enumerator of the canned results, I would have to keep track of them with each call to ***CreateQuery*** in my Mock Query class. By using ***IEnumerable***, I can just pass it around till I need it, then just enumerate the collection with a custom iterator, casting the types to what I ultimately need as I go.

The query object also has a constructor that takes an ***IEnumerable***, and it keeps that till ***GetEnumerator()*** gets called later on. ***CreateQuery*** and ***CloneQueryForNewType*** just pass the ***IEnumerable*** around till the time is right. ***GetEnumerator*** just iterates the collection in the ***cannedResponse*** iterator casting them to the return type expected for the resulting query.

    public class MockQuery<T> : IOrderedQueryable<T>
    {
        private readonly IEnumerable cannedResponse;

        public MockQuery(IEnumerable cannedResponse)
        {
            this.cannedResponse = cannedResponse;
        }

        private Expression expression;
        private Type elementType;

        #region IQueryable<T> Members

        IQueryable<S> IQueryable<T>.CreateQuery<S>(Expression expression)
        {
            MockQuery<S> newQuery = CloneQueryForNewType<S>();
            newQuery.expression = expression;
            return newQuery;
        }

        private MockQuery<S> CloneQueryForNewType<S>()
        {
            return new MockQuery<S>(cannedResponse);
        }
        #endregion

        #region IEnumerable<T> Members
        IEnumerator<T> IEnumerable<T>.GetEnumerator()
        {
            foreach (T t in cannedResponse)
            {
                yield return t;
            }
        }
        #endregion

        #region IQueryable Members
        Expression IQueryable.Expression
        {
            get { return System.Expressions.Expression.Constant(this); }
        }

        Type IQueryable.ElementType
        {
            get { return elementType; }
        }
        #endregion
    }

[](http://11011.net/software/vspaste)

For the sake of readability I have left out the required interface methods that were not implemented, since they play no part in this solution. Now lets look at a little test harness:

    class Program
    {
        static void Main(string[] args)
        {
            MockContext db = new MockContext(GetMockResults());

            var q = from u in db.User
                    where u.Name.Contains("Andrew") && u.Age < 40
                    select u;
            foreach (MyEntity u in q)
            {
                Debug.WriteLine(string.Format("entity {0}, {1}, {2}", u.Name, u.Age, u.Desc));
            }
        }

        private static IEnumerable GetMockResults()
        {
            for (int i = 0; i < 20; i++)
            {
                MyEntity r = new MyEntity();
                r.Name = "name " + i;
                r.Age = 30 + i;
                r.Desc = "desc " + i;
                yield return r;
            }
        }
    }

[](http://11011.net/software/vspaste)

The only intrusion here is the explicit use of ***MockContext***. In the production code that is to be tested, you can't just go inserting ***MockContext*** where you would have used the SqlMetal generated context. You need to use a class factory that will allow you to provide the ***MockContext*** on demand in a unit test, but dispense a true LINQ to SQL context when in production. That way, all client code will just use mock data without knowing it.

Here's the pattern that I generally follow. I got it from the Java community, but I can't remember where:

    class DbContextClassFactory
    {
        class Environment
        {
            private static bool inUnitTest = false;

            public static bool InUnitTest
            {
                get { return Environment.inUnitTest; }
                set { Environment.inUnitTest = value; }
            }
            private static DataContext objectToDispense = null;

            public static DataContext ObjectToDispense
            {
                get { return Environment.objectToDispense; }
                set { Environment.objectToDispense = value; }
            }
        }

        public object GetDB()
        {
            if (Environment.InUnitTest)
                return Environment.ObjectToDispense;
            return new TheRealContext() as DataContext;
        }
    }

[](http://11011.net/software/vspaste)

Now you can create your query like this:

    DbContextClassFactory.Environment.ObjectToDispense = new MockContext(GetMockResults());
    var q = from u in DbContextClassFactory.GetDB() where ...

[](http://11011.net/software/vspaste)

And your client code will use the ***MockContext*** if there is one, otherwise it will use a LINQ to SQL context to talk to the real database. Perhaps we should call this *Mockeries* rather than Mock Queries. What do you think?
