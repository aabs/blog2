---
title: The Ambient Context Design Pattern in .NET
date: 2007-12-31
author: Andrew Matthews
category: .NET, programming
slug: the-ambient-context-design-pattern-in-net
status: published
---

For a piece of agent related work I'm doing at the moment I am making heavy use of multi-threaded development. I'm developing a little special purpose Agent Framework to manage some data that I maintain. As part of that work, I need to have an ambient context object to hold details about the currently active agent and the tasks that it is performing. This is a common [pattern](http://en.wikipedia.org/wiki/Design_Patterns) that we see used throughout the .NET framework. They're a powerful mechanism to keep useful data around, to define scopes and to provide cross-cutting capabilities. They provide functionality and a non-intrusive management mechanism without having to clutter the components that need them with additional parameters or static variables. In effect they are a form of controlled global variable that exists to maintain scoped information.

Since I haven't seen this pattern documented in any detail elsewhere, I thought I might make a first attempt to describe it in pattern language terms. in what follows, I'll try to stick to the Gang of Four ([GoF94](http://www.awprofessional.com/title/0201633612)) format wherever possible, but I may make a few digressions for the sake of drawing parallels with comparable facilities in the framework (.NET 3.5). I'll also highlight when one of the characteristics I describe is not a universal feature of a context class, but is commonly enough used to be worth a mention.



Pattern Name and Classification
-------------------------------

Ambient Context

Intent
------

Provide a place to store scope or context related information or functionality that automatically follows the flow of execution between execution scopes or domains.

Also Known As
-------------

Scope, Context Object

Motivation (Forces)
------------------

You have a problem that demands the use of scoping of execution blocks. You also need to supply execution policy information to those blocks, and a means to pass other information and functionality that is automatically available in sub-scopes. In addition you don't want to add these facilities as parameters to every method signature that you work with. Some of the code that exists in your sub-scopes may not be under your control, or may be third party code - this would prevent you from passing information to other sub-systems that need the contextual information you are attempting to supply.  You want a standardised system that will make such information available without having to recourse to costly shared data systems like a database.

Applicability
-------------

This pattern applies in many area that deal with runtime execution scopes such as security, thread management, or call marshalling. If you wish to allow information and control to flow across code boundaries then you either have to employ something equivalent to a context object, or augment every API with parameters that carry this information for you.

Structure
---------

A context object for a scope is typically created, and managed by a singleton or static manager class or method. Frequently, the context object is a per-thread (or execution scope) singleton that contains several read-only properties supplying information for the scope. In addition, the context object may provide an area for storage of information that can be allowed to flow downstream to other scopes. If nesting is allowed in the scope of the context, then stacks are frequently employed to allow unwinding of the context on exit from a scope.

Participants
------------

The participants of this pattern include a static or singleton manager class, the context object, and the entities within the execution scope.

Collaboration
-------------

The manager class will provide a means to initiate a new scope. In the process it will instantiate a new context object which it will assign to the new scope. Prior to assignment to the scope the context object will be initialised with appropriate values for its read-only properties. Frequently these will be taken from the ambient values of an enclosing or current context. Once the ambient context is applied it will remain in effect until the scope is left. In some cases this may be due to an error state (such as an exception) in which case the context (and any effects that it might allow on the system state) are unwound and control is returned to the enclosing scope.

Consequences
------------

The consequences to the system of making use of an ambient context object will be dependent on the problem domain. One constant is that the need for a proliferation of parameters from client call signatures is reduced.

Implementation
--------------

Typically the context object is stored in a ***Thread Relative Static Field,*** access to which is controlled by the Manager class. Access to that can be achieved through the use of static property objects.

A simple implementation is shown below. It does not make use of thread static variables to achieve its effect. instead, it makes use of a static Stack class of contexts call scopeStack. being private, this stack is entirely under the control of the context object itself. Obviously there are other ways that a manager class could be made able to manage the creation and disposal of the context objects.

    public class MyNestedContext : IDisposable
    {
        private static Stack<MyNestedContext> scopeStack = new Stack<MyNestedContext>();
        public string Id { get; set; }
        public MyNestedContext(string id)
        {
            Id = id;
            scopeStack.Push(this);
        }
        public static MyNestedContext Current
        {
            get
            {
                if (scopeStack.Count == 0)
                {
                    return null;
                }
                return scopeStack.Peek();
            }
        }

        #region IDisposable Members

        public void Dispose()
        {
            if (ShouldUnwindScope())
                UnwindScope();
            scopeStack.Pop();
        }

        #endregion

        private void UnwindScope()
        {
            // ...
        }

        private bool ShouldUnwindScope()
        {
            bool result = true;
            //...
            return result;
        }
    }


    class Program
    {
        static void Main(string[] args)
        {
            Test1();
            Console.ReadKey();
        }

        private static void Test1()
        {
            Console.WriteLine("Current Context is {0}", MyNestedContext.Current != null ? MyNestedContext.Current.Id : "null");
            using (new MyNestedContext("outer scope"))
            {
                Console.WriteLine("Current Context is {0}", MyNestedContext.Current != null ? MyNestedContext.Current.Id : "null");
                using (new MyNestedContext("inner scope"))
                {
                    Console.WriteLine("Current Context is {0}", MyNestedContext.Current != null ? MyNestedContext.Current.Id : "null");
                }
                Console.WriteLine("Current Context is {0}", MyNestedContext.Current != null ? MyNestedContext.Current.Id : "null");
            }
            Console.WriteLine("Current Context is {0}", MyNestedContext.Current != null ? MyNestedContext.Current.Id : "null");
        }
    }

[](http://11011.net/software/vspaste)

This implementation produces the desired result:

> Current Context is null
> Current Context is outer scope
> Current Context is inner scope
> Current Context is outer scope
> Current Context is null

While this will work in a single-threaded environment its flaw is that the same context stack is shared between all threads. This will probably for example not be appropriate for a service oriented application (such as might be based on WCF) may have multiple unrelated threads going on at a time. the following code (within a context manager class) can be used to create a new thread with the same context as was current in the creating thread.

    public static void Run(ParameterizedThreadStart pts, Object obj, string threadName)
    {
        // get the current context
        Context c = CurrentContext;
        // create a wrapper delegate to set up the context
        ParameterizedThreadStart pts2 = (Object arg) =>
        {
            // extract the package of context, worker func and params
            Tuple<ParameterizedThreadStart, Context, Object> t = (Tuple<ParameterizedThreadStart, Context, Object>)arg;
            // set up the context
            ContextManager.StartNewContext(t.Second);
            // run the worker
            t.First(t.Third);
        };
        // package up the worker, current context and args
        Tuple<ParameterizedThreadStart, Context, Object> x = new Tuple<ParameterizedThreadStart, Context, Object>(pts, c, obj);
        // create and run a thread using the wrapper.
        Thread thread = new Thread(pts2);
        if (!string.IsNullOrEmpty(threadName))
        {
            thread.Name = threadName;
        }
        thread.Start(x);
    }

[](http://11011.net/software/vspaste)

We would also need to achieve the same effect if we were making cross process calls. In WCF, for example, this might be achieved through the use of a custom header that carries the new scope through to the new process. The implementation for that might resemble something like the following:

    public class EndpointBehaviorAddUserSessionId : IEndpointBehavior
    {
        #region IEndpointBehavior Members

        public void AddBindingParameters(
            ServiceEndpoint endpoint,
            BindingParameterCollection bindingParameters) { }

        public void ApplyClientBehavior(
            ServiceEndpoint endpoint,
            ClientRuntime clientRuntime)
        {
            clientRuntime.MessageInspectors.Add(new MessageInspectorAddCurrentContext());
        }

        public void ApplyDispatchBehavior(
            ServiceEndpoint endpoint,
            EndpointDispatcher endpointDispatcher) { }

        public void Validate(ServiceEndpoint endpoint) { }

        #endregion
    }


    public class MessageInspectorAddCurrentContext: IClientMessageInspector
    {
        public void AfterReceiveReply(ref Message reply, object correlationState)
        {
        }

        public object BeforeSendRequest(ref Message request, IClientChannel channel)
        {
            AddCurrentContext(ref request);
            return null;
        }

        private void AddCurrentContext(ref Message request)
        {
            if (MyNestedContext.Current != null)
            {
                string name = "MyNestedContext-Context";
                string ns = "urn:<some guid>";
                request.Headers.Add(
                    MessageHeader.CreateHeader(name, ns, MyNestedContext.Current));
            }
        }
    }

Which would then be used like so:

    internal static T CreateProxy<T>(string configName) where T : class
    {
        ChannelFactory<T> factory = new ChannelFactory<T>(configName);
        factory.Endpoint.Behaviors.Add(new EndpointBehaviorAddCurrentContext());
        return factory.CreateChannel();
    }
    public static IMyClientObject CreateCallManager()
    {
        return CreateProxy<IMyClientObject>("tcpMyClient");
    }

[](http://11011.net/software/vspaste)

Allowing the context at the top of the stack to flow to new new domain. When the new domain call progresses it may push further context objects onto the stack

Sample Code
-----------

the following sample demonstrates the implementations described above in action. the first example shows the single-threaded case, where no specific support is required to maintain and protect the context in a thread-safe way:

    private static void Test1()
    {
        DisplayScopeDetails();
        using (new Context("outer scope"))
        {
            DisplayScopeDetails();
            using (new Context("inner scope"))
            {
                DisplayScopeDetails();
            }
            DisplayScopeDetails();
        }
        DisplayScopeDetails();
    }

Which produces the expected output.

> Thread: unknown thread  Context: null
> Thread: unknown thread  Context: outer scope
> Thread: unknown thread  Context: inner scope
> Thread: unknown thread  Context: outer scope
> Thread: unknown thread  Context: null

The next example demonstrates the cross threaded support at work:

    private static void Test2()
    {
        DisplayScopeDetails("start");
        using (new Context("outer scope"))
        {
            DisplayScopeDetails();
            using (new Context("inner scope"))
            {
                DisplayScopeDetails("begin");
                ContextManager.Run(WorkerFunction, null, "new thread");
                Thread.Sleep(20);
                DisplayScopeDetails("end");
            }
            DisplayScopeDetails();
        }
        DisplayScopeDetails("end");
    }

    private static void WorkerFunction(object o)
    {
        DisplayScopeDetails("In Worker Function");
        using (new Context("inner inner scope"))
        {
            DisplayScopeDetails();
        }
        DisplayScopeDetails("Leaving Worker Function");
    }

[](http://11011.net/software/vspaste)[](http://11011.net/software/vspaste)

which this time produces the following

> Thread: unknown thread  Context: null   (start)
> Thread: unknown thread  Context: outer scope
> Thread: unknown thread  Context: inner scope    (begin)
> Thread: new thread      Context: inner scope    (In Worker Function)
> Thread: new thread      Context: inner inner scope
> Thread: new thread      Context: inner scope    (Leaving Worker Function)
> Thread: unknown thread  Context: inner scope    (end)
> Thread: unknown thread  Context: outer scope
> Thread: unknown thread  Context: null   (end)

[](http://11011.net/software/vspaste)

This demonstrates a situation where a new scope stack has to be created on a new thread, and then is allowed to grow before being unwound and discontinued. After 20ms the old thread is continued and it proceeds to unwind its own scope stack before completion.

Known Uses
----------

There are numerous uses of this pattern in cross domain communications libraries, multi-threading libraries and in server environments where thread pools handle numerous incoming requests. Examples include the core .NET framework classes listed below:

-   System.Globalization.CultureInfo
-   System.ActivationContext
-   System.Threading.ExecutionContext
-   System.Threading.SynchronizationContext
-   System.Transactions.TransactionScope
-   System.ServiceModel.OperationContext
-   System.Web.HttpContext
-   System.Security.SecurityContext
