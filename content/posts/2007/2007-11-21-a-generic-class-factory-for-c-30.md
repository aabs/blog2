---
title: A Generic Class Factory for C# 3.0
date: 2007-11-21
author: Andrew Matthews
category: .NET, programming
slug: a-generic-class-factory-for-c-30
status: published
---

For years I've been using a design pattern I picked up back in my Java days to help me make legacy classes more testable with Mock objects. I've always had a few doubts about it, but it's been useful so many times that I've never bothered to change it. I always keep a handy code snippet for it on my dev machines and I can knock them out in seconds. I don't like it because I have to create a new class factory for every type that I want to control. This evening I decided it was about time that I brought it up to date with C\# 3.0 and .NET 3.5.

My old system looked like this:

    public class MyClassClassFactory
    {
        public class Environment
        {
            public static bool InUnitTest { get; set; }
            public static IMyClass ObjectToDispense { get; set; }
        }

        public static IMyClass CreateInstance()
        {
            if (Environment.InUnitTest)
                return Environment.ObjectToDispense;
            return new MyClass() as IMyClass;
        }
    }

Environment holds a reference to an object to dispense, and InUnitTest tells the class factory whether to dispense what's in ObjectToDispense. InUnitTest is generally not that useful, especially in since the presence of something in ObjectToDispense already it that we're in a unit test. The nested Environment class serves to keep things clean from the outside world, and to act as a repository for other things that you might want to put there, like exceptions to throw, or timer delays etc.

There is no easy way to choose between multiple constructors based on parameters, nor is there a way to dispense something new every time you create an instance, nor to do custom processing before and after creating an object.

Obviously we can do something about the repetitious nature of this class by adding generic parameters to the class. What we also need is to be able to pass in parameters to the constructor function. Activator class allows you to dispense objects in that way, doing all of the reflection needed to construct your object (at runtime). That also takes care of choosing between constructors based on type as well, since Activator.CreateInstance takes a params array of objects as one of its parameters and it does the reflection needed to work out which constructor that corresponds to.

Activator has been around since .NET 1.0, but the addition of generics arrived in 2.0. I have on occasions added both of these features to class factories to reduce the clutter, but I've never thought that it was useful enough to bother blogging about. C\# 3.0 brings an additional feature that makes it so much more useful, that I thought I'd share it with you. Lambda functions, in the guise of anonymous delegates, have been around for a while too. I could have done this work a couple of years ago, but hey. Better late than never?

Providing custom objects (such as Mocks or Stubs) could be done using the old ObjectToDispense property, but with a little tweaking, we can turn that into something with arbitrary power, and the ability to do pre and post processing of the test object. What I replaced it with as a Func\<object\[\], I\> where object\[\] is the params array and I is the interface to the type you need to dispense.

Here's the class factory. All 11 lines of it:

    public static class GenericClassFactory<I, C>
        where C : I
    {
        public static Func<object[], I> Dispenser { get; set; }

        public static I CreateInstance(params object[] args)
        {
            if (Dispenser != null)
                return Dispenser(args);
            return (I) Activator.CreateInstance(typeof (C), args);
        }
    }

[](http://11011.net/software/vspaste)***I*** is the interface type we're interested in, and ***C*** is the concrete type it should dispense by default. I can use it like this:

    [Test]
    public void TestGenericClassFactory1()
    {
        IMyClass ad = GenericClassFactory<IMyClass, MyClass>.CreateInstance(1, 2, 3);
        Assert.IsNotNull(ad);
        Assert.AreEqual(ad.MyMethod(), 6);
    }

or I can assign a custom dispenser to give me a different type (that's also derived from IMyClass):

    [Test]
    public void TestGenericClassFactory2()
    {
        GenericClassFactory<IMyClass, MyClass>.Dispenser = (args) =>
            (IMyClass)Activator.CreateInstance(typeof(MyClass2), args);
        IMyClass ad = GenericClassFactory<IMyClass, MyClass>.CreateInstance(1, 2, 3);
        Assert.IsNotNull(ad);
        Assert.AreEqual(ad.MyMethod(), 6);
        Assert.IsTrue(ad is MyClass2);
    }

This time is dispenses a MyClass2 rather than a MyClass. I'm not doing anything fancy with the anonymous function here, since I'm just trying to prove a point, but you could. Lastly I can use the lambda function to bind a variable that is in scope in the test for later use.

    [Test]
    public void TestGenericClassFactoryBinding()
    {
        MyClass2 tmp = new MyClass2(2,3,4);
        GenericClassFactory<IMyClass, MyClass>.Dispenser = (args) => tmp;
        IMyClass ad = GenericClassFactory<IMyClass, MyClass>.CreateInstance(1, 2, 3);
        Assert.IsNotNull(ad);
        Assert.AreEqual(ad.MyMethod(), 9);
        Assert.IsTrue(ad is MyClass2);
    }

This capability is handy because you often need to pre-create a mock object and keep a reference to it so you can record expectations on the mock objects framework. I'd probably alias the class factory for use in the code like so:

    using MyClassFactory = GenericClassFactory<IMyClass, MyClass>;

This class factory, small though it is, can do everything that my usual class factories could, plus a whole lot more. It also makes elegant use of some nice features of C\# 3.0 that makes the whole package light, and powerful. It also makes it easier for me to retrofit testability onto legacy code which is, sadly, a common task.
