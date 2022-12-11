---
title: How LINQ Works – Where
date: 2006-11-14 08:35
author: Andrew Matthews
ignored-tags: C#
slug: how-linq-works-%e2%80%93-where
status: published
---
Attachments: 2006/11/expression.PNG

I went digging under the surface of the LINQ query extension and iterators recently - I wanted to know how much I pay for the simplicity I get with APIs from the System.Query namespace. This post explores a little of the implementation of one of the key parts of the LINQ system. I'm starting out with the System.Query.Sequence.Where extension method because it follows on nicely from the [last post](http://aabs.wordpress.com/2006/11/13/linq-reflection-in-c-30/) on LINQ and Reflection.

An extension method is just a syntactic alternative to a normal static method that takes as its first argument a type that it will manipulate. An extension can't do anything that a normal static method can't, therefore we can ignore the method itself – it's the object model that counts in LINQ, and the framework of expressions and iterators that it depends on.

I'll start out by exploring the implementation of Sequence.Where. I will use the convention of referring to it as IEnumerable\<T\>.Where in places because, being an extension method, it extends IEnumerable\<T\> because that's its first argument. The Where method doesn't do a whole lot before delegating to an internal WhereIterator object that iterates the collection:

`[Extension] public static IEnumerable<T> Where<T>(IEnumerable<T> source, Func<T, bool>predicate) {   if (source == null)   {     throw Error.ArgumentNull("source");   }   if (predicate == null)   {     throw Error.ArgumentNull("predicate");   }   return Sequence.WhereIterator<T>(source, predicate); }`

