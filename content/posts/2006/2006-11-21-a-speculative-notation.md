---
title: A Speculative Notation
date: 2006-11-21 17:58
author: Andrew Matthews
ignored-tags: philosophy
slug: a-speculative-notation
status: published
---

About 6 years ago I read a book by Edward de Bono, called modestly the de Bono Code Book. His idea was to devise a representation for thoughts and statements that went beyond the simple propositions from predicate logic. Initially, I was intrigued by the idea that I could learn to represent ideas in a way that was both terse, unambiguous and that enhanced my abilities to reason on paper. I quickly became disillusioned by the notation because it was both arbitrary and incomprehensible; there was no obvious way (as far as I could make out) for representing an arbitrary thought. It was more geared to making statements about internal emotional states, rather than giving a way to represent any idea. I decided that it may be a futile effort to even try, but I had a go at producing one for myself.

De Bono's notation used a string of digits each enhancing the meaning of preceding digits. Codes would be represented as a string of digits read from left to right that started with the general universe of discourse and elaborated upon the speaker's feelings in that context. I felt it was impossible to create subtle distinctions in this notation, and even harder to see the similarities in related statements. I also felt that it ought to be possible to treat the notation as a kind of programming language of thought. I came up with a little notation that grew into something not unlike an ontological markup language.

The notation has an internal structure that is invariant: **\[ *subject* \| *verb* I *object* \]**. The structure of all utterances follows this format except in the case where the subject is yourself (and you are writing [***to***]{style="text-decoration:underline;"} yourself) where it can be omitted if necessary. I augmented that notation by allowing the adornment of the three components of a statement with '*glyphs*' that modified the meaning of the nouns and verbs of the statement. Glyphs could indicate certainty of belief or probability like in a modal logic, as well as placing the elements in space and time. I quickly needed to add set definitions and existential quantifiers, since many of language utterances end up defining sets and their properties. Don't believe me? Look at the previous sentence: "*most of language utterances end up defining sets and their properties*". I'm defining a property on the set of all utterances in a natural language! It's not surprising that set theory was paramount among the early attempts at creating universal languages.

For the sake of consistency in my set definitions, I just borrowed notations from propositional and predicate logic since they were terse, unambiguous and widely adopted. I was influenced by the formal methods courses on Z at university where we nerdily tried to find ways to tell jokes in Z. I even managed to formally specify the song *My Old Man's a Dustman* by Lonny Donnegan. Like I said, it was a fun but nerdy pastime. We found ourselves doing that when we studied object oriented languages too. So very soon I introduced set membership, and whole-part relationships using the object oriented 'dot' notation. The end result was a mélange of mathematics, object oriented notation, set theory and regular expressions. It had extensions to allow it to be easily used in the arena of human thought where there are no certainties and thought has declarative and imperative modes.

