---
title: Pattern Matching in C#
date: 2008-11-14 08:46
author: Andrew Matthews
category: SemanticWeb
slug: patternmatching
status: published
---

I recently used Matthew Podwyszocki's [pattern matching](http://weblogs.asp.net/podwysocki/archive/2008/09/16/functional-c-pattern-matching.aspx) classes for a top level exception handler in an App I'm writing. Matthew's classes are a really nice fluent interface attaching predicates to functions generating results. I used it as a class factory to select between handlers for exceptions. Here's an example of how I used it:


    ExceptionHandler handler = ex.Match()
        // . . .
        .With(e => e.GetType().Equals(typeof(SoapException)),
                 e=> new ReallocateEndpointHandler() as ExceptionHandler)
        .With(e => e.Message.Contains("Could not acquire agent object."),
                 e => new CleanupSessionHandler() as ExceptionHandler)
        // . . .
        .Else(e=>new ExceptionSwallowingHandler() as ExceptionHandler)
        .Do();

Clearly a very useful API to provide complex pattern matching against a value. It has two drawbacks that prevented me from using it to do health checking and validation: caching of the pattern matcher and parameterisation of the function with incomming values. You use the above handler on a given value 'ex' in a catch block. I have a whole SOAP API that I'm working with that can return similar exceptions, so presently I'd need to replicate the above code wherever I wanted to trap exceptions. This is too verbose, so I looked at stripping out some of the components that prevented me from reusing a pattern matcher. Here's an example of what I came up with:


    int x = 5;
    var fn = SwitchOn<T>.Match()
        .Case(y => y  y >= 5 && y  y >10, High)
        .AsFunction();
    fn(x);

The code is much more like a souped up 'switch' statement rather than a souped up assignment statement as it was in Matthew's example. He uses a generic extension method to act as a constructor creating a context object that then constructs the pattern matcher we will really use. The type 'T' for the construction process is thus derived from the type of the object that the Match method is invoked on. The obvious corrolary is that you need to have an object to invoke that extension method on. I didn't want to do it that way because I wanted to create functions that I could invoke later on.

First I converted the extension method to a plain old static method. Here's the SwitchOn\<T\> class (in Matthew's example it was called PatternMatchExtensions - I renamed it to get a fluent interface that made more sense for how I wanted to use it)


    public class SwitchOn<T>{
        public static SwitchOn<T> Match() {
            return new SwitchOn();
        }
        public PatternMatch<T> Case(
            Predicate<T> condition,
            Action<T> result) {
            var match = new PatternMatch<T>();
            return match.Case(condition, result);
        }
    }

As with Matthew's example this object quickly gives way to an object of type PatternMatch\<T\> that gradually builds up the case list to run against the input data. In my case, though, you don't need to reserve space for the 'value' object, just the type that it will have:

    public class PatternMatch<T>{
        private readonly List<Tuple<Predicate<T>, Action<T>>> cases
            = new List<Tuple<Predicate<T>, Action<T>>>();
        private Action<T> elseFunc;
        public PatternMatch<T> Case(Predicate<T> condition, Action<T> result) {
            cases.Add(new Tuple<Predicate<T>, Action<T>>(condition, result));
            return this;
        }
        public PatternMatch<T> Else(Action<T> result) {
            if (elseFunc != null)
                throw new InvalidOperationException("Cannot have multiple else cases");
            elseFunc = result;
            return this;
        public Action<T> AsFunction() {
            return t =>{
                        if (elseFunc != null)
                            cases.Add(new Tuple<Predicate<T>, Action<T>>(x => true,
                                elseFunc));
                        foreach (var item in cases)
                            if (item.First(t)) {
                                item.Second(t);
                                return;
                            }
                        throw new MatchNotFoundException("Incomplete pattern match");
                    };
        }
    }

The type parameters are different because everywhere he used Func\<T, TResult\> I am using Action\<T\> - I don't care about the results. Another difference is that Matthew's 'Do' method is now a higher-order function 'AsFunction' returning a function to apply to a given 'T'. We can store it and pass it around for later use.

Thanks to Matthew for the original inspiration. I hope that this addition fills out more of the PatternMatching picture.
