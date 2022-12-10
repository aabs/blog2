---
title: Code Generation Patterns - Part 3
date: 2005-04-12 17:00
author: Andrew Matthews
tags: Code Generation, programming
slug: code-generation-patterns-part-3-3
status: published
---

This time I'm going to describe the source snippet that I posted last time. In previous posts I showed the implementation that I use of the Observer pattern to fire off events notifying the code generator about code structures that it has found. The code generator was shown last time, and you can see that there are a whole bunch of event handlers that take note of the code structures and perform code generation tasks as required.

A typical example is the handler *NewType* that generated code for classes, structures and interfaces. As you will recall from my last post, I am using depth-first recursion in my scanner, to allow my code generator to generate in one pass. That means that there will be a lot of generated code knocking about from all of the invariant predicates, methods, events, fields and properties that were detected before the type event was invoked.

The first thing the CG does is add the namespace of the type to a list of Namespaces that is being kept for addition at the top of the code for the proxy. Obviously the proxy needs to know about the target object. As a general rule you should use the fully qualified name of any type that you refere to in argument lists, return types etc. Readability is not an issue here (very much) but not having to keep track of all the namespace references that could be needed is worth this stricture.

Following the namespace manipulations the generated code is added to the context variables for the NVelocity template. The generated code is kept in the context vars between lines 10 and 21. For common code structures such as assemblies, types and methods the generated code is added to an ArrayList and when the next most senior CG template needs to include them, it just iterates through the list, inserting everything that it finds. The HashTables are an implementation convenience that helps the CG to maintain a unique list of variables that need to have snapshots taken.

After the CG has added all of the snippets of code that have been generated so far, it invokes the template for the type itself. The template looks like this:

    namespace ${type.Namespace}.Proxies{
    #region Class ${type.FullName}Proxy
    public class ${type.Name}Proxy
    {
    internal ${type.FullName} TheTargetObject = null;
    public ${type.Name}Proxy(${type.FullName} target)
    {
    TheTargetObject = target;
    }

    #foreach($method in $methods)
    $method
    #end
    #foreach($property in $properties)
    $property
    #end
    #foreach($field in $fields)
    $field
    #end
    #foreach($event in $events)
    $event
    #end
    } // end class ${type.FullName}Proxy
    } // end namespace ${type.Namespace}.Proxies
    #endregion

As you can see the template is minimal. All of the interesting work has been done in other templates or "*Pragma processors*". I'll be going into pragma processors in depth next time. Work ahead of me includes making the proxy implement the same interfaces as the target object. In the template above the proxy class is generated with exactly the same name as the target class, but with "*Proxy*" appended. It has the same namespace with "*.Proxies*" appended. The proxy stores a reference to the target object called *TheTargetObject*. TheTargetObject is delegated to when all the predicate checks have been performed. The template for a method is where the action is:

    #if(!$utils.IsProperty($method))
    #if($utils.IsVoidType($method.ReturnType))
    #set($returntype = "void")
    // found a void return type
    #else
    #set($returntype = ${method.ReturnType.FullName})
    // didnt find a void return type
    #end## if isVoidType

    public new $returntype ${method.Name}(#set($comma = "")
    #foreach($arg in ${method.GetParameters()})
    $comma ${arg.ParameterType.FullName} ${arg.Name}#set($comma = ", ")#end){
    // take the 'before' snapshots
    #foreach($snapshot in $ssbefore)
    $snapshot.TypeName ${snapshot.After} = ${snapshot.Before};
    #end

    //TODO: Invariant code here
    #foreach($inv in $invariants)
    $inv
    #end
    //TODO: Require code here
    #foreach($req in $requires)
    $req
    #end

    ## now the call the the real object
    #if(!$utils.IsVoidType($method.ReturnType))
    $returntype result =
    #end##if is void

    #if($method.IsStatic)
    ${fullclsname}.${method.Name}(#set($comma = "")
    #else
    TheTargetObject.${method.Name}(#set($comma = "")
    #end
    #foreach($arg in ${method.GetParameters()})
    $comma${arg.Name}#set($comma = ", ")#end);

    // take the 'after' snapshots
    #foreach($snapshot in $ssafter)
    $snapshot.TypeName ${snapshot.After} = ${snapshot.Before};
    #end

    //TODO: Ensure code here
    #foreach($ens in $ensures)
    $ens
    #end
    //TODO: Invariant code here
    #foreach($inv in $invariants)
    $inv
    #end

    #if(!$utils.IsVoidType($method.ReturnType))
    return result;
    #end##if is void
    }#end ## if is not property

The templates are pre-loaded with a "*utils*" object that is able to perform various jobs related to analyzing types that are beyond the capabilities of NVelocity. We use this to check whether the method is a property or not. Properties in C\# are handled as methods in the CLR. If we ignore properties and generate them as methods we lose a lot of the syntactic flexibility that C\# makes available.

We need to check then whether the method is void or not. If so, we provide the short form of the void type, since the code will not compile if we use "System.Void". *Not sure why that is the case. Answers on a postcode please!*

Having determined what the return type is going to be, we can then create the method signature. We are only ever going to get notified about the public methods, since those are all that external users of the proxy or the target object would ever get to see. We don't need to wrap protected, private or internal methods so we can hard-code the public access specifier. Next, the method parameters are inserted. They are a complete copy of the arguments of the target objects, but with the type names expanded.

Now we get to the whole purpose of this exercise - to insert predicate checks into the method body to check parameters, members and other features before and after invocation of the method on the target object. the pattern of the invariants is as follows:

-   invariant 1
-   invariant 2
-   invariant ...
-   invariant n
-   require 1
-   require 2
-   require ...
-   require n
-   TheTargetObject.Method(...)
-   ensure 1
-   ensure 2
-   ensure ...
-   ensure n
-   invariant 1
-   invariant 2
-   invariant ...
-   invariant n

*Invariants* are predicates that must be true at all times - they must be true before and after the method has been called. Therefore we bracket the call with the invariant tests, and have *requires* checks before and the *ensure* checks after. For more information on these predicates take a look at the language documentation for Eiffel. Since the invariants are invoked before and after every method call you should make sure that they are not too expensive.

At the end of the method template the script looks again to check whether the method returns a void, and if so skips the returning of a result. It also doesn't bother to collect the result in the first place.

Each of the methods is built this way, converted into a string and then appended to the end of the *ProcessedMethods* properties in the CG. When the *type event* is finally emitted, the ProcessedMethods property contains a wrapper for each of the methods that the scanner found. That should be every public method that the target object implements or inherits. Obviously, the invariant properties of the object must be true for *all* properties, fields, events and methods, so it is not enough just to wrap the methods that have *Require* and *Ensure* attributes attached, since the *Invariant* attributes apply for the whole type at all times.

Next time I'll show you how I convert the assertions made in the invariant, require and ensure attributes into working code that can be inserted into the proxy. I'll leave you with this exercise - How would *you* convert this into a peice of working code. I'll show you how I do it. Let me know if your approach is better, because I'd be glad to use it!
