---
title: Generic Algorithms in C#
date: 2006-10-05
author: Andrew Matthews
ignored-tags: C#
slug: generic-algorithms-in-c
status: published
---

This post describes generic programming and the capabilities of generics in C\#. I conclude that C\# Generics and C\# generally are not able to solve issues that are easy in the Standard Template Library. ***Nothing would make me happier than if you were able to demonstrate to me that my conclusions are wrong. If thats true, please don't keep it to yourself!!!!!***

Ever since moving to C\# from C++, I've missed the expressive power and elegance of the Standard Template Library (STL). When generics were introduced into C\# 2.0 I assumed that to gain runtime type safety, some of that expressive power had to be sacrificed. My initial impression was that it was good only for generic collections, but not for those idioms that revolutionized C++ when the STL was adopted, and after Alexandrescu published his eye-opening [*Modern C++ Design*]{style="font-size:9pt;font-family:Tahoma;"}. I'd never found the time to confirm my misgivings, so I recently made time to explore the issues - I've been working on a .NET project based on legacy code which was - how can I put it delicately - based on the best practice of yesteryear! I have a pressing incentive to find clean, expressive and sexy ways to enhance the code-base and architecture. Obviously, I'm breathless with anticipation of Linq in all its forms, but I have a job to do now with the tools at hand.

I don't think I've ever seen syntactic and idiomatic support in any framework to better STL as it stood a decade ago. Don't get me wrong - I love C\# - but I regret that I can't combine the best of both worlds. Are generics in C\# 2.0 too impoverished to be able to provide the power of STL? Are we able to provide the full power that has until now been the exclusive reserve of STL developers?

Algorithms + Data Structures = Programs[ ]{style="font-size:13pt;"}
-------------------------------------------------------------------

The STL stems from work done by Alex Stepanov and Meng Lee, and earlier work on generic programming by Stepanov and Musser. Their object was to produce a set of general purpose container classes and associated algorithms that could exist independently. In languages that don't support generics, you have four choices when you want to provide standard algorithms on containers:

-   you implement every method that you need on each container class (The MFC approach).
-   you code all containers and algorithms in terms of some common data type (the .NET System.Collections approach)
-   you implement a code generation system that creates strongly typed containers and algorithms (the solution in GCC prior to the introduction of templates in C++)
-   you don't bother implementing algorithms at all (The C5 approach).

None of these options is particularly desirable, so Stepanov & Co developed an idiom for coding in C++ that allowed algorithms to be developed independently of data structures. This is an important point - you can develop a sort method that will sort a linked list as easily as an array. It's not easy. His approach was to employ *iterators*, a set of coding conventions, and type exports.

Iterators
---------

Iterators are vital - they provide the topology independent mechanism for getting at the elements in a collection. The Iterators in STL are based on pointer semantics, and in the case of arrays may actually be implemented using a pointer. The key feature of a pointer is that it provides a way to dereference a collection element (using [operator \*]{style="font-size:10pt;font-family:Courier New;"}) to move forward and backward through the collection ([operator +]{style="font-size:10pt;font-family:Courier New;"}+ and [operator --]{style="font-size:10pt;font-family:Courier New;"}). in .NET, [IEnumerator\<T\>]{style="font-size:10pt;font-family:Courier New;"} provides roughly the same functionality, and in general it is provided as a nested class within a collection. There's nothing sacred about pointer syntax. We can implement an iterator without using operator overloading. The key thing is pointer *semantics.* Pointers treat a block of memory as ordered, contiguous and typed. By being typed you know how far to move forward to get to the beginning of the next object. In other words, you can easily move forward through the ordered collection of objects. In the case of C/C++ pointers by using the operator++ method, but it could just as easily be by using a MoveNext method.

Option 2 is what we are currently faced with in C\#'s System.Collections - all container classes store references to System.Object. If you want to ensure type safety in your system you'll probably find yourself with all accesses to the container using casts and try-catch blocks to ensure no foreign bodies are introduced by accident. It's nasty, messy and these days unnecessary when you have generics. The burning question is - if you can have generic data structures does that mean you can also have generic algorithms?

