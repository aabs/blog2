---
title: Converting Jena to .NET
date: 2007-03-23 23:51
author: Andrew Matthews
tags: artificial intelligence, cool, programming
slug: converting-jena-to-net
status: published
---

I spent most of my evening converting [Jena](http://jena.sf.net) to .NET.
Needless to say it was only at the end of the evening that I discovered that
Andy Seabourne (from my old home town of Bristol) had already worked out how to
use [IKVM](http://www.ikvm.net) to
[convert](http://seaborne.blogspot.com/2006/02/progress-with-jenanet.html) the
jar files into assemblies. I'm not bothered though; I produced make files
(rather than shell scripts) that work better on cygwin. The best thing I got
from Andy was his "*don't worry be happy*" advice that IKVM spuriously complains
about unfound classes - you don't need to worry about it. Once I read that, I
realised that I had successfully converted Jena about 4 hours earlier, and all
my fiddling about trying to get the right pattern of dependencies was completely
unnecessary - IKVM just works! (and rocks)

Had I realised just how easy it was to convert bytecode to IL, I might have gone
trawling the apache [jakarta](http://jakarta.apache.org/) project more often
over the last few years. (sigh) Never mind - I now have the tools for working on
semantic web applications in .NET. Yayyyy!!!! I don't have to learn Python
either. I'm not sure whether I'm sad about that.

I don't have a place handy to put the assemblies, and wordpress won't allow me
to upload them, so I'll do the next best thing and give you the make file. It
assumes that you are using cygwin or something similar. If you aren't just use
the conventional windows path structure for ikvmdir. It also is based on Jena
version 2.5.2.

```
ikvmdir = /mnt/c/etc/ikvm
cc = $(ikvmdir)/ikvmc.exe
options = -target:library
libs = antlr-2.7.5.jar xml-apis.jar wstx-asl-3.0.0.jar commons-logging-1.1.jar xercesImpl.jar json.jar concurrent.jar junit.jar lucene-core-2.0.0.jar

jars = jena.jar jenatest.jar iri.jar arq.jar arq-extra.jar

all: jena.dll sparql.exe

jena.dll : jena-libs.dll
  \$(cc) \$(jars) \$(options) -reference:jena-libs.dll -out:jena.dll

jena-libs.dll:
  \$(cc) \$(libs) \$(options) -out:jena-libs.dll

sparql.exe:
  \$(cc) \$(libs) \$(jars) -target:exe -main:arq.sparql -out:sparql.exe

clean:
  rm -rf \*.dll

rebuild: clean all
```