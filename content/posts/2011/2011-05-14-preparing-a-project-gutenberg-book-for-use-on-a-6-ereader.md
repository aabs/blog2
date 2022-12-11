---
title: Preparing a Project Gutenberg ebook for use on a 6" ereader
date: 2011-05-14 16:49
author: aabs
category: SemanticWeb
ignored-tags: bebook, gutenberg, gutenmark, LaTeX
slug: preparing-a-project-gutenberg-book-for-use-on-a-6-ereader
status: published
attachments: 2011/05/photo_71194a6e-bfd5-cb24-6596-08771504c330.jpg
---

For a while I've been trying to find a nice way to convert project Gutenberg books to look pleasant on a [BeBook](http://www.mybebook.com) One. I've finally hit on the perfect combination of tools, that produces documents ideally suited to 6" eInk ebook readers like my BeBook. The tool chain involves using GutenMark to convert the file into LaTeX and then TeXworks to modify the geometry and typography of the LaTeX file to suit the dimensions of the document to suit the small screen of the BeBook, then MiKTeX to convert the resultant LaTeX files into PDF (using pdfLaTeX).  Go to [GutenMark (plus GUItenMark](http://aabs.wordpress.com/wp-admin/www.sandroid.org/GutenMark/)) for windows, [MikTeX](http://miktex.org) which includes the powerful TeX editor [TeXworks](http://code.google.com/p/texworks), install them, and ensure they are on the path.

Here's an example of the usual LaTeX output gtom GUItenMark. Note that this is configured for double-sided printed output.

\[sourcecode language="text" toolbar="true"\]
\\documentclass{book}
\\usepackage{newcent}
\\usepackage{geometry}
\\geometry{verbose,paperwidth=5.5in,paperheight=8.5in, tmargin=0.75in,bmargin=0.75in, lmargin=1in,rmargin=1in}
\\begin{document}
\\sloppy
\\evensidemargin = -0.25in
\\oddsidemargin = 0.25in
\[/sourcecode\]

We don't need the margins to be so large, and we don't need a difference in the odd and even side margins, since all pages on an ereader need to look the same. Modify the geometry of the page to the following:

\[sourcecode language="text"\]
\\geometry{verbose,paperwidth=3.5in,paperheight=4.72in, tmargin=0.5in,bmargin=0in, lmargin=0.2in,rmargin=0.2in}
\[/sourcecode\]

`This has the added benefit of slightly increasing the perceived size of the text when displayed on the screen. Comment out the odd and even side margins like so:`

\[sourcecode language="text"\]
%\\evensidemargin = -0.25in
%\\oddsidemargin = 0.25in
\[/sourcecode\]

And here is what you get:

\[caption id="attachment\_754" align="alignnone" width="225" caption="The finished product"\][![]({static}2011/05/photo_71194a6e-bfd5-cb24-6596-08771504c330.jpg?w=225 "image1"){.size-medium .wp-image-754 width="225" height="300"}]({static}2011/05/photo_71194a6e-bfd5-cb24-6596-08771504c330.jpg)\[/caption\]

Since both gutenmark and pdflatex are command line tools, we can script the conversion process. The editing is done with [Sed](http://www.grymoire.com/Unix/Sed.html) (*the* stream editor). I get mine from [cygwin](http://www.cygwin.com), though there are plenty of ways to get the Gnu toolset onto a windows machine these days.

\[sourcecode language="bash" wraplines="true"\]
\#!/bin/sh
/c/Program\\ Files/GutenMark/binary/GutenMark.exe --config="C:\\Program Files\\GutenMark\\GutConfigs\\GutenMark.cfg" --ron --latex "\$1.txt" "\$1.tex"

sed 's/paperwidth=5.5in/paperwidth=3.5in/
s/paperheight=8.5in/paperheight=4.72in/
s/bmargin=0.75in/bmargin=0in/
s/tmargin=0.75in/tmargin=0.5in/
s/lmargin=1in/lmargin=0.2in/
s/rmargin=1in/rmargin=0.2in/
s/\\\\oddsidemargin/%\\\\oddsidemargin/
s/\\\\evensidemargin/%\\\\evensidemargin/' \<"\$1.tex" \>"\$1.bebook.tex"

pdflatex -interaction nonstopmode "\$1.bebook.tex"

rm \*.aux \*.log \*.toc \*.tex
\[/sourcecode\]

Now all you need to do is invoke this bash script with the (extensionless) name of the gutenberg text file, and it will give you a PDF file in return. nice.
