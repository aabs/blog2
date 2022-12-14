---
title: Object Modeling is Vocabulary Design
date: 2007-07-17
author: Andrew Matthews
ignored-tags: Computer Science, programming, science
slug: object-modeling-is-vocabulary-design
status: published
---

Andrew Cantos raised some interesting philosophical points in reply to my partially tongue in cheek post [The Great Domain Model Debate - Solved](http://industrialinference.com/2007/01/23/the-great-domain-model-debate-%e2%80%93-solved/#comment-10295) the other day. As ever, my short reply turned into a blog post and this is it. Andrew's point was that there is a metaphorical link between objects in a domain model and elementary particles in some physical system. The ability of these elements to take part in the wider system is often a function of their sheer simplicity rather than being loaded with complex properties. He use the example of Oxygen, as an example of something that can take part in many reactions, but which does not define or characterize those reactions. I extended the metaphor to observe that the same holds true when comparing Anemic Domain Models with their Rich brethren.

I like his metaphor. The metaphor I tend use when I think about this issue is related to human languages. Words are poor carriers of meaning on their own, in the same sense that rich objects are poor carriers of business functionality. A word's specific value comes within the dynamic context of a sentence. I.e it's exact meaning and value can only be resolved when composed together in a richer context.

Likewise, the same happens in an OO system - the analogue of the 'sentence' here is the thread of execution, or the transaction script or whathaveyou. they give meaning to the data carried by the anemic object. Without that context the object is worthless. What a RDM seeks to do is carry with the object the full set of possible contexts. It also seeks to restrict that set of contexts to a manageable set.

I can sympathize with that aim - ADM's do little to guarantee that they get used right. RDMs do. However, I think that as with a science, an enterprise system needs to have a commonly agreed shared vocabulary. With that, a greater richness of communication becomes possible. If however, you were restricted in the ways you could use these words, you may have greater precision, but communication would become a chore, and you probably wouldn't bother.

You can extend this whole 'enterprise vocabulary' metaphor even further. If you look at a typical, poorly coded or governed system, you will often see a situation where there are a multitude of little DTOs all of which contain roughly the same data, but just those fields that are needed to service a given page or screen. This situation is analogous to the situation in an immature science where there are many words freighted with slightly different meanings. Confusion results when a speaker intends different things from the listener. So too in software, where the lack of a commonly agreed object model serves to add confusion to the development process, and to increase he likelihood of errors creeping into a system.

What does this imply? It seems to me that the right approach (assuming the metaphor holds true) is that there ought to be a  well defined, definitive and widely shared object model within an organization. All system should use it, and the organization should mint new classes with great care and forethought. This of course ties in with the efforts of various groups in the Semantic Web area, who are attempting to do just that in domains a widely flung as life sciences and disaster relief. The fact that the efforts are inter-organizational means that there will be less tolerance for poorly advised 'pragmatism'.

Which can only be a good thing in the long run. Right?
