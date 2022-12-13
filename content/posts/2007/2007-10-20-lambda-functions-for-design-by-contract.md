---
title: Lambda Functions for Design By Contract
date: 2007-10-20 22:35
author: Andrew Matthews
slug: lambda-functions-for-design-by-contract
status: published
---

This is sadly not one of those blog posts where I show you what I have managed to achieve. Instead it's one where I ask you if ***you*** have a solution for what I am after.

When I was at university, my professor convinced me that the benefits of design by contract were worth the cost of the implementation. In every language that I have worked with ever since, I have implemented some sort of veneer over the top of the language to enable design by contract. I've used all sorts of code generators or AOP systems to do it for me. As you may have seen from my last post, I've been on the WCF Masterclass with Juval Lowy, and I've been inspired by the pretty extensibility model of WCF to give DBC in C\# another stab.

WCF provides class construction behavior that is nicely extensible through the use of attributes. If an attribute, for example, derives from IServiceBehaviour, then WCF will  run a method on the attribute, passing in the object that the attribute was attached to. This gives the attribute (or a helper class that it uses) the opportunity to modify some of the settings for the context of the service. This is a perfect model for me to do the same thing using predicates in a DBC system. First I just need to designate an interface class that marks a derived attribute as worth paying attention to by my class factory. Lets call it IExtensibilityBehaviour. If the class factory spots an attribute on a type it's trying to dispense, it can provide special behavior for the class such as wrapping it, or running something like PostSharp over it to insert some code to run pre and post condition predicates. here's an example attribute that I want to attach to a class:

    [AttributeUsage(AttributeTargets.Class, Inherited = true, AllowMultiple = true)]
    sealed class InvariantPredicateAttribute : Attribute, IExtensibilityBehaviour
    {
        Func<object, bool> Predicate { get; set; }
        public InvariantPredicateAttribute(DbcPredicate predicate)
        {
          Predicate = predicate;
        }

        public void Validate(object x)
        {
            if (!Predicate(x))
                throw new ApplicationException("Invariant Predicate Failed");
        }
    }

The attribute above takes a delegate as a constructor parameter and stores it in the Predicate property. I can then add the attribute to a class like so:

    [InvariantPredicate((TestClass x)=>x.FirstName != null)]
    public class TestClass
    {
        public string FirstName { get; set; }
    }

As you can see, I insert a Lambda function as the parameter, which I could then elsewhere invoke like so:

    TestClass t = new TestClass()
    // Do something with it
    foreach (InvariantPredicateAttribute ipa in
        typeof(TestClass).GetCustomAttributes(
            typeof(InvariantPredicateAttribute), true))
    {
         ipa.Validate(t);
    }

Sadly, this is where I come to a crashing halt. You can't do this in C\# 3 or less. I get the following:

C:\\...\\AttributeEx.cs(34,29): error CS1706: Expression cannot contain anonymous methods or lambda expressions

[](http://11011.net/software/vspaste)If you read the commentary [here](https://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=91383), from a year or two ago, it seems to imply that the problem would be solved in future builds of VS.NET. Well, I'm running the latest beta of VS.NET 2008, and it still is a problem. Which is where YOU come in. Can you think of a way for me to get round this? I've tried a few ideas, and I just can't get it to work for one reason or another.

Help. Please.
