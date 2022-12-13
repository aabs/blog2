---
title: Sequential script loading on demand
date: 2009-12-16 10:26
author: Andrew Matthews
category: functional programming, programming
ignored-tags: functional programming, javascript, jquery
slug: sequential-script-loading-on-demand
status: published
---

This little script uses the JQuery getScript command, enforcing sequential loading order to ensure script dependencies are honoured:

    function LoadScriptsSequentially(scriptUrls, callback)
    {
        if (typeof scriptUrls == 'undefined') throw "Argument Error: URL array is unusable";
        if (scriptUrls.length == 0 && typeof callback == 'function') callback();
        $.getScript(scriptUrls.shift(), function() { LoadScriptsSequentially(scriptUrls, callback); });
    }

Here's how you use it:

    function InitialiseQueryFramework(runTests)
    {
        LoadScriptsSequentially([
            "/js/inheritance.js",
            "/js/expressions.js",
            "/js/refData.js",
            "/js/queryRenderer.js",
            "/js/sha1.js",
            "/js/queryCache.js",
            "/js/unit-tests.js"],
            function()
            {
                queryFramework = new QueryManager("#query");
                if (runTests) RunTestSuite();
            });
    }

I love java script now and can't understand why I avoided it for years. I
particularly love the hybrid fusion of functional and procedural paradigms that
possible in JS. You can see that at work in the parameters being passed into the
recursive call to LoadScriptsSequentially.

What do you think? Is there a better/nicer way to do this?
