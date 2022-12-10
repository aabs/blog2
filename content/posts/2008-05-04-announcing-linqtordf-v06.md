---
title: Announcing LinqToRdf v0.6
date: 2008-05-04 22:54
author: aabs
category: .NET, programming, Semantic Web
tags: .NET, C#, LinqToRdf
slug: announcing-linqtordf-v06
status: published
attachments: 2008/05/clip-image0019-thumb.png, 2008/05/clip-image0017.png, 2008/05/clip-image0017-thumb.png, 2008/05/clip-image0015.png, 2008/05/clip-image0015-thumb.png, 2008/05/clip-image0019.png, 2008/05/image.png, 2008/05/image-thumb.png
---

I've just uploaded LinqToRdf v0.6 with improved designer support for Visual Studio .NET 2008.

The release includes the following high-points:

-   LinqToRdf Designer and VS.NET 2008 extension completely rewritten
-   LinqToRdf Installer now includes the installer of LinqToRdf Designer (at no extra cost)
-   Project and Item templates now installed as part of LinqToRdf Designer
-   Generated object and data properties now get their own EntitySet or EntityRef.
-   Generates LINQ to SQL-style DataContext objects to hide query creation. Much Cleaner.

The user experience for LinqToRdf should be greatly improved in this release.  I focussed on getting project and item templates set up that would allow you to either create a dedicated LinqToRdf project that would have all the assembly references set up for you, or to create a new LinqToRdf designer file, that would generate C\# code based on the new Attribute model introduced a few versions back.

The VS.NET extensions are not installed by default, instead they are created in the LinqToRdf directory. If you do install them, then you will find that visual studio will now have a LinqToRdf will have a new project type.

[![clip\_image001\[5\]]({static}2008/05/clip-image0015-thumb.png){width="614" height="274"}]({static}2008/05/clip-image0015.png)

You also have the LinqToRdf designer file type, which has been around for a version or two:

[![image]({static}2008/05/image-thumb.png){width="540" height="299"}]({static}2008/05/image.png)

The Solution view is like this:

[![clip\_image001\[7\]]({static}2008/05/clip-image0017-thumb.png){width="236" height="180"}]({static}2008/05/clip-image0017.png)

The designer view is the same as ever:

[![clip\_image001\[9\]]({static}2008/05/clip-image0019-thumb.png){width="576" height="457"}]({static}2008/05/clip-image0019.png)

Things are coming along, and the download stats for version 0.4 were actually quite healthy (at least i think they were) so I expect this version to be the most popular yet.

Expect to see the lazy-loading relationship representation process fully documented in the coming days.

Enjoy.
