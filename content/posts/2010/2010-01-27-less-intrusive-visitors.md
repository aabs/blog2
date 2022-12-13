---
title: Less Intrusive Visitors
date: 2010-01-27 19:00
author: Andrew Matthews
category: .NET, programming
slug: less-intrusive-visitors
status: published
---

Forgive the recent silence - I've been in my shed.

Frequently, I need some variation on the Visitor or HierarchicalVisitor patterns
to analyse or transform an object graph. Recent work on a query builder
for an old-skool query API sent my thoughts once again to the Visitor pattern. I
normally hand roll these frameworks based on my experiences with recursive
descent compilers, but this time I thought I'd produce a more GoF-compliant
implementation.

The standard implementation of the visitor looks a lot like the first code example. First you
define some sort of domain model (often following the composite pattern).
This illustration doesn't bother with composite. I'll show one later on, with an
accompanying HierarchicalVisitor implementation.

\[sourcecode language="csharp" light="true" wraplines="true"\]abstract class BaseElement {
void Accept(IVisitor v);
 }
class T1 : BaseElement {
  void Accept(IVisitor v) {
    v.visit(this);
  }
}
class T2 : BaseElement {
  void Accept(IVisitor v) {
    v.visit(this);
  }
}
class T3 : BaseElement {
  void Accept(IVisitor v) {
    v.visit(this);
  }
}\[/sourcecode\]
\[sourcecode language="csharp" light="true" wraplines="true"\]interface IVisitor{
  void Visit (T1 t1);
  void Visit (T2 t2);
  void Visit (T3 t3);
}\[/sourcecode\]

Here's an implementation of the visitor, normally you'd give default
implementations via and abstract base class. I'll show how that's done later.

\[sourcecode language="csharp" light="true" wraplines="true"\]class MyVisitor : IVisitor {
  void Visit (T1 t1) {
    // do something here
  }
  void Visit (T2 t2) {
    // do something here
  }
  void Visit (T3 t3) {
    // do something here
  }
}\[/sourcecode\]

The accept methods are on the domain model entities themselves. What if I have a
composite graph of objects that are not conveniently derived from some abstract
class or interface for my convenience? What if I want to iterate or navigate
the structures in alternate ways. What if I don't want to (or can't) pollute
my domain model with visitation code?

I thought it might be cleaner to factor out the responsibility for the
dispatching into another class - a Dispatcher. I provide the Dispatcher from my
client code and am still able to visit each element in turn. Surprisingly, the
result is slightly cleaner than the standard implementation of the pattern,
sacrificing nothing, but gaining a small increment in applicability.

Let's contrast this canonical implementation with one that uses anemic objects
for the domain model. First we need to define a little composite pattern to
iterate over. This time, I'll give the abstract base class for the entities
and for the visitors and show a composite pattern as well.

\[sourcecode language="csharp" light="true" wraplines="true"\]abstract class AbstractBase {
  public string Name {get;set;}
}
class Composite : AbstractBase {
  public string NonTerminalIdentifier { get; set; }
  public Composite(string nonTerminalIdentifier) {
    Name = "Composite";
    NonTerminalIdentifier = nonTerminalIdentifier;
  }
  public List SubParts = new List();
}
class Primitive1 : AbstractBase {
  public Primitive1() {
    Name = "Primitive1";
  }
}
class Primitive2 : AbstractBase {
  public Primitive2() {
    Name = "Primitive2";
  }
}\[/sourcecode\]

A composite class plus a couple of primitives. Next, Lets look at the visitor
interface.

\[sourcecode language="csharp" light="true" wraplines="true"\]interface IVisitor {
  void Visit(Primitive1 p1);
  void Visit(Primitive2 p2);
  bool StartVisit(Composite c);
  void EndVisit(Composite c);
}\[/sourcecode\]

According to the discussions at the Portland pattern repository, this could be
called the HierarchicalVisitor pattern, but I suspect most applications of
visitor are over hierarchical object graphs, and they mostly end up like this so
I won't dwell on the name too much. True to form, it provides mechanisms to
visit each type of element allowed in our object graph. Next, the Dispatcher that
controls the navigation over the object graph. This is the departure from the
canonical model. A conventional implementation of visitor places this code in
the composite model itself, which seems unnecessary. Accept overloads are
provided for each type of the domain model.

\[sourcecode language="csharp" light="true" wraplines="true"\]class Dispatcher {
  public static void Accept(Primitive1 p1, TV visitor)
    where TV : IVisitor {
    visitor.Visit(p1);
  }
  public static void Accept(Primitive2 p2, TV visitor)
    where TV : IVisitor {
    visitor.Visit(p2);
  }
  public static void Accept(Composite c, TV visitor)
    where TV : IVisitor {
    if (visitor.StartVisit(c)) {
      foreach (var subpart in c.SubParts) {
        if (subpart is Primitive1) {
          Accept(subpart as Primitive1, visitor);
        }
        else if (subpart is Primitive2) {
          Accept(subpart as Primitive2, visitor);
        }
        else if (subpart is Composite) {
          Accept(subpart as Composite, visitor);
      }
    }
    visitor.EndVisit(c);
    }
  }
}\[/sourcecode\]

The dispatcher's first parameter is the object graph element
itself. This provides the context that was implicit with the conventional
implementation. This is a trade-off. On the one hand you cannot access any
private object information inside the dispatch code. On the other hand you can
have multiple different dispatchers for different tasks. Another drawback with
an 'external' dispatcher is the need for old-fashioned dispatcher switch
statements in the Composite acceptor. The Composite stores its sub-parts as
references to the AbstractBase class, so it needs to decide manually what the
Accept method is that must handle the sub-part in question.

The implementation for a visitor is much the same as in a normal implementation.
A default implementation of the visit functions is given that
does nothing. To implement a HierarchicalVisitor, the
default StartVisit must return true to allow iteration of the
subparts of a Composite to proceed.

\[sourcecode language="csharp" light="true" wraplines="true"\]class BaseVisitor : IVisitor {
  public virtual void Visit(Primitive1 p1) { }
  public virtual void Visit(Primitive2 p2) { }
  public virtual bool StartVisit(Composite c) {
    return true;
  }
  public virtual void EndVisit(Composite c) { }
}\[/sourcecode\]

Here's a Visitor that simply records the name of who gets visited.

\[sourcecode language="csharp" light="true" wraplines="true"\]class Visitor : BaseVisitor {
  public override void Visit(Primitive1 p1) {
    Debug.WriteLine("p1");
  }
  public override void Visit(Primitive2 p2) {
    Debug.WriteLine("p2");
  }
  public override bool StartVisit(Composite c) {
    Debug.WriteLine("-&gt;c");
    return true;
  }
  public override void EndVisit(Composite c) {
    Debug.WriteLine("\<-c");
  }
}\[/sourcecode\]

Given an object graph of type Composite, it is simple to use this little framework.

\[sourcecode language="csharp" light="true" wraplines="true"\]Dispatcher.Accept(objGraph, new Visitor1());\[/sourcecode\]

I like this way of working with visitors more than the conventional
implementation - it makes it possible to provide a good visitor implementation on
thrid party frameworks (yes, I'm thinking of LINQ expression trees). It is no
more expensive to extend with new visitors, and it has the virtue that you can
navigate an object graph in any fashion you like.
