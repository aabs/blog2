---
title: Object Orientation? Not as we know it.
date: 2008-09-23
author: Andrew Matthews
category: Semantic Web, SemanticWeb
slug: object-orientation-not-as-we-know-it
status: published
attachments: 2008/09/092308-2046-objectorien1.jpg, 2008/09/092308-2046-objectorien11.jpg
---

![](http://www.usask.ca/education/coursework/skaalid/theory/gestalt/gestaltimages/horses2.jpg){width="274" height="169"}

I thought I'd start with a lyric:

> That one's my mother and
> That one's my father and
> The one in the hat, that's me.

You could be forgiven for wondering what [Ani Difranco](http://www.google.com/musicl?lid=Kw1fcniQjnO&aid=K9lpxkBoREB) has to do with this blog's usual themes, but rest assured, I won't stray too far. My theme today is the limitations of the object oriented paradigm that I alluded to in my post about mapping ontologies. I mentioned in my previous post that RDF Schema and OWL were more expressive than the likes of C\# and C++ in terms of the relationships they could express. This time, I'll take the opportunity to show you what I mean by trying to emulate the English language as used by Ani Difranco.

I vividly remember the light bulb that came on over my head when I first learnt object orientation. There was a period there where I (and most of my cohorts, I should add) wandered around viewing everyday things and interactions through the prism of message passing and attributes.  It was all hopelessly nerdy, but it underlines for me the *rightness* of the object oriented paradigm that so much of what I saw around me fitted into the new way of looking at things.

The glamour with which object orientation bewitched us blinded us to all those things that object orientation was not good at. Clearly, the Functional and Logic Programming paradigms represent computation in ways that surpass the imperative paradigm, but in some ways they are only either complementary or inferior.  Object Orientation not only incorporates imperative programming, but also ***knowledge representation***. The resurgence of functional and logic programming demonstrates that OO does not have all the answers in respect of computation. With the advances of RDF Schema and OWL, object orientation is now clearly lacking in the knowledge representation department.

Considering the genesis of C++ out of C, you see a language that adds (among other things) the notion of inheritance to the User Defined Data Type ([structs](http://en.wikipedia.org/wiki/C_syntax)) that were already present in C.  Inheritance in C++ allows composition of structures to building up new structures ([Closure](http://industrialinference.com/2008/05/29/functional-programming-lessons-from-high-school-arithmetic/)) having all of the properties of the parents, plus all the properties particular to the child. Language designers have kept the time-honoured '[record](http://en.wikipedia.org/wiki/Record_(computer_science))' approach despite the fact that a record really doesn't do justice to how we manipulate classes or sets in our head. And that's where Ani Difranco comes in.

> That one's my mother and
> that one's my father

This is a simple example of identification. Ani is referring to a depiction of people in a photograph. She then states (implicitly) that each of them are real people and that one of them is related to her by the 'isMotherOf' relationship and that the other is related via the 'isFatherOf' relationship. That's the bread and butter of object orientation. Just instantiate a couple of instances of the Person class and store them in the Mother and Father properties of Me.

> The one in the hat, that's me.

This next line is a little more difficult to handle in a language like C\#. What it does is identify an instance by virtue of its properties (wearing a hat). I could retrieve instances based on the value of properties using LINQ:

> [var q = (from entity in collection where entity.hat != null select entity).Single();
> ]{style="font-family:Courier New;"}

But, let's think about it for a moment. In this case it's OK to define an instance like that, since she is referring to a specific instance of type "Person" in the song. But what if she'd been referring to a type of Person? The C\# Type of the collection is defined elsewhere by a class (in the programming sense) specifying the properties that define the class (in the philosophical sense). What if I need to define the class of those entities that wear hats? We're getting into a kind of impedance mismatch between the world of object orientation and the world of philosophy.

Set definitions in mathematics are infinitely more malleable than those of the object oriented world. A 'thing' can exist in multiple classes at the same time. For example, the integer '5' is in the set 'Odd Numbers' as well as the sets 'Prime Numbers' and 'Numbers less than ten'. Its identity is not dependent on the sets or classes to which it belongs. That is how class definitions work in the world of the semantic web, but not in the world of object orientation.

Back in the world of object orientation, I might derive a class from "Person" called "PersonWearingHat", but I'd quickly run into problems since a Person wears hats optionally – that is a person is not defined by the set membership of PersonWearingHat-ness. I could instead provide a property "hat" to be populated with a value or not. If not, then it would not be retrieved by our query above. So far, I've managed to define a C\# collection, but it is not a C\# Type, and therefore cannot be used by the compiler or runtime for type checking and validation. Clearly, we need something either more dynamic or static and implicit but more sophisticated.

From a philosophical or mathematical standpoint, there is little difference between a class and a set. We normally treat them as synonymous. We define each using a language describing what is in the class/set and what is not. That's not so different from how I define the collection of people wearing hats above. It's the richness of *THAT* class definition*
*language which varies between OO and OWL. In OO, you can only define a class as something that can or must have a given set of properties. In OWL you can define a class in the same way, [***or***]{style="text-decoration:underline;"} by saying that the class is those entities with such and such properties and with values for the properties defined in an expression. In fact you can use expressions to define classes using a special idiom that I'll demonstrate shortly.

One requirement of the RDF framework is that it provides an open ended model for describing the things you know about an entity. By open ended, I mean limitless and unconstrained. If you define a C\# class in terms of the properties that it has, then you effectively limit that class to have only those properties. Clearly that won't work for a system that wants to provide a distributed representation of knowledge about entities. But what does it mean to be a member of a class that is not defined in terms of attributes or methods?

Being a class in RDF Schema simply means defining a triple of the form

> [\<instance\> rdf:type \<class URI\> .
> ]{style="font-family:Courier New;"}

Or defining it with predicate [owl:subClassOf]{style="font-family:Courier New;"} with an object that is a class (again we find closure at work). In other words you are either a class because you are of type class or because you are derived from a thing that is of type class. That's a very simple way to represent classhood. You still define properties of a class in much the same way as in object oriented languages.

OWL provides a restriction mechanism for complex type definitions using the contents of properties. Here's an example made using the [N3 format](http://www.w3.org/TeamSubmission/n3/) of RDF.

> [ :V8Car
> rdfs:subClassOf :Car ;
> rdfs:subClassOf
> \[ a owl:Restriction ;
> owl:onProperty :cylinders ;
> owl:hasValue 8
> \] .
> ]{style="font-family:Courier New;"}

I've defined the class V8Car as anything of type Car that also has 8 cylinders. This is impossible in a mainstream record-oriented language. Once the type is assigned it cannot be unassigned. In this example an entity of type V6Car could have its engine replaced with one that had 8 cylinders and would immediately become an instance of the V8Car class while leaving class V6Car.

That's just one example of class specifications that are not available to us in object-oriented languages. Remember *Figure and Ground* by MC Escher? Or Necker cubes? Your mind can flip flop between seeing the image in one way or the other. In OWL, you can define classes in that way too. To paraphrase the lyric at the top: *the one whose head is not bare, that's me.* Here's an example of using a negative class definition.

> [:Elsewhere
> rdfs:subClassOf :Place ;
> rdfs:subClassOf
> \[ owl:ComplementOf
> \[:isLocationOf :Me\] \].
> ]{style="font-family:Courier New;"}

Elsewhere, for me, is anything where I am not. Class membership for everything else may change as I move around. Tell me of any programming language that can do that! There are plenty of other examples that I can bring forth from the OWL and RDF Schema specs, but I imagine you get the point now. Type membership is entirely static in the OO world, and it needn't be. The question is, how could you implement a programming language based on such protean class definitions? Obviously the old C record approach will not do. I'll save that for a future discussion, since it's getting late.
