---
title: LinqToRdf now works on the Visual Studio 2008 Beta 2
date: 2007-08-25 08:54
author: aabs
ignored-tags: C#, LINQ
slug: linqtordf-now-works-on-the-visual-studio-2008-beta-2
status: published
---

I should have brought the code up to date weeks back - but other things got in the way. Still - all the unit tests are in the green.  And the code has been minimally converted over to the new .NET 3.5 framework. I say 'minimally' because with the introduction of beta 2 there is now an interface for IQueryProvider that seems to be a dispenser for objects that support IQueryable. I suspect that with IQueryProvider, there is now a canonical architecture that is recommended by the LINQ team. Probably that will mean moving more responsibility into the RDF\<T\> class away from the QuerySupertype.  Time (and more documentation from MS) will tell.

There are several new expression types that are not yet supported (such as the coalescing operator on nullable types) - it remains to be seen whether they are supportable in SPARQL at all. Further research required. The solution doesn't currently support WIX - I'm not sure whether WIX 3 will work with 2008 yet. Again, more research required.  What that means is that there will not be any MSI releases produced till WIX supports the latest drop of VS.NET.

Enjoy - and don't forget to give us plenty of feedback on your experiences

To got to the google code project click [here](http://code.google.com/p/linqtordf/).
