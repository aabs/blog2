---
title: The Great Domain Model Debate – Solved!
date: 2007-01-23 10:24
author: Andrew Matthews
tags: Computer Science, programming
slug: the-great-domain-model-debate-%e2%80%93-solved
status: published
---

In almost every version 1.0 system I design, I end up endlessly rehearsing the pros and cons of different implementations of the domain model (or lack of it). It's getting so tedious that I recently decided to answer the question to my own satisfaction. I produced a spreadsheet with as many design factors that I could think of and the different models that I have worked with or considered over the years. I attached a weight to each design factor and then I assigned a score to each model for each design issue based on how well I thought it performed. I then summed the weighted scores for each model to produce a score for the whole model. I was glad to see that the Anemic Domain Model won, and was not surprised to see that performance, intelligibility and strong typing won out over cross-platform support and publishability.

I included a few models that I wouldn't even dream of using, such as typed and untyped associative containers and raw XmlDocuments for the sake of not giving in (too much) to my own bias. As a matter of fact, typed associative containers (i.e. typed wrappers around HashTables) scored better than plain old DataSets or Raw XmlDocuments. These last two I have seen actively promoted by teams of Microsoft architects who ought to know better. Also unsurprisingly, the worst score came from the untyped associative container (i.e. HashTable or TreeSet or whatever). Nevertheless, this model is employed by a disproportionate number of lazy designers who can't be bothered to design a decent object model. This is a particularly popular solution for configuration systems. It has even been enshrined as the solution of choice in the .NET framework! I guess I should take this chance to reiterate my call for designers and developers to avoid this model at all costs – *it has absolutely no redeeming features!!!!*

I also included what I have called ***Transactional DTOs*** which design was mentioned to me as a serious proposal by [Mitch Denny](http://notgartner.wordpress.com). I have never used this approach, so I may not have done it justice. Even so it scored highly, coming in only behind typed data sets solely because I couldn't find a way to base a system solely on them. As a result they score lowly on searchability under current and future APIs. If they were paired with an Anemic Domain Model then the system might be very elegant. I hope that readers can write in to report on good examples of this design in use. How about it Mitch? Have you written about this approach in any depth? I have never tried Naked Objects before either, and my understanding was based upon articles that I read a few years ago. Things may have moved on quite a bit. Check out this [article](http://www.theserverside.net/tt/articles/showarticle.tss?id=CaseStudyNakedObjects) for more.

Each cell represents my assessment (from 0 to 1) of the strength of the given implementation technique for each design factor. As I said before, some of these are based on off-the-cuff judgements without as much exposure as tried-and-true idioms. They are to a certain degree subjective, but I think I've been fair. The weights I expect to vary from project to project, but experience tells me you should flout them at your peril! The scores in Figure 2 represent how well each idiom scored for each design factor, and the overall scores at the bottom represent the overall quality of the model.

![](http://farm1.static.flickr.com/182/365516745_a6aeb5f8b4_o_d.png)

**Figure 1. Weights on each design factor, and strength of each model type for that factor.
**

![](http://farm1.static.flickr.com/130/365516708_a2ddb57ec8_o_d.png)

**Figure 2. Scores of each idiom, based on the sum of the weighted scores.
**

As you can see, the Anemic Domain Model scored best because of its performance, strong typing, good support for relationships, encapsulation, and simplicity. That's despite the fact that it underperforms on cross platform support, publishability and transactions. If you have specific non-functional requirements, then you might need to adjust the weights on Figure 1 to reassess the model you use. The chart doesn't take into account other design considerations that might boost the score of certain models. Those include IDE support, non-standard API support, developer familiarity and published reference applications. It also doesn't try to assess the cost of changing a model on legacy code, which is always likely to be prohibitive. The fact that it's prohibitive means that you have to get it right first time. It also seems to imply that someone in Microsoft also did the same thing and finally realized that some of their sales pitches were not made in the best interests of their clients! It also explains why they have started making the transition to ORM technologies and Language Integrated Queries (LINQ). The benefits are quite clear when you tabulate them.

Lastly, I wonder whether there are quantitative assessments that can be applied to other semi-religious debates in software engineering. Can you think of any? I'm not going to consider linguistic debates - I'm thinking more design issues such as deciding between different display/navigation patterns or deciding whether to run stored procedures, dynamic queries, CLR stored procedures or whathaveyou. What do you agonize over most? Perhaps there is a systematic way for you to choose in future? Why don't you choose some idiom that you have had a lot of experience with, and give it the same treatment? I'll create a link from this page to yours. Perhaps if enough people produced models like this, then we could create a ready-reckoner for choosing designs.

[![kick it on DotNetKicks.com](http://www.dotnetkicks.com/Services/Images/KickItImageGenerator.ashx?url=http://aabs.wordpress.com/2007/01/23/the-great-domain-model-debate-%e2%80%93-solved/)](http://www.dotnetkicks.com/kick/?url=http://aabs.wordpress.com/2007/01/23/the-great-domain-model-debate-%e2%80%93-solved/)
