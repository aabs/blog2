---
title: What I'm gonna cover
date: 2005-03-15 13:51
author: aabs
tags: DBC
slug: what-im-gonna-cover-2
status: published
---

When I get the time I intend to start off this blog by exploring the following ideas:

-   Developing a design by contract system for C\#
-   History of Design by Contract
-   Code Generation Systems XSLT vs NVelocity

I'm producing a Design by contract system that's in early alpha. It uses NVelocity, and declarative programming. It lets you write code like this:

    [Dbc, Invariant("Prop1 >= 1")]
    public class MyTestClass
    {
      public MyTestClass()
      {
        Prop1 = 10;
      }

      #region property Prop1
      int prop1 = 0;
      [Requires("value != 1561")]
      public int Prop1
      {
        get
        {
          return prop1;
        }
        set
        {
          prop1 = value;
        }
      }

      #endregion

      [Requires("arg1 > 10")]
      [Requires("arg2 < 100")]
      [Ensures("$after(Prop1) == $before(Prop1) + 1")]
      public void TestMethod(int arg1, int arg2, string arg3)
      {
        Prop1 = Prop1 + 1;
        System.Diagnostics.Debug.WriteLine( "MyTestClass.TestMethod.Prop1 == " + prop1.ToString());
      }
    }

During the rest of the project I'll show you how I expand this system to work with Aspect Oriented Programming, and Static and Dynamic Proxies. I'll also explore the best ways of implementing the control logic under the hood.
Till then, I guess we're stuck with Asserts or ifs at the beginning of methods.
