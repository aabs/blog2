---
title: C# by Contract - Using Expression Trees
date: 2008-01-18
author: Andrew Matthews
category: SemanticWeb
slug: c-by-contract-using-expression-trees
status: published
---

[Last time](http://industrialinference.com/2008/01/16/complex-assertions-using-c-30/) I created a simple, but powerful, little [design by contract](http://en.wikipedia.org/wiki/Design_by_contract) library in C\# 3.0. It took hardly any lines of code, and covered a broad range of possible usage scenarios. See [here](http://archive.eiffel.com/doc/manuals/technology/contract/), for more on DBC. One thing that bothered me was the fact that if something failed a check, it wouldn't tell what went wrong. I had a little free time today, so I thought I'd fix that. I wanted the exceptions it threw to have the text of the check we were performing. Developers need to see exactly what test failed. Generic "*assertion failed*" error messages are useless.

In my previous [efforts](http://industrialinference.com/2005/08/04/dbc-in-use-3/) at .NET DBC, I used strings to pass around the predicate body that I wished to evaluate. That allowed me to have a copy of the text handy, but with lots of drawbacks. In those frameworks, I created a new class that derived from the one being tested, but with the predicates inserted at the beginning and end of the methods they were attached to. That allowed me to do things like this:

```
[Requires("arg1 > 10")]
[Requires("arg2 < 100")]
[Ensures("$after(Prop1) == $before(Prop1) + 1")]
public void TestMethod(int arg1, int arg2, string arg3)
{
    Prop1 = Prop1 + 1;
    System.Diagnostics.Debug.WriteLine("MyTestClass.TestMethod.Prop1 == " + prop1.ToString());
}
```

This let me to test private fields and properties, but on the other hand it stopped me from testing sealed classes. There's trade-offs no matter what you do unless you control the compiler, as is the case of [Spec\#](http://en.wikipedia.org/wiki/Spec_sharp), [Eiffel](http://en.wikipedia.org/wiki/Eiffel_%28programming_language%29) or [D](http://en.wikipedia.org/wiki/D_%28programming_language%29#Example_3). The attribute based approach is not dissimilar to [Spec\#](http://research.microsoft.com/specsharp/), where a contract specification is part of the method signature rather than in the body of the method.

```
int BinarySearch(object[ ]! a, object o, int lo, int hi)
    requires 0 <= lo && lo <= hi && hi <= a.Length;
{ . . . }
```

[](http://11011.net/software/vspaste)The difference is that Spec\# uses syntactical enhancements, whereas I used Attributes. As I mentioned in [another post](http://industrialinference.com/2007/10/20/lambda-functions-for-design-by-contract/), you can't use lambda functions in Attributes, nor could you use Expression trees based on lambda functions because the attribute itself cannot be generic. Another major drawback of the textual approach shown earlier is that it isn't type-safe. You could type any old garbage into that string, and you'd never know till run-time. You don't get intellisense either. We need a better way.

[Expression trees](http://weblogs.asp.net/scottgu/archive/2007/04/08/new-orcas-language-feature-lambda-expressions.aspx) are great for what we want, they *are* strongly typed, they *can* be assigned from lambda functions and they *needn't be compiled* until they're needed. Another cool thing is that the changes needed to use lambda expressions are trivial. Here's the Require extension method I showed you last time. It uses Expressions now.

```
public static void Require<T>(this T obj, Expression<Func<T, bool>> pred)
{
    var x = pred.Compile();
    if (!x(obj))
        throw new ContractException(pred.ToString());
}
```

[](http://11011.net/software/vspaste)All I had to do was convert the Func\<T, bool\> into an Expression\<Func\<T, bool\>\>. The compiler, seeing the method signature, knows that it needs to do some background conversion. It doesn't convert and pre-compile the lambda function that you pass into the extension method. Instead it first converts it to an expression tree. The Expression\<Func\<T, bool\>\> has a Compile method that will convert it to an anonymous method, which we call just before invoking it. You may be wondering why we would bother?

Because Expression\<Func\<T, bool\>\> also overrides ToString() giving the source code of the lambda function that it was created from. That's so cool! Now I can pass the code I was trying to run into the exception class if the code fails!. Here's the kind of output you get if the check fails.

```
TestCase 'Tests.TestPredicates.MyFailingMethod'
failed: Contracts.ContractException : x => (value(Tests.TestPredicates).MyInt = x.before().MyInt)
```

That's more readable than a plain old 'ApplicationException', don't you think?  The predicates needn't be one-liners either; you can have very complex predicates in this system too. Here's an example from another project I'm working on. The use of scopes is more like the DBC implementation in the [D Programming Language](http://en.wikipedia.org/wiki/D_%28programming_language%29#Example_3).

```
public bool Insert(string location, string xmlFragment)
{
    this.Require(x => !string.IsNullOrEmpty(location));
    this.Require(x => !string.IsNullOrEmpty(xmlFragment));

    XDocument fragDoc = XDocument.Parse(xmlFragment);
    object tmpInsertPoint = LobDocument.XPathEvaluate(location);
    bool result = false;

    using (new PredicateScope(this, fragDoc, tmpInsertPoint))
    {
        this.Ensure(x => tmpInsertPoint != null);

        if (tmpInsertPoint != null)
        {
            if (tmpInsertPoint is XElement)
            {
                XElement insertPoint = tmpInsertPoint as XElement;
                insertPoint.Add(fragDoc);
                result = true;
            }
        }

        this.Ensure(x =>
            {
                XElement originalInsertPoint = tmpInsertPoint.before() as XElement;
                XElement currentInsertPoint = tmpInsertPoint as XElement;
                int countbefore = originalInsertPoint.Elements(fragDoc.Root.Name).Count();
                int countafter = currentInsertPoint.Elements(fragDoc.Root.Name).Count();
                return countafter == (countbefore + 1);
            });
    }
    return result;
}
```

This is a fairly advanced use of lambdas and expression trees, but it certainly doesn't plumb the depths of what we could do. Those of you who've read some of the stuff I did in '06 and '07 on the [internals of LINQ](http://industrialinference.com/linq/) will remember that expression trees will be storing references to all the properties and other parameters of the lambda function. That means we can add them to the ContractException. We can also show what values they were before and after the operation. Perhaps next time I'll explore what can be done with all that extra data we've now got.

Till then, enjoy!