The answer to that is a resounding NO! Which is the reason why a lot of ex C++ programmers were sceptical at the usefulness of generics in C\#. Sure they can help you store stuff easier, but they alone can't provide a rich language in which to define generally useful reusable functionality. In STL, iterators are hand-coded nested classes in a collection. Their behaviour is dictated by the iterator category to which they belong. Iterators are classified as forward, reverse, bi-directional, or random access. They can also be const or non-const.

It's worth quickly noting at this point that we can't tack iterators onto the collection classes using external methods. We can attach methods such as Begin and End to the collections, but the iterators can't access the storage managed by those collections – they're strictly limited to accessing public methods, properties and fields. They are limited by the accessors already provided by the collections. The iterators could potentially be limited to one form of iteration – the forward iterator of IEnumerator\<T\>. That isn't a hard and fast rule, but it is a concern!

In C\#, the standard collection classes define iterators by implementing the IEnumerable\<T\> interface. IEnumerable\<T\> provides a means for algorithms to get at the IEnumerator\<T\> interface which is the actual iterator. However, STL would classify the in-built iterators as '*Trivial Iterators*'. With the advent of the ***yield*** keyword, we can now define more than one iterator on a collection. This overcomes one hurdle to generic algorithms – different algorithms will require different types of iterator – if the framework only supports one kind, then some algorithms may be ruled out.

The interface to IEnumerator\<T\> is very simple.
``` public interface IEnumerator<T> {   bool MoveNext();   T Current { get; }   void Reset(); }```

It's clear that we can't do random access with this type of iterator, and we can't move backwards through the collection either. Since yield allows only trivial iterators we will probably have to use an alternative mechanism to iterate collections. Perhaps we need to expand the capabilities of IEnumerator\<T\>? The iterators will need to be constrained by coding conventions (of which more later on). There is nothing in principle to stop us doing whatever was possible with iterators in C++, in the same way - after all there is no in-built runtime support for iterators in C++, yet it copes well.

Generic Algorithms
------------------

In generic methods you often define your method signatures in terms of iterators. If you defined (in C++) a vector of integers like so:

```vector<int> vint = new vector<int>(); ```

and you defined an algorithm called [Double]{style="font-size:10pt;font-family:Courier New;"} like so:
```void Double<Iterator>(Iterator start, Iterator end) {   for(Iterator i = start; i != end; i++){     i *= 2;   } }```

Then you could double the elements in the collection like so:

```Double(vint.begin(), vint.end());```

