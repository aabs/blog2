---
title: Some new themes.
date: 2006-03-30 04:55
author: Andrew Matthews
tags: misc
slug: some-new-themes
status: published
---

No, not display themes in my blog. I'm going to start some new themes on design and development issues. There's a few things that I felt I ought to give a systematic treatment to.  I've had a few conversations lately that brought my mind back to the issues of code generation and its related patterns. I've also been playing with generic algorithms in C\# 2.0 for type introspection in my DBC system. It seemed natural for me to explore the idea of using generic algorithms at the heart of code generation frameworks since a generic algorithm would allow me to reuse my code generator regardless of the metadata format or the output stream.

Consider this:

    public class CodeGenerator<DataSource, TemplateSource, CodeGenerationPolicy>{
    // ...
    }


    using CodeGenerator<DatabaseModel,
        DatabaseSqlCreationTemplate,
        SingleFilePerTopLevelElementPolicy> SqlCreateTpl;

    SqlCreateTpl tpl = new SqlCreateTpl(GetModel(),
    Factory.GetTemplate(typeof(DatabaseSqlCreationTemplate)),
        Factory.GetCodeGenPolicy());

    tpl.Run();

Neat huh? I'd prefer to write code like that than write code that must explicitly acknowledge where the data comes from, what it's format is, and how it is to be disposed of in the code generator. Up until now, I have achieved design-reuse, but never code-reuse. From looking at other code generators, the problem abounds. Most systems I have worked with provide the code expansion part, and the template language part, but tend to stick to a single metadata source when it comes to generating code or other artifacts.  A case in point are the persistence-tier code generators that purport to be general purpose code generators but that only take data from a specific database API. These don't provide the degree of genericity required to share code between wildly different systems such as a DBC proxy class generator and an Object to Relational mapping system. In the first example our data comes from reflecting the metadata of a .NET assembly in the later it comes from reflecting the schema of a relational database (or both). We need a code generator that will work regardless of where it's data comes from, and how and where its output gets generated. We need to separate the algorithm of the code generation process from the structure of the metadata source, and they both need to be isolated from what happens to the stuff that the template system outputs.

The solution of these problems was the grail of the beautiful C++ [Standard Template Library](http://en.wikipedia.org/wiki/Standard_Template_Library) of Alex Stepanov. It is still a matter of debate whether something like the STL is possible in C\#, but early [work](http://www.itu.dk/research/c5/)  is yielding possibilities that hold out hope. I propose to give code generation the STL treatment. In the process I will explore many related ideas that have been bugging me about my ORM and DBC systems. Chief amongst those is the matter of policy vs configuration and how you store them.

There's my manifesto for the weeks/months ahead! I have some holiday coming up, so I may even deliver on the promise. ;-)
