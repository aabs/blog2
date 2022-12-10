---
title: Using C# 3.0 For Reflection
date: 2006-11-09 13:26
author: Andrew Matthews
ignored-tags: C#, Code Generation
slug: using-c-30-for-reflection
status: published
---

C\# in Orcas will provide a bunch of really useful tools for those who want to perform tasks involving reflection. The reflection APIs in C\# are already excellent but with the new query capabilities provided by LINQ, Reflection will be a real pleasure. There’ve been a few excellent posts on the topic.

In this post I’ll show you how to use the attribute metadata system to filter types using LINQ. In past posts I’ve talked about the Design By Contract (DBC) system I used to generate pre and post conditions for methods on a class. In the post I’ll use Queries, Extension Methods, and iterators to show you how to get types for inserting into the code generation system. Just to recap, here’s how I annotate a class:

[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}

    [Dbc, Invariant("Prop1 >= 1")]
    public class MyTestClass
    {
        public MyTestClass()
        {
            Prop1 = 10;
        }

        int prop1 = 0;
        [Requires("value != 1561")]
        public int Prop1
        {
            get
            {
                return prop1;
            }
            set
            {
                prop1 = value;
            }
        }

        [Requires("arg1 > 10")]
        [Requires("arg2 < 100")]
        [Ensures("$after(Prop1) == $before(Prop1) + 1")]
        public void TestMethod(int arg1, int arg2, string arg3)
        {
            Prop1 = Prop1 + 1;
            Debug.WriteLine("MyTestClass.TestMethod.Prop1 == {0}", prop1);
        }
    }

The class is annotated by a DbcAttribute plus some optional InvariantAttribute attributes. The members are optionally annotated with InvariantAttribute, RequiresAttribute and EnsuresAttribute. The code generator needs to create proxies for any classes that contain any of these attributes, but by convention I wrap only those classes that are adorned with the DbcAttribute to make life simpler. With queries we can do away with the DbcAttribute, but at the cost of having to do more itieration which will affect performance. This will be an issue if you are using the queries for dynamic proxy generation. If you perform static code generation it’s less of an issue. We first need a query to check whether a class has the DbcAttribute.

[]{style="font-size:10pt;font-family:'Courier New';"}[]{style="font-size:10pt;font-family:'Courier New';"}[]{style="font-size:10pt;font-family:'Courier New';"}[]{style="font-size:10pt;font-family:'Courier New';"}[]{style="font-size:10pt;font-family:'Courier New';"}[]{style="font-size:10pt;font-family:'Courier New';"}[]{style="font-size:10pt;font-family:'Courier New';"}[]{style="font-size:10pt;font-family:'Courier New';"}[]{style="font-size:10pt;font-family:'Courier New';"}

    public static bool HasAttribute(this Type t, Type attrType)
    {
        return t.GetCustomAttributes(attrType, true).Count() > 0;
    }

HasAttribute is an extension method that uses the Count() extension method from System.Query to get the number of elements in the collection returned. It just declares if there is more than one of them. Now we can perform a query to get all classes that have the attribute:[ ]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}

    private void Example1()
    {
        IEnumerable<Type> annotated =
        from t in GetType().Assembly.GetTypes()
        where t.HasAttribute(typeof(DbcAttribute))
        select t;
        Console.WriteLine("classes: {0}", annotated.Count());
        Console.ReadKey();
    }

This is now every class that needs to have code generated for it. Now we can enumerate the collection of members of the classes.