What follows is a little explanation of the system that I posted on [Everything2](http://www.everything2.com/) back in 2000. It describes the notation and how it would be used. It also alludes to a non-formal bootstrapped specification of the notation in a subset of the notation. I still haven't come up with a good name for it, so at the time I dubbed it '***N***' for Notation for want of a better name. In subsequent years there has been a lot of activity at W3C on the topic of ontologies. RDF arose as a popular representation of ontologies that could be expressed in a machine processable form. RDF also follows a 3-tuple (triple) format with relationships defined in a similar way to this notation. Where the two deviate is that my notation is designed to be human produced and consumed. It seeks to pile as much meaning in a proposition as possible. It doesn't use multiple statements to elaborate the original relationship in space time etc. you could unravel statements in this notation into RDF, and I've often thought about creating parsers to do just that. I've even produced formal grammars for the language.

I'll post a full example, plus a bootstrapped spec in my next post. Meanwhile, this will give you a little taste of what it's like. And if you can think of a good name for it, please leave a comment.

A notational system that combines features from linguistics, logic and object oriented programming to allow complex expressions to be uttered about everyday things.

Use is made of structures and glyphs that allow the gross structure of a sentence to remain constant while the specific context and meaning of the utterance is modified by the glyphs. Such constancy of form allows the meaning to be easily captured, without the complexity required by the syntactic transformations of languages like English.

Uses:

-   Speculative thought processes
-   Semi/Formal program analysis (Formal Methods)
-   Cleanroom Software Engineering Intended Functions
-   Dense notetaking
-   Semantic analysis of Natural Language Utterances
-   bootstrapping itself
-   ...

### Glyphs and Structures

The structures of N allow you to specify the causal structure of a thought, and then adorn it's components with glyphs that specify more precisely the relationship between the bare content of the causal sequence described in the structure and the utterer of the sentence.

Formats exist for writing the notation a-la mathematics using TeX (still v-crude) and for using plain ASCII to communicate in a format such as this:

[\[N.structure\_\* \| describe \| causal sequence\_\*\]
]{style="font-family:Courier New;font-size:8pt;"}

[\[N.glyph\_\* \| adorn \| N.structure.entity\_\*\]
]{style="font-family:Courier New;font-size:8pt;"}

[\[N.glyph\_\* \| modify\_? \| A.N.semantic\]
]{style="font-family:Courier New;font-size:8pt;"}

### Justification

Structures are employed to encode the causal structures that underlie utterances used in non-poetic (i.e. factual or working) language. Although linguistics distinguishes four broad types of utterance (phatic communion, informative, imperative, interrogative), according to the purposes to which they are put, it is possible to ignore phatic communion since it acts more like a protocol hand-shaking system rather than as a means of communicating. N exploits the regularity in the format of utterances in natural languages. That regularity is the grammar(s) of the language. I think that the grammar of the language reflects a mental model of causation in the brain of the speaker. Since all descriptive utterances in a natural language describe either static or dynamic *situations*. A dynamic state of affairs is the transition from one state of a system to another. A static description will describe the structure and properties of a system at a specific point in time. "Now" is the default time for most utterances. In general usage a static description would just be called a description. A dynamic description would be referred to as a description of an event.

As in English, N is able to render both static and dynamic descriptions, and within the same sentence. The structures used to describe events have three parts. They reflect the mental model that we use to recognize events. The structure contains a ***subject***, ***verb*** and ***object***. Natural languages vary in the order within a sentence that these entities come. Many languages including English included allow the ordering of these entities to vary. Or, to put it another way: English, the order of entities to vary will allow. N enforces a single order for entities in each utterance. The result is that it requires less work to interpret an utterance in N.

English, and all other natural languages, employ syntactic and morphemic transformations to the structure of a sentence, in order to specify details about the time, place, plurality, performer, and subject of an event. In so doing the gross structure of the sentence can be modified radically. For example, consider the sentence "*I will drive the car.*" and the sentence "*I drove the car*". The transformation means that, to a casual glance, the sentences are different. On closer inspection, one can plainly see that they are the same sentence, modified to place the event in the future or past respectively. Similarly, "*I am driving the car*" incorporates new words and structures to indicate that the event is occurring in the present. The main transformations are to the verb "*drive*". The verb is altered to indicate the tense of its operation. To adapt the tense to English sentence structure other syntactic changes must be incorporated. Both N and natural languages specify the role of the performer and subject of an event, but N does so explicitly, whereas natural languages often only give clues.

### Dual Purpose Language

Frequently glyphs are used to clarify the relationship between the entities referred to in the bare content of the structure and the speaker of the utterance at the time and place that they uttered it. Language frequently serves two purposes then. The first is to describe an event, and the second is to describe the speaker's relationship to it. That relationship can be spatio-temporal, moral, psychological etc.

### Constant Structure Aids Gestalt Understanding

N is, in the formal presentation below, referred to as "N". N uses glyphs (or graphical symbols) to adorn the basic present-tense form of a verb to indicate the tense modification. By doing so it does not require structural modifications to indicate the change in meaning of the sentence. For example the three driving examples given above would be represented in N as:

[\[I \| drive\_p \| car\] == "I drove the car."
]{style="font-family:Courier New;font-size:8pt;"}

[\[I \| drive\_n \| car\] == "I am driving the car."
]{style="font-family:Courier New;font-size:8pt;"}

[\[I \| drive\_f \| car\] == "I will drive the car."
]{style="font-family:Courier New;font-size:8pt;"}

### Speculativeness Aids Critical Thought

N has the advantage that with the use of glyphs one is able to progressively adorn the sentence which more meaning without changing the basic structure at all. N does not allow the writer to adorn a structure element with contradictory glyphs. In some cases one is able to give a visual representation to an English sentence structure that is not representable without additional glyphs of its own! Consider the following example.

[\[We \| produce\_f \| Documentation\] == "We will produce the documentation."
]{style="font-family:Courier New;font-size:8pt;"}

might be adorned with the not sure (non-normative) glyph, which modifies the sentence to indicate that the item adorned, is unsure in our minds:

[\[We\_? \| produce\_f \| Documentation\] == "Will 'we produce the documentation."
]{style="font-family:Courier New;font-size:8pt;"}

[\[We \| \\future{produce\_?} \| Documentation\] == "Will we 'produce the documentation."
]{style="font-family:Courier New;font-size:8pt;"}

[\[We \| produce\_f \| Documentation\_?\] == "Will we produce the 'documentation."
]{style="font-family:Courier New;font-size:8pt;"}

Under normal circumstances (N aside) one seldom inserts a linguist's prime accent (') glyph into a sentence to stress a specific word. A prime accent requires active interpretation since its meaning can often be implicit and vague. There is no specific meaning to the prime accent either, so adornment with a prime will not enable the reader to comprehend what the prime signifies at a glance. So, as an alternative one has to adorn the whole sentence with an explanation:

