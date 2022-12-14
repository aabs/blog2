---
title: Windows Live Writer Beta 2, VS Paste and Wordpress
date: 2007-05-31
author: Andrew Matthews
slug: windows-live-writer-beta-2-vs-paste-and-wordpress
status: published
---

[Here's an example I pasted from [LinqToRdf](http://code.google.com/p/linqtordf/).]{style="color:rgb(0,0,255);"}

    private void GenerateBinaryExpression(Expression e, string op)
    {
        if (e == null)
            throw new ArgumentNullException("e was null");
        if (op == null)
            throw new ArgumentNullException("op was null");
        if (op.Length == 0)
            throw new ArgumentNullException("op.Length was empty");
        BinaryExpression be = e as BinaryExpression;
        if (be != null)
        {
            QueryAppend("(");
            Dispatch(be.Left);
            QueryAppend(")"+op+"(");
            Dispatch(be.Right);
            QueryAppend(")");
            Log("+ :{0} Handled", e.NodeType);
        }
    }

If this displays properly for you, then I am a happy man.

[](http://11011.net/software/vspaste)
