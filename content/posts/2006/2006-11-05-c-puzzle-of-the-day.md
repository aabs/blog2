---
title: C# puzzle of the day
date: 2006-11-05
author: Andrew Matthews
ignored-tags: Computer Science
slug: c-puzzle-of-the-day
status: published
---

Lately I've been exploring old prototype code I wrote year ago. It always amazes me to se how my coding style changes over the years. It also intrigues me, because it's a kind of cross between archeology and journaling. I can see what I was doing years ago. I wrote this little C++ memory simulation back in 2002, for a the memory component of a little CPU simulator:

`struct memory { byte_t* mem; unsigned int size;``memory(unsigned int x = vpc::mem_size)   {   mem = new byte_t[x];   size = x;   //memset(mem, 0, size);   } ~memory()   {   if(mem != 0)     {     delete mem;     mem = 0;     size = 0;     }   }`

template\<typename T\>
T get(unsigned int idx)
  {
  return \*(T\*)(mem + idx);
  }

template\<typename T\>
T get(unsigned int base, unsigned int off)
  {
  return get(base + off);
  }

template\<typename T\>
void set(unsigned int idx, T& t)
  {
  \*(T\*)(mem + idx) = t;
  }
};
It's easy to see how C++ grew out of Simula. There's very little difference here between a simulation and the real thing. This could be part of a primitive memory manager if you enhanced it a little. It grabs a piece of memory, and then treats it as though it were a T. I just used the get and set methods to allow me to easily manipulate C++ data types from a test harness. I can only think of two ways to do this in C\#. First was the MemoryStream class, that would allow you to serialize your objects into and out of [memory]{style="font-family:Courier New;"}, and the other would be the BitConverter class. BitConverter would be more efficient, but only supports primitive types. A serialized class is not much use at runtime, since you would have to deserialize it to use it.

I like this because it illustrates how a strongly typed language can be a hindrance. Last time I posted an entry criticising C\# for lacking the power of C++, I got back some very intriguing responses that showed that with sufficient ingenuity, you can get around most hurdles in a language. So this time, I'm wondering how we could overcome this strong typing constraint. I know I'm a hypocrite for eulogising about strong typing in one post, and then criticising it in the very next. I guess I just want the power to not be bound by it, if I know what I am doing.

This must be an issue for C\# communications libraries where they need to efficiently convert a byte stream into an object. Since all objects and classes are ultimately composed of primitives, I have to assume that recursive application of the BitConverter class is enough to impose shape on the data stream - but you would have to assign an object on a heap to store the data, so you can't do what is done above.

How would you do this in C\#?