[]{style="font-size:8pt;font-family:'Courier New';"}

    private static void Example2()
    {
        Type T = typeof(MyTestClass);
        int count = T.GetCustomAttributes(typeof(DbcAttribute), true).Count();
        IEnumerable<Type> annotated = from t in typeof(Program).Assembly.GetTypes()
                                     where t.HasAttribute(typeof(DbcAttribute))
                                      select t;
        Console.WriteLine("classes: {0}", annotated.Count());
        Console.ReadKey();
        foreach (MemberInfo mi in GetAllMembers(T))
        {
            Console.WriteLine("member: {0}",mi.Name);
            DisplayAttributes<InvariantAttribute>(mi);
            DisplayAttributes<RequiresAttribute>(mi);
            DisplayAttributes<EnsuresAttribute>(mi);
        }
        Console.ReadKey();
    }

    private static void DisplayAttributes<AttrType>(MemberInfo mi) where AttrType : DbcPredicateAttribute
    {
        foreach (AttrType ra in GetAllAttributes<AttrType>(mi))
        {
            Console.WriteLine("tAttribute: {0} ({1})", ra.Predicate, typeof(AttrType).Name);
        }
    }

    private static IEnumerable<MemberInfo> GetAllMembers(Type t)
    {
        foreach (FieldInfo fi in t.GetFields())
            yield return fi;
        foreach (PropertyInfo pi in t.GetProperties())
            yield return pi;
        foreach (MethodInfo mi in t.GetMethods())
            yield return mi;
        foreach (EventInfo ei in t.GetEvents())
            yield return ei;
    }

    private static IEnumerable<AttrType> GetAllAttributes<AttrType>(MemberInfo mi) where AttrType : Attribute
    {
        foreach (AttrType ra in mi.GetCustomAttributes(typeof(AttrType), true)
                               .Where(t => t.GetType().Equals(typeof(AttrType))))
        {
            yield return ra as AttrType;
        }
    }

Now we have iterators for all classes that are adorned with a specific attribute, and likewise for all members of those classes. Each member can have specific attributes iterated as well. That’s nice, but we really need a clean interface to provide iterators over a class.

[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}

    public static class DbcClassIterator
    {
        public static IEnumerable<Type> DbcTypes(this Assembly asm)
        {
            return from t in asm.GetTypes()
                   where t.HasAttribute(typeof(DbcAttribute))
                   select t;
        }

        public static IEnumerable<MemberInfo> Members(this Type t)
        {
            foreach (FieldInfo fi in t.GetFields())
                yield return fi;
            foreach (PropertyInfo pi in t.GetProperties())
                yield return pi;
            foreach (MethodInfo mi in t.GetMethods())
                yield return mi;
            foreach (EventInfo ei in t.GetEvents())
                yield return ei;
        }

        public static IEnumerable<AttrType> Attributes<AttrType>(this MemberInfo mi)
            where AttrType : Attribute
        {
            foreach (AttrType ra in mi.GetCustomAttributes(typeof(AttrType), true)
                          .Where(t => t.GetType().Equals(typeof(AttrType))))
            {
                yield return ra as AttrType;
            }
        }

        public static IEnumerable<AttrType> Attributes<AttrType>(this IEnumerable<MemberInfo> emi)
            where AttrType : Attribute
        {
            foreach (MemberInfo mi in emi)
            {
                foreach (AttrType ra in mi.GetCustomAttributes(typeof(AttrType), true)
                        .Where(t => t.GetType().Equals(typeof(AttrType))))
                {
                    yield return ra as AttrType;
                }
            }
        }
    }

This class makes heavy use of Extension methods to allow the comfortable treatment of framework classes for our reflection tasks. Now we can iterate over the collections in various ways.[ ]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}[]{style="font-size:8pt;font-family:'Courier New';"}

    private static void Example3()
    {
        Type t = typeof(MyTestClass);
        foreach (Type type in t.Assembly.DbcTypes())
        {
            // just get every requires attribute in the type
            foreach (DbcPredicateAttribute pa in type.Members().Attributes<RequiresAttribute>())
            {
                Console.WriteLine("predicate: {0}", pa.Predicate);
            }
            Console.ReadKey();
            // get all members and then get all attributes in order.
            foreach (MemberInfo mi in type.Members())
            {
                Console.WriteLine("member: {0}", mi.Name);
                mi.DisplayAttributes<InvariantAttribute>();
                mi.DisplayAttributes<RequiresAttribute>();
                mi.DisplayAttributes<EnsuresAttribute>();
            }
        }
        Console.ReadKey();
    }

It’s really pretty neat. It doesn’t do anything we couldn’t do before but it does it in a way that makes it seem as though the framework classes provide all of the features we need from them out of the box. I like that, it makes code much more readable.
