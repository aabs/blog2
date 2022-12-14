---
title: LINQ & Reflection in C# 3.0
date: 2006-11-13
author: Andrew Matthews
ignored-tags: C#, Code Generation
slug: linq-reflection-in-c-30
status: published
---

I posted an article the other day showing you how to exploit the query
capabilities of LINQ to do reflection over the attributes on a C\# class. I want
to show you how to exploit some of the extension methods in System.Query to make
the code even cleaner. I used a method called Members that got all of the
members in order of member type (i.e. fields first, properties next and so on).
The code looked like this:

[]{style="font-size:10pt;font-family:Courier New;"}

    public static IEnumerable<MemberInfo>Members(this Type t)
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



I needed to split the queries into each of the types we required in order to
get elements ordered by type. Well System.Query provides a neater way to do this
sort of thing. As luck would have it, I don't care what order I bring the
members back in so long as they are grouped by type and then by name. We can use
the ordering queries in LINQ to do this:

[]{style="font-size:10pt;font-family:Courier New;"}

    foreach (MemberInfo mi in from m in t.GetMembers() orderby m.GetType().Name, m.Name select m)
    {
        yield return mi;
    }

Much cleaner, and it also grabs the constructors which I forgot to add in the
previous post! ;-) The query syntax there is equivalent to the following C\# 2.0
syntax:

[]{style="font-size:10pt;font-family:Courier New;"}[]{style="color:blue;"}

    foreach (MemberInfo mi in t.GetMembers().OrderBy(a => a.GetType().Name).ThenBy(b => b.Name))
    {
        yield return mi;
    }

I can impose some specific order by using the union method:

[]{style="font-size:10pt;font-family:Courier New;"}[]{style="color:blue;"}

    foreach (MemberInfo mi in t.GetFields().Union<MemberInfo>(t.GetProperties().Union<MemberInfo>(t.GetMethods())))
    {
        yield return mi;
    }

We can mix and match these operators since they are all extension
methods on the IEnumerable\<T\> or IEnumerable types. The methods are
defined in System.Query.Sequence, so you can use the object browser or reflector
to find out what's available.

In the code generation patterns posts I wrote last year, I demonstrated that
we often need to recursively enumerate structural elements in assemblies or
databases. Here is an untyped example of how we can apply these enumerators to
simply dig through the capabilities of the type:

[]{style="font-size:10pt;font-family:Courier New;"}

    public static IEnumerable<object> ParseType(Type t)
    {
        foreach (MemberInfo mi in t.Members())
        {
            yield return mi;
            foreach (object x in mi.Attributes<DbcPredicateAttribute>())
            {
                yield return x;
            }
        }
    }

You can see that now the code required to enumerate the type is very simple.
But we haven't gained simplicity at the expense of power. We can explore the
object in any way we please.