This performs an in-place doubling of each element between start and end inclusive. Sadly, [you ]{style="text-decoration:underline;"}[just can't do this]{style="font-size:9pt;font-family:Tahoma;"} in C\#. It's not possible. The C\# compiler doesn't know at compile time whether the elements returned by an Iterator are numerical and can support the '\*=' operator. We cannot define operators on an interface, and therefore we cannot constrain the iterators to those defined on collections that store objects that support the '\*=' operator. Numerical types don't share a common base class that we could use to distinguish them from other structs. Besides, we couldn't define a constraint against a type argument of another generic class. For example, say you defined a List of Integers, and you passed a pair of iterators to Double, Double would not know that they were iterators over a collection containing integers, because all it knows is that it has a type argument called Iterator that could be anything at all.

Lets summarise the list of problems with this simple example for later reference:

1.  Can't define operators on an interface , thus you can't constrain to types that support operators
2.  Can't issue constraints against type arguments of type arguments
3.  No consistent last item
4.  No static type checking

It would be nice to write some code like this:

```if(Iterator.T is Numeric){   for(Iterator i = start; i != end; i++){     i *= 2;   } }```

Or, better still

```void Double(Iterator start, Iterator end) where Iterator.T : Numeric {   // ... }```

But it is not to be - at least in this version. Even if we could define constraints that specified the operators, we would not be able to retroactively attach the interfaces to types in the framework. Oh, and another thing - [IEnumerator\<T\>]{style="font-size:10pt;font-family:Courier New;"} doesn't support Equality comparison, that rules out iteration between ranges. Iterators in STL support the '[*one beyond the end'* ]{style="font-size:9pt;font-family:Tahoma;"}concept that enables a collection to have a definite immutable value for the end of a collection that doesn't get out of date if new elements are added to the end of a collection. Contrast that with the following implementation of [System.CharEnumerator.Current]{style="font-size:10pt;font-family:Courier New;"}.``` ```

```public char Current {   get {     if (this.index == -1) {       throw new InvalidOperationException (Environment.GetResourceString( "InvalidOperation_EnumNotStarted"));     }     if (this.index >= this.str.Length) {       throw new InvalidOperationException (Environment.GetResourceString( "InvalidOperation_EnumEnded"));     }     return this.currentElement;   } }```

As soon as the iterator gets to the end of the collection it will not allow a dereference of collection elements. Instead it begins to throw exceptions. If this is typical of the framework, it doesn't bode well for algorithms like Double above, since you can't dereference one beyond the end of the collection without throwing exceptions.

Without a common, immutable end of collection marker that can be passed to an algorithm, we are going to have problems. Firstly, we will have to provide algorithms for both the whole collection and for a range within that collection. Perhaps that's why the canonical generic algorithm in System.Collections.List is ForEach? Without a guaranteed end of collection iterator value, we can't be sure of iterating the whole of a collection that is being inserted to while it is being iterated.

[Shortcomings of C\# ]{style="font-family:Tahoma;"}
---------------------------------------------------

Using a convention about how collections expose their type parameters, STL allows a thorough introspection into data types used in a collection and its contained elements, without any prior knowledge of the types.  In a Genetic Algorithm, I never need to know how my Genomes are encoded to be able to evolve them. In C\# I can get an iterator such as [IEnumerable\<T\>]{style="font-size:10pt;font-family:Courier New;"}, but if T has further detail inside it, I have no easy way to get at it, because there are no typedefs or their equivalent inside IEnumerable. The code in my example above is completely illegal. You can't do Iterator.T because T is not accessible from Double. All it knows about is Iterator. It could define a constraint to say that its iterators must be [IEnumerator\<T\>]{style="font-size:10pt;font-family:Courier New;"} but even then, it still can't work without explicitly specifying the types iterated over.

Some collection libraries use a pattern of defining T (the element type) on the generic method, and then define their interfaces to accept IList\<T\>or IEnumerator\<T\>. This is partially generic – it allows the iterated elements to be parameterised, but not the collection types or their iterators.

What's so bad about that, you might ask. Well, the type parameters would contain redundant type definitions which would be messy and would make the code brittle. In addition, that approach would only be useful if you knew how many levels you would need to dig into the type definitions. If you wanted to look inside T of IEnumerator\<T\>, you would have to provide extra parameters in the cases where T was itself generic. Obviously, messing with the parameter lists of a generic type or method won't help. So, we need some sort of type export mechanism.

So, how do I find out more about the type parameter of IEnumerable\<T\> without using reflection, or what elegant workarounds and/or conventions could I adopt to make such type access easy? These problems are not specific to the realm of evolutionary programming - I just chose that because it's fun - there is currently [[work]{style="font-size:9pt;font-family:Tahoma;"}](http://blogs.msdn.com/ericgu/archive/2003/11/14/52852.aspx) being done by Anders Hejlsberg and the rest of the C\# design team to find (or bake in) ways to achieve this in future versions of C\#.

### [Exporting Types ]{style="font-family:Tahoma;"}

One feature of C++ that is used liberally in the STL is typedefs. *typedef* in C++ is useful for allowing type parameters to be inspected by algorithms. I'll show a few examples of typedefs at work below. This is a critical difference between the template system of C++ and the generics system of C\#. In C\# there is very little information flow between the generic type argument and the type constraints. C++ uses *static type checking* to check for type errors at compile time. It does not do this by checking type arguments against a lookup table of permissible types as is the case with C\#. Instead it attempts to find bindings for methods, fields and typedefs for each specific *constructed type*. Consider the following example. I've defined a class [A]{style="font-size:10pt;font-family:Courier New;"} with a public method [Foo]{style="font-family:Courier New;"}. I've then defined a template method [Bar]{style="font-size:10pt;font-family:Courier New;"}[
]{style="font-size:13pt;"}that takes a vector of T.``` ```

```class A {public: int Foo(){/* ... */}} // ... template<typename T, typename R> R Bar(vector<T> arg1){return arg1.Foo();} // ... int result = Bar<A, int>(someVector); ```

There is nothing about the definition of [Bar]{style="font-size:10pt;font-family:Courier New;"}[
]{style="font-size:13pt;"}that tells it that it is dealing with objects of type A. A C\#[
]{style="font-size:10pt;color:black;font-family:Arial;"}compiler would produce a compile-time error for code like this. There is no constraint that it should restrict [Bar]{style="font-size:10pt;font-family:Courier New;"} to classes of type A or its descendants. C++ gets around this problem using static type checking. It can see that when we invoke [Bar]{style="font-size:10pt;font-family:Courier New;"}[
]{style="font-size:13pt;"}with a [vector\<A\>]{style="font-size:10pt;font-family:Courier New;"}[
]{style="font-size:13pt;"}we are OK, but with some other type we are not. It will only issue compilation errors in the case where you try to invoke [Bar]{style="font-size:10pt;font-family:Courier New;"}[
]{style="font-size:13pt;"}with a vector of some other type. This static type checking is powerful. It allows generic methods to access typedefs in its type arguments. Imagine you were writing a genetic algorithm, and you wanted to do a random mutation on randomly chosen population members.

```template<typename PopType> PopType::GenomeType MutatePopulation(PopType population){  for(PopType::iterator i = population.begin(); i != population.end(); i++){   PopType::GenomeType gen = StochasticInvoke(Mutate(*i), PopType.MutationProbability);   *i = gen;  }```

In the above example I have accessed type definitions to get iterators, and genome types used to declare local variables. Without this kind of thing we are forced to add internal types on generic parameter lists:

```GenomeType MutatePopulation<PopulationType, PopulationIteratorType, GenomeType>( PopulationType pop){  for(PopulationIteratorType i = pop.begin(); i != pop.end(); i.MoveNext()){   GenomeType gen = StochasticInvoke(Mutate(i.Current), pop.MutationProbability);   *i = gen;  } }```

As explained earlier this is nasty. It means that if I were to find a different way to represent GenomeType, I would have to change every place that uses a genome, rather than just the one place that stores the genomes. With the aid of typedefs I can just modify the declaration of my population collection, and the type will flow out into every generic method that works with populations. I want to be able to define the data type of a variable once and thereafter not have to mention it again, since clients can get it from the parameters I pass around.

#### Type exporting using external methods

The lack of static type checking in C\# means we can't declare variables of types exported inside of type arguments. We can pass them around, though. Using extension methods (that are currently in pre-alpha release in the May CTP of C\# 3.0) we can augment [System.Type]{style="font-size:10pt;font-family:Courier New;"} to provide access, with the aid of reflection.

```namespace System{   public class TypedefAttribute : Attribute { }   public static class TypeExtensions {     public static IDictionary<string, Type> typedefs;     public static Type GetTypedef(this Type source, string typedef) {       if (typedefs == null) {         typedefs = ReflectTypeExports(source);       }       if (typedefs.ContainsKey(typedef))         return typedefs[typedef];       else         throw new ApplicationException("No type export named '" + typedef + "'");     }``````    public static IDictionary<string, Type> ReflectTypeExports(Type source) {       Dictionary<string, Type> result = new Dictionary<string, Type>();       // Get all properties adorned with TypedefAttribute from source       var q = from p in source.GetProperties()               where p.GetCustomAttributes(typeof(TypedefAttribute), rue)                  .Length > 0               select p;       foreach (System.Reflection.PropertyInfo pi in q) {         result[pi.Name] = (Type)pi.GetValue(null, null);       }       return result;     }   } }``````namespace extensions {```

public class A\<T\> {
    \[Typedef\] public static Type TType { get { return typeof(T); } }
  }
  public class B\<T\> {
    \[Typedef\] public static Type TType { get { return typeof(T); } }
  }```  class Program {     static void Main(string[] args) {       Console.WriteLine(typeof(A<B<int>>).GetTypedef("TType").       GetTypedef("TType").ToString());       Console.Read();     }   } }```
This is fine for passing types around, but you can't do much with it other than treat it as a variable. You can't *declare* a variable like so

```typeof(PopulationType).GetTypedef("GenomeType").GetTypedef("AlleleType") allele = GetRandomAllele(iterator.Current);```

You could use the old

```Activator.CreateInstance(typeof(PopulationType).GetTypedef("GenomeType").GetTypedef("AlleleType"));```

trick, but then you've got a System.Object, and what do you cast it to? There's no type safety.

Lets take a look at a good collection of generic algorithms. The PowerCollections library from Wintellect. Here's a typical example from the generic methods class Algorithms:

```public static IEnumerable<T> Rotate<T>(IList<T> source, int amountToRotate) {   if (source == null)     throw new ArgumentNullException("source");   int count = source.Count;   if (count != 0) {     amountToRotate = amountToRotate % count;   if (amountToRotate < 0)     amountToRotate += count;``````  // Do it in two parts.   for (int i = amountToRotate; i < count; ++i)     yield return source[i];   for (int i = 0; i < amountToRotate; ++i)     yield return source[i];   } }```

The method declares type parameters for the collected type, and then fixes the type for the collection. That is pretty much all you can do in C\# without typedefs. What happens if you decide that your algorithm could be applied to any ordered type that can be iterated, rather than just ILists? Well, you could use iterators, but we know from the earlier discussion that currently, IEnumerator\<T\> doesn't use a fixed end point for the end of a collection. We may run into consistency and thread safety issues, because the end of a collection could change continually, so it can't be passed around.

Conclusions
-----------

We've seen that the standard template library is a product of convention and integrated language support. You can get a long way with just iterators. Do those iterators need to be stable in a multithreaded environment? Probably. I attended a talk at TechEd Sydney given by Joel Pobar a few weeks back, where he pointed out that for developers to exploit the coming multi-core machines, they would have to embrace multi-threading. That implies that our generic algorithms will have to be designed to work in a thread safe way. You can sacrifice flexibility in your choice of containers to allow iteration, as has been done in the PowerCollections library. You could try to augment the iterator mechanisms to allow the integrated language support of C\# to dovetail with a better collections library design. This was done in the C5 library, where const iterators and bi-directional iterators have been grafted onto the existing collection iteration mechanism.

For truly generic algorithms (rather than shallow transformative operations such as the PowerCollections' Rotate method given above) we need types to be flexible and informative. They are informative, but only about the type itself. Not about the relationships that the type has with other types. And what relationships the type does have, are not usable at compile time. That's where the typedef mechanism in C++ comes in. In C\#, we are hindered by the richness of the reflection mechanism. Types are runtime things passed around just like other objects. We need them to be as flexible and informative at compile time. Currently they aren't. We may be able to do extraordinary things in future releases of C\#, but currently we will never have the same degree of genericity as we had in C++. However, with a bit of good design and some compromise, we can produce some very flexible algorithms of lasting value.

If I could ask for one thing to be included in future versions of C\# - it would be static type checking, allowing generic type arguments to carry more information than the minimum required to create a concrete type at runtime. I want typedefs.
