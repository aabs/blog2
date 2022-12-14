---
title: Predicates and Expressions - Part 2
date: 2005-04-26
author: Andrew Matthews
ignored-tags: DBC
slug: predicates-and-expressions-part-2-3
status: published
---

Last time I started discussing the expression language used to define predicates on types and members. My conclusions were:

-   C\# expression syntax used since code must be transformed to that in the end, and the more similar the syntaxes of the expression language - the easier the transformation will be.
-   No side-effects. Side effect within the predicates complicate the tasks of determining whether a temporal comparison is actually effective. If the snapshots can't be guaranteed to be faithful representations of the state before and after the test, then you can't trust the tests, and you might as well not have bothered with them in the first place.
-   Pragmas, or pre-processor messages, are used in expressions to add a temporal ability to the predicates. \$before(foo) allows a snapshot of the variable foo to be taken for later comparison with the exit state.
-   Pragmas may map to identity in some circumstances. Entry states can have no \$after() since we haven't reached the exit state yet. Likewise, there is no notion \$before() state since this is the before state, and we can't take a snapshot of the state before the before state (unless it's on some other superior method). Therefore, in a precondition it should be illegal to insert pragmas into predicate expressions. In some cases such as \$before(foo) in a precondition, and \$after(bar) in a post condition the pragmas map onto the current value of the variable. i.e. in a post condition \$after(bar) can be transformed into bar.

The algorithm for converting predicates to guard code is shown below.

    foreach assembly in assembly list
      foreach type in assembly
        clear list of invariance predicates
        clear list of processed methods
        foreach invariant attribute on type
          transform pragmas on predicate
          add pre/post analysis objs to list
          generate code for predicate
          append code to processedInvariants list
        end foreach invariant
        foreach member in type
          clear list of requires attrs
          foreach requires attr on member
            transform pragmas on predicate
            add pre/post analysis objs to list
            generate code for predicate
            append code to processedRequires list
          end foreach requires attr
          clear list of ensures attrs
          foreach ensures attr on member
            transform pragmas on predicate
            extract list of vars to be snapshot
            add to list processedSnapshots
            add pre/post analysis objs to list
            generate code for predicate
            append code to processedEnsures list
          end foreach ensures attr
          insert snapshots into code template
          insert pre/post analysis objs to template
          insert code for requires guards into template
          insert code for ensures guards into template
          generate code
          add generated code to processed methods list
        end foreach member
        insert code for members into type template
        clear list of invariance predicates
        generate code for type
        append code to processed types list
      end foreach type
      setup c# compiler with config params
      compile all types in processed types list
      store assembly as per instructions
    end foreach assembly

This algorithm conveniently glosses over the complexities of the depth first search event propagation mechanism described in previous posts, but the outcome is the same ultimately.
