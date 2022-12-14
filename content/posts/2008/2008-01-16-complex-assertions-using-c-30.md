---
title: Complex Assertions in C#
date: 2008-01-16
author: Andrew Matthews
category: .NET, programming
slug: complex-assertions-using-c-30
status: published
---

Recently I [attempted](http://aabs.wordpress.com/2007/10/20/lambda-functions-for-design-by-contract/) to implement a declarative predicate checking system to allow design by contract (DBC) within C\# 3.0. I was not successful due to a limitation in the kind of parameters one can pass to an Attribute constructor in .NET (no lambdas). I thought I'd just follow that up with a simpler model based on extension methods.

```
public static class Predicates
{
    public static void Assert<T>(this T obj, Func<T, bool> pred)
    {
        if (!pred(obj))
            throw new ApplicationException();
    }
}
```

This simple extension method can be attached to any object allowing Ensures and Requires like this.

```
int MyIntProp{get;set;}

public void MyMethod()
{
    this.Assert(x => x.MyIntProp < 10);
    MyIntProp += 10;
    this.Assert(x => x.MyIntProp >= 10);
}
```

[](http://11011.net/software/vspaste)This is a nice clear implementation that is good for validation. But I think that I can extend it further by exploiting serialization of snapshots within a scope to allow before/after analysis within the scope. Here's what I want to be able to write:

```
public void MyBetterMethod()
{
    this.Require(x => x.MyIntProp < 10);
    MyIntProp += 10;
    this.Ensure(x => x.MyIntProp == x.before().MyIntProp + 10);
}
```

Well, my recent writings about the Ambient Context pattern might give you a clue about how I would manage the scope. The first thing I need to be able to do is store a snapshot of the object before it gets tested by the Require. I chose an IDisposable object so that I can clean up after myself without the danger of having the serialized guts of objects lying around everywhere.

```
public class PredicateScope : IDisposable
{
    [ThreadStatic]
    public static Stack<PredicateScope> Scopes =
        new Stack<PredicateScope>();
    internal readonly Dictionary<object, string> Snapshots =
        new Dictionary<object, string>();
    internal readonly Dictionary<object, object> DeserializedSnapshots =
        new Dictionary<object, object>();

    public PredicateScope(params object[] objects)
    {
        foreach (object obj in objects)
        {
            Snapshots.Add(obj, CreateSnapShot(obj));
        }
        Scopes.Push(this);
    }

    static string CreateSnapShot(object obj)
    {
        XmlSerializer serializer = new XmlSerializer(obj.GetType());
        StringWriter sr = new StringWriter();
        serializer.Serialize(sr, obj);
        return sr.ToString();
    }

    public void Dispose()
    {
        Snapshots.Clear();
        Scopes.Pop();
    }
}
```

You just pass the scope object whatever objects you intend to test later on. It takes snapshots of the objects and stores them away for later reference. It also maintains a stack, so it can be nested. Strictly speaking this is unnecessary, but I figure it might come in handy later on.

My Assertion methods are pretty much the same, but they're now augmented by a "before" extension method that will get a snapshot keyed to the object it's extending, and return that instead.

```
public static class Predicates
{
    public static void Require<T>(this T obj, Func<T, bool> pred)
    {
        if (!pred(obj))
            throw new ApplicationException();
    }

    public static void Ensure<T>(this T obj, Func<T, bool> pred)
    {
        if (!pred(obj))
            throw new ApplicationException();
    }

    public static T before<T>(this T obj) where T : class
    {
        if (obj == null)
            throw new ArgumentNullException("obj cannot be null");

        PredicateScope ctx = PredicateScope.Scopes.Peek();
        if (ctx == null) return default(T);

        if (ctx.DeserializedSnapshots.ContainsKey(obj))
            return ctx.DeserializedSnapshots[obj] as T;
        string serializedObject = ctx.Snapshots[obj];
        XmlSerializer ser = new XmlSerializer(typeof(T));
        XmlReader reader = XmlReader.Create(new StringReader(serializedObject));
        object result = ser.Deserialize(reader);
        ctx.DeserializedSnapshots[obj] = result;
        return result as T;
    }
}
```

[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)The before method gets the snapshot out of the scope, and returns that. You can then use it in your assertions in exactly the same way as the original object.

```
[TestFixture, DataContract]
public class MyClass
{
    [DataMember]
    public int MyInt { get; set; }
    [Test]
    public void MyMethod()
    {
        using (new PredicateScope(this))
        {
            this.Require(x => x.MyInt < 10);
            MyInt += 10;
            this.Ensure(x => MyInt == x.before().MyInt + 10);
        }
    }
}
```

Obviously, for production use you'd have to ensure this stuff didn't get run by using ConditionalAttribute. It would affect performance. But for debugging it can be a godsend.