[\[We\_? \| produce\_f \| Documentation\] == "Is it us that will produce the documentation?"
]{style="font-family:Courier New;font-size:8pt;"}

[\[We \| produce\_f? \| Documentation\] == "Will we produce the documentation, or not produce it?"
]{style="font-family:Courier New;font-size:8pt;"}

[\[We \| produce\_f \| Documentation\_?\] == "Will we produce the documentation, or something else?"
]{style="font-family:Courier New;font-size:8pt;"}

Clearly, the sentence has had to be expanded, modified, and adorned with the '?' glyph anyway! Therefore it is safe to conclude that using glyphs is potentially much more powerful in what it can represent in a given space. It has the potential to allow one to represent something that might otherwise have been left ambiguous, which is a critical failure in all formal documents as well as other forms of communication. N may prove to be useful when using for example SMS messages where space is at such a premium that one already compresses speech beyond intelligible limits ;\^}

An additional benefit of this adornment of static structures is that one is quickly able to view the "hidden" assumptions in a sentence. As in the example above, one can look at the basic units of meaning and their adornments and decide quickly whether one is completely sure that they should be there, and what part they play in the statement or instruction represented. Additional adornments allow the use of normative statements like "should we produce the documentation". In this situation, as well, one can see the need to pull the sentence apart to signify which thing is open to choice.

For these reasons, I was tempted to call N a "speculative notation" since it allows its user to quickly root out the nature of their own mis-understandings, and address them with some sort of thought process. If the user is of a logical bent then they could quite easily use N within a formal proof framework. It has the benefit, though, that it is able to cleanly talk about complex human issues as well.

### More Flexible Determiners Support Richer Thought Streams

When dealing with issues of non-trivial complexity, it is seldom possible to elucidate a train of thought without referring to more than one premise or sub-conclusion. The English language allows for just one level of "transferred subject". By transferred subject I take to mean one that was previously the subject or object of a sentence. The transferred subject has to have been the subject or object of the immediately previous sentence. For example, consider the following sentences.

"N allows any number of determiners, over any scope. It also allows them to be modified in the same way as variables."

The first sentence is easy:

[\[N \| allow \| determiner\_\* == d\]
]{style="font-family:Courier New;font-size:8pt;"}

The second might be rendered with a structure such as the following:

[\[it \| modify \| them\]=\>\[it.determiners =\~ variables\]
]{style="font-family:Courier New;font-size:8pt;"}

Obviously, the solution to disambiguate the English determiner 'it' is to substitute N for 'it' and d for determiner/many.

[\[N \| modify \| determiner\]=\>\[N.determiners =\~ variables\]
]{style="font-family:Courier New;font-size:8pt;"}

This system works in exactly the same way as the determiners of English (the, that, it, them, etc). But consider what level of expansion would be required for the following group of statements

[\[consumer == C \| receive\_n \| data\]\@local\_host
]{style="font-family:Courier New;font-size:8pt;"}

[\[producer == P \| transmit\_p \| data\]\@remote\_host
]{style="font-family:Courier New;font-size:8pt;"}

[\[{P & C}.connection = "peer to peer connection"\] == PPP
]{style="font-family:Courier New;font-size:8pt;"}

[\[{P & C & PPP} \| provide\_f \| OSI.layer one\]
]{style="font-family:Courier New;font-size:8pt;"}

These propositions (whether accurate or not ;) form the structure of a set of statements about the basic elements of a TCP/IP connection. The final statement refers to the set of producer, consumer and peer to peer connection as the subjects of its statement. The obvious translation would be something like "they provide an OSI layer". But, the previous statement is likely to have used "they" to refer to the set of P and C. So to use they again, when a new entity has been defined would confuse the situation, therefore the speaker is unlikely to use it. They will probably have to refer to all of the entities in the set explicitly by enumerating them. The articles them, and that refer to the objects of previous sentences. The articles he, she, they and it refer to the subject of previous sentences.

It can be seen that such variable-like determiners allows the simplification of arguments, as well as greater brevity and specificity when referring to a previous entity. In addition the determiners allow something like

[\[bob \| drive\_p == D \| Car\]
]{style="font-family:Courier New;font-size:8pt;"}

Which we can then augment with a following statement

[\[D == \[drive = {unsafe & reckless & too fast}\]\]
]{style="font-family:Courier New;font-size:8pt;"}

English does not allow the use of determiners to refer to verbs within previous sentences, without explicitly referring to the verbs as an object, which would confuse the intent of the sentence altogether.
