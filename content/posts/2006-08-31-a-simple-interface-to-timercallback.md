---
title: A Simple Interface to TimerCallback
date: 2006-08-31 05:56
author: Andrew Matthews
tags: programming
slug: a-simple-interface-to-timercallback
status: published
---

It's been a while since I last blogged. I moved to [Readify](http://www.readify.net), and have been burning the midnight oil ever since! But I wrote some code the other day that I thought might come in handy in future, so I thought I'd blog it.

What I needed to do was kick off a few activities that run periodically in their own thread. As ever, I started out by writing code to manage signaling to between the main thread and the worker thread with sleep periods when there was nothing to do, till it was time to start again. Needless to say, it all got very repetitive and messy. So I rewrote it focusing on making the developer work as simple as possible, with no repetitions.

Here's how it works. I define an interface called ITimerActivity which has a single method returning a void and taking an object. The TaskHandler method matches the delegate expected by the TimerCallback constructor. Your worker function implements this method, to perform the activity you want run, and the TimerHandler class passes your TaskHandler method as a delegate to the TimerCallback method. It then manages the timer using a simpler mechanism of Start and Stop. So, all you need to do to make use of timers is to implement thus ITimerActivity interface and use it inside a TimerHandler.

public interface ITimerActivity
{

void TaskHandler( object obj );

}

Here is a test class that will periodically write out a debug string

public class TestActivity : ITimerActivity

{

private readonly string msg;

public TestActivity(string msg)

{

this.msg = msg;

}

public void TaskHandler( object obj )

{

Debug.WriteLine( "Timer called: " + msg );

}

}

To handle starting and stopping the timer, and to control how often it is run I defined the TimerHandler class, which is a generic class that takes objects implementing the ITimerActivity interface. A simple constructor function with the task, the time to start and the frequency of invocation allows the timer to be initiated without recourse to any grizzly details

public class TimerHandler\<Task\> where Task : ITimerActivity {

\#region properties

public Timer Timer {

get { return theTimer; }

set { theTimer = value; }

}

public Task TheTask  {

get { return theTaskField; }

set { theTaskField = value; }

}

public bool IsRunning {

get { return taskIsRunning; }

set { taskIsRunning = value; }

}

public long MillisecondsTillInitialActivation {

get { return taskMillisecondsTillInitialActivation; }

set { taskMillisecondsTillInitialActivation = value; }

}

public long MillisecondsBetweenInvocations {

get { return taskMillisecondsBetweenInvocations; }

set { taskMillisecondsBetweenInvocations = value; }

}

\#endregion

\#region fields

protected Timer theTimer;

protected Task theTaskField;

protected bool taskIsRunning = false;

protected long taskMillisecondsTillInitialActivation = 0;

protected long taskMillisecondsBetweenInvocations = 0;

\#endregion

public TimerHandler( Task task, long millisecondsTillInitialActivation,
                          long millisecondsBetweenInvocations ) {

this.theTaskField = task;

this.taskMillisecondsTillInitialActivation = millisecondsTillInitialActivation;

this.taskMillisecondsBetweenInvocations = millisecondsBetweenInvocations;

theTimer = CreateTimer();

}

public void Start() {

theTimer.Change( taskMillisecondsTillInitialActivation, taskMillisecondsBetweenInvocations );

taskIsRunning = true;

}

private Timer CreateTimer() {

return new Timer( new TimerCallback( theTaskField.TaskHandler ), this,
          Timeout.Infinite, taskMillisecondsBetweenInvocations );

}

public void Stop()  {

theTimer.Change( Timeout.Infinite, taskMillisecondsBetweenInvocations );

taskIsRunning = false;

}

}

So a typical invocation might look like this:

// start at midnight tonight
long start = DateTime.Today.AddDays(1)
    .Subtract(DateTime.Now).Milliseconds;

// run every thirty minutes
long freq = TimeSpan.FromMinutes( 30 ).Milliseconds;

TimerHandler\<TestActivity\> Test =
    new TimerHandler\<TestActivity\>(new TestActivity ("Hello World"), start, freq);

SpellChecker.Start();

// ...

SpellChecker.Stop();