[All it does is a bit of validation before invoking Sequence.WhereIterator\<T\>. The WhereIterator method does the same with a code-generated class that Reflector reports as [[Sequence]{style="color:#006018;"}](http://www.aisto.com/roeder/dotnet/Default.aspx?Object=7).[[\<WhereIterator\>d\_\_0]{style="color:#006018;"}](http://www.aisto.com/roeder/dotnet/Default.aspx?Object=8 "System.Query.Sequence+<WhereIterator>d__0<T>.<WhereIterator>d__0<T>(int);")\<T\>. This is just a conversion of the C\# syntax for iteration into plainer fare. If we take a peek at the relevant piece of decompiled code for the iterator we see the code for the iteration. It's pretty ugly, and not much worth reading except to get an idea of how the iteration takes place.
]{style="font-size:8pt;font-family:Tahoma;"}

    private bool MoveNext()
    {
          bool flag1;
          try
          {
                switch (this.<>1__state)
                {
                      case 0:
                            this.<>1__state = -1;
                            this.<>7__wrap2 = this.source.GetEnumerator();
                            this.<>1__state = 1;
                            goto Label_0081;

                      case 1:
                            goto Label_00A8;

                      case 2:
                            goto Label_007A;

                      default:
                            goto Label_00A8;
                }

         Label_003F:
                this.<element>5__1 = this.<>7__wrap2.Current;
                if (!this.predicate(this.<element>5__1))
                {
                      goto Label_0081;
                }
                this.<>2__current = this.<element>5__1;
                this.<>1__state = 2;
                return true;
          Label_007A:
                this.<>1__state = 1;
          Label_0081:
                if (this.<>7__wrap2.MoveNext())
                {
                      goto Label_003F;
                }
                this.<>1__state = -1;
                if (this.<>7__wrap2 != null)
                {
                      this.<>7__wrap2.Dispose();
                }
          Label_00A8:
                flag1 = false;
          }
          fault
          {
                ((IDisposable) this).Dispose();
          }
          return flag1;
    }

Under the label Label\_003F the predicate passed to Where is invoked on the current item. If the result is false, the iterator jumps to Label\_0081 where it skips forward one place, before going back to check the predicate again. So in essence the iterator came from something like this:

    foreach (T val in collection)
    {
        if(predicate(val))
            yield return val;
    }

Aside from noting the foreach syntax's brevity, we can also see that the efficiency of the Where method is directly related to the efficiency of the iterator of the underlying collection class. Every item in the collection has to be visited, and compared before the WhereIterator can decide whether to yield it to the caller. That means that in large collections where the time to iterate the whole collection is significant, Where's filtering capabilities are not guaranteed to speed up your iterations. I say not guaranteed, as though there might be cases where that's not the case, because there are two Where extensions and it all depends on the capabilities of the iterator on the collection we are filtering. Another extension method (System.Query.Queryable.Where) extends the IQueryable\<T\> interface, and has the potential to go a long way further than the Where on IEnumerable\<T\>.

IEnumerable\<T\> iterates a collection that has already been created and instantiated. IEnumerable\<T\>.Where just iterates it. IQueryable\<T\>.Where is an altogether different sort of extension, and deserves much more interest than the common-or-garden selection mechanism in System.Query.Sequence.Where.

    [Extension]
    public static IQueryable<T>Where<T>(IQueryable<T> source, Expression<Func<T, bool>>predicate)
    {
          if (source == null)
          {
                throw new ArgumentNullException("source");
          }
          if (predicate == null)
          {
                throw new ArgumentNullException("predicate");
          }
          return source.CreateQuery<T>(Expression.Call(((MethodInfo) MethodBase.GetCurrentMethod())
    .MakeGenericMethod(new Type[] { typeof(T) }), null, new Expression[] {
    source.Expression, predicate }));
    }

There's a lot more going on here than in the case of IEnumerable\<T\>.Where. We have the same pattern of validation, followed by delegation to another class. In this case the delegation happens when the CreateQuery method is invoked on the IQueryable\<T\> object of the method. Since we know that the first parameter of an extension method is the object being extended we know that the query we call it on is being called. Here the implementation being used is in System.Query.SequenceQuery\<T\>.CreateQuery. It also follows the same validate & delegate pattern. This time it creates a new SequenceQuery\<T\> instance out of the parameters passed to Where\<T\>. let's first take a look at what happens in the Expression.Call method:

    public static MethodCallExpression Call(MethodInfo method, Expression obj, IEnumerable<Expression>parameters)
    {
          ReadOnlyCollection<Expression> collection2 = ReadOnlyCollectionExtensions.ToReadOnlyCollection<Expression>(parameters);
          Expression.ValidateCallArgs(method, obj, collection2);
          return new MethodCallExpression(ExpressionType.MethodCall, method, obj, collection2);
    }

The first thing it does is create a read-only collection out of the parameters – which in this case are the Expression from the source query, and the predicate object that is passed to the Where method to begin with. This collection is then validated. Finally a new MethodCallExpression is created out of a new generic method, and the collection of params created previously. The generic method is created in a subclass of MethodBase in System.Reflection. It creates a method that has a type parameter of type T (i.e. whatever type we were dealing with in the IQueryable\<T\>). The method created is a stub, to give the LINQ system details about the predicate that it needs to call later on. It needs to do this because it won't be calling the predicate immediately, and it needs to store a reference to the method in an expression tree.

At this point we have created a new Expression object with a new root of type MethodCallExpression. It has branches that are the reference to the initial Expression passed as a parameter to the Where method and the predicate that we plan to use later on. Interestingly the Expression.Call method takes a parameter called obj that is not used in this case. You might have expected it to be passed the initial Expression as this parameter since that argument calls for an Expression, but instead the original expression is stored as an element in the parameters collection of the new root node.

[![The Expression Tree]({static}2006/11/expression.PNG)]({static}2006/11/expression.PNG "The Expression Tree")

[**Figure 1. The New Expression tree created by a call to Queryable.Where
**]{style="font-size:9pt;color:#4f81bd;"}

It's just added a node to an expression tree, and done no iteration at all. This is why Queryable.Where is so different from the first extension on IEnumerable\<T\>. It leaves the interpretation of the expression tree till later. This is very cool because it means you can create these expression trees, store them, serialize them, and pass them around. You invoke them later like a normal iterator when you're ready for the data. A key scenario for this sort of capability is ad-hoc querying. You can build these queries up as the user chooses search criteria to be added to the expression tree, and then go get the results later on.

Next time, I'll show you how the iteration works on normal Sequences such as we might get from reflection, and we'll take a peek at how things work in the case of DLINQ (LINQ to SQL). In DLINQ a lot of ORM intelligence is hidden under the hood of the iterator and the Expression tree. We'll see that the beauty of LINQ is that it manages to cleanly encapsulate the technology we need to get to the data we're working with. As I said in a [previous post](http://aabs.wordpress.com/2006/11/01/intrusive-technology/), it's vitally important to creating robust and maintainable code.
