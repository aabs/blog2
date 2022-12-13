---
title: Lambda Functions in Multi-threaded Development
date: 2007-10-20 21:47
author: Andrew Matthews
slug: lambda-functions-in-multi-threaded-development
status: published
---

I'm on one of Juval Lowy's WCF Masterclass courses at the moment. Needless to
say, my mind is buzzing from the fire-hose brain-dump he's doing on us at the
moment. It's wonderful to see someone so deeply in command of the technology,
not to mention daunting at the sheer incline of the learning curve. He's had
some influence on the development of both C\# and Visual Studio as well as WCF,
so it's not surprising that he has sprinkled the course with some elegant little
language features that joined the dots for me. With 1400 slides in his slide
deck, there's plenty of space for language digressions as well.

One favorite of mine was the use of the new lambda function notation in the
course of everyday UI and multithreaded development. Wherever you see a
delegate, callback or handler in your normal code you can now make use of a
lambda function. Of course this won't be news to the functional programmers out
there, but within a few years there will be more functional code in production
environments via C\# than ever came from pure functional languages.

    [TestMethod] public static void TestLambdas() {   for (int i = 0; i < 300; i++)   {     Thread t = new Thread((x) =>       {         Thread.CurrentThread.Name = x.ToString();         Thread.Sleep(r.Next(250, 500));         Trace.WriteLine(string.Format("Hello from thread {0}",           Thread.CurrentThread.Name));       });     t.Start("T " + i);   }   Thread.Sleep(10000); }

This is nice and clean, and will prevent any nasty proliferation of one line event handlers.
