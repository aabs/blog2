---
title: "Note to Self: Convert UTF-8 w/ BOM to ASCII (WIX + DB) using GNU uconv"
date: 2010-08-31
author: Andrew Matthews
category: SemanticWeb
ignored-tags: BOM, encoding, uconv, WIX
slug: note-to-self-convert-utf-8-w-bom-to-ascii-wix-db-using-gnu-uconv
status: published
---

This one took me a long time to work out, and it took a non-latin alphabet user (Russian) to point me at the right tools. Yet again, I'm guilty of being a complacent anglophone.

I was producing a database installer project using WIX 3.5, and ran into all sorts of inexplicable problems, which I finally tracked down to the Byte Order Mark (BOM) on my SQL update files that I was importing into my MSI file. See [here](http://www.tramontana.co.hu/wix/lesson7.php#) for more on that.

I discovered that the '*varied'* toolset used in our dev environments (i.e. VS 2010, Cygwin, VIM, GIT, SVN, NAnt, MSBuild, R\# etc) meant that the update scripts had steadily diffused out into Unicode space. You can find out (approximately) what the encodings are for a directory of files using the GNU file command. Here's a selection of files that I was including in my installer:

    $ file *
    01.sql:          ASCII text, with CRLF line terminators
    02.sql:          Little-endian UTF-16 Unicode text, with very long lines, with CRLF, CR line terminator
    03.sql:          UTF-8 Unicode (with BOM) text, with CRLF line terminators
    05.sql:          ASCII English text, with CRLF line terminators
    06.sql:          UTF-8 Unicode (with BOM) text, with CRLF line terminators
    11.sql:          ASCII C program text, with CRLF line terminators
    12.sql:          UTF-8 Unicode (with BOM) text, with CRLF line terminators
    23.sql:          ASCII text, with CRLF line terminators
    24.sql:          UTF-8 Unicode (with BOM) text, with CRLF line terminators
    25.sql:          UTF-8 Unicode (with BOM) text, with CRLF line terminators
    26.sql:          ASCII text, with CRLF line terminators
    27.sql:          UTF-8 Unicode (with BOM) text, with CRLF line terminators
    28.sql:          UTF-8 Unicode (with BOM) text, with CRLF line terminators
    29.sql:          Little-endian UTF-16 Unicode C program text, with very long lines, with CRLF, CR line
    30.sql:          UTF-8 Unicode (with BOM) C program text, with very long lines, with CRLF line terminat
    37.sql:          UTF-8 Unicode (with BOM) English text, with CRLF line terminators
    38.sql:          Little-endian UTF-16 Unicode text, with CRLF, CR line terminators
    39.sql:          Little-endian UTF-16 Unicode text, with CRLF line terminators
    44.sql:          UTF-8 Unicode (with BOM) text, with CRLF line terminators
    AlwaysRun0001.sql: ASCII C program text, with CRLF line terminators
    AlwaysRun0002.sql: UTF-8 Unicode (with BOM) C program text, with CRLF line terminators
    TestData0001.sql:        UTF-8 Unicode (with BOM) text, with very long lines, with CRLF line terminators

You can see that there appear to be a variety of encodings. I initially assumed that a quick run through d2u or u2d would fix them up, but that did nothing to change the encoding or remove the BOM. In the end I found the IBM uconv command, that has the handy '--remove-signature' option that was the key to the solution. Don't confuse this with the GNU iconv app, that doesn't allow you to strip the BOM from the front of your files.

    $ uconv --remove-signature -t ASCII TestData0001.sql > TestData0001.sql2
    $ rm TestData0001.sql
    $ mv TestData0001.sql2 TestData0001.sql

After that, the WIX installer worked OK, and all was right with the world. I hope this helps you if you run into the same problem.

I can't answer the question of why WIX/MSI fails to work with non-ASCII files (other than to say that Unicode blondness is a common problem of software written by Anglophones).
