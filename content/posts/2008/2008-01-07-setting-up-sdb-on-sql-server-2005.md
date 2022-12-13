---
title: Setting up SDB on SQL Server 2005
date: 2008-01-07 14:59
author: Andrew Matthews
category: .NET, programming, Semantic Web
slug: setting-up-sdb-on-sql-server-2005
status: published
attachments: 2008/01/image2.png, 2008/01/image1.png, 2008/01/image-thumb2.png, 2008/01/image-thumb1.png, 2008/01/image-thumb.png, 2008/01/image.png
---

[![image]({static}2008/01/image-thumb2.png){width="244" height="343"}]({static}2008/01/image2.png)For the non-Java developer, like me, setting up and configuring SDB can be tricky. While it's fresh in my mind I'll commit it to blog so that those who come after will not tear their hair out like I just did.

SDB sits below Jena providing it with database support for a triple store rather than the more restrictive RDF XML file. The benefits of using a database are obvious, but the difficulties are not. the following instructions assume that you are running JRE 1.6, Vista and Cygwin. You need Cygwin to be able to run the batch files that come with SDB. You could probably adapt them to work on DOS, but Cygwin allows you to run the scripts as is.

Checklist:

1.  Get a copy of SDB & put it somewhere handy (I chose C:\\etc\\downloads\\dev\\semantic-web\\sdb-1.0)
2.  Get a [JDBC driver](http://www.microsoft.com/downloads/details.aspx?FamilyId=C47053EB-3B64-4794-950D-81E1EC91C1BA&displaylang=en) for SQL server.
    1.  copy it to the lib dir under SDB. I'm not sure why, but I had to do this  despite the fact that there is an environment var that ought to be enough.
3.  Create a database for your triple store (I called mine TestTripleStore)
    1.  Remember that you must use binary collation (I chose Latin1\_General\_BIN).
    2.  Create a user and login for the new database (I chose sdbuser).
        1.  Login as that user using SQL Management Studio - in case you need to change the user credentials on first login.
    3.  Assign the new user ownership of the new triple store database.
    4.  [Setup TCP/IP access](http://blogs.msdn.com/sqlexpress/archive/2005/05/05/415084.aspx) on your database server.
4.  setup the following environment variables using your .profile or .bashrc file (remember to source the file before you try to do anything)
   SDBROOT="C:\\etc\\downloads\\dev\\semantic-web\\sdb-1.0"
   SDB\_JDBC="\$SDBROOT\\lib\\sqljdbc.jar"
   SDB\_USER="sdbuser"
   SDB\_PASSWORD="\*\*\*\*\*\*\*\*"
   Note the use of DOS/Windows style path declarations despite the use of Cygwin - this one always catches me out.
5.  write the SDB configuration file (sdb.ttl) and place it in the \$SDBROOT directory. This is straightforward - just modify the server and database name as appropriate:
   \@prefix sdb:     \<http://jena.hpl.hp.com/2007/sdb\#\> .
   \@prefix rdfs:     \<http://www.w3.org/2000/01/rdf-schema\#\> .
   \@prefix rdf:     \<http://www.w3.org/1999/02/22-rdf-syntax-ns\#\> .
   \@prefix ja:      \<http://jena.hpl.hp.com/2005/11/Assembler\#\> .

    \# Microsoft SQL Server

    \_:c rdf:type sdb:SDBConnection ;
       sdb:sdbType        "MSSQLServer" ;
       sdb:sdbHost        "[***localhost***]{.underline}" ;
       sdb:sdbName        "***[TestTripleStore]{.underline}***" ;
       sdb:driver         "com.microsoft.sqlserver.jdbc.SQLServerDriver"
       .

    \[\] rdf:type sdb:Store ;
       sdb:layout         "layout2" ;
       sdb:connection     \_:c ;

6.  Create the triple store for SDB:
   sdbconfig --sdb=sdb.ttl create

If all goes according to plan, you should get no errors and the following tables in SQL server.

[![image]({static}2008/01/image-thumb1.png){width="603" height="412"}]({static}2008/01/image1.png)
