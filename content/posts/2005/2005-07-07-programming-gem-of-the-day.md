---
title: Programming Gem of the day
date: 2005-07-07 13:00
author: Andrew Matthews
ignored-tags: humour, programming, Work
slug: programming-gem-of-the-day
status: published
---

I think this one requires no disparaging commentary, it's funereal dissatisfactoryness stands as a balefire to all of you who want to write code that is both tenebrous and brittle.

    adCol.Add(new
      Advertisement(dr.GetString(0),
        dr.GetDateTime(1),dr.GetString(2),
        dr.GetString(3), dr.GetInt32(4),
        dr.GetBoolean(5), dr.GetFloat(6),
        dr.GetString(7), dr.GetString(8),
        dr.GetString(9),
        dr.GetDateTime(10),
        (int)dr.GetInt16(11),
        (int)dr.GetInt16(12),
        (int)dr.GetInt16(13),
        dr.GetString(14),
        dr.GetString(15),
        dr.GetString(16),
        dr.GetString(17), dr.GetInt32(18),
        dr.GetString(19),
        dr.GetString(20),
        dr.GetString(21).ToCharArray()[0],
        dr.GetString(22).ToCharArray()[0],
        dr.GetString(23)));

This example has been formatted for extra readability - it was on a single line.
I would also like to point out that I had ABSOLUTELY NOTHING TO DO WITH THE PRODUCTION OF THIS PIECE OF CODE!
