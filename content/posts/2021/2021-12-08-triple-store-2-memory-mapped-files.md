---
title: Memory Mapped Files
series: ["Implementing A Triple Store"]
author: Andrew Matthews
date: 2021-12-09
tags: ["rdf", "rdf databases", "graph databases"]
---

The first thing we need to do to build a database is to find a fast way to read
from and write to disk.  Whether we are doing I/O on a hard drive or an SSD, the
interface to the disk typically works the same.  It transfers data into and out
of the disk in 'pages' or blocks of data.

It makes sense to keep data we are likely to access together in the same page so
that it is already in memory when we need to access it.  This applies whether we
are reading items in an index, or grabbing consecutive rows in a range.  This is
the principle of *temporal locality of reference*: We are most likely to access
data nearby on disk or in memory.

The size and shape of indexes in a database are often determined by the size of
virtual memory pages - how much will be brought into memory from disk when we
access something.  This allows us to exploit locality to minimise the cost of
scanning through indexes to find data we need.  Which brings us to our first
port of call in our triple store journey; memory mapped files.

I'm lazy.  And realistic.  I doubt I'd be able to do as good a job as the OS
developers at interfacing with disk efficiently (or at least not without
spending a LOT of time learning how to do it properly and portably).
Thankfully, there is a way for me to exploit all the specialised knowledge of
the OS implementors in reading and writing to disk efficiently.

A *Memory Mapped File* is a programming abstraction that exposes a file on disk
as though it were a region of memory.  The OS takes care of all the details of
mapping the memory region back onto the disk file.  It handles caching and all
the other details of keeping the file in memory and keeping the file in sync
with changes to the memory region.

.NET has a few nice features allowing us to work with memory mapped files and
also to efficiently work with raw blocks of binary data in memory.

Let's take a look at some code:

```csharp
[TestMethod]
public void CreateAndWriteToMMF()
{
    var filename = Path.GetTempFileName();
    try
    {
        // 1. Create a temporary file and map it into memory
        using var file = File.Create(filename, 2048, FileOptions.RandomAccess);
        using var mappedFile = MemoryMappedFile.CreateFromFile(file,
                                                                null,
                                                                1024,
                                                                MemoryMappedFileAccess.ReadWrite,
                                                                HandleInheritability.None,
                                                                false);
        int[] array = new[] { 1, 2, 3, 4, 5 };

        // 2. Get a view accessor allowing random access into the memory view of the file
        using var accessor = mappedFile.CreateViewAccessor(0, sizeof(int) * array.Length);

        // 3.  Write some data into the memory region
        accessor.WriteArray(0, array, 0, 5);

        // 4. push the updated data into the underlying file
        accessor.Flush();

        // 5. create another array and read out of the memory into the array
        var newArray = new int[5];
        accessor.ReadArray<int>(0, newArray, 0, 5);
        foreach(var item in newArray)
        {
            Console.WriteLine(item);
        }
    }
    finally
    {
        if (File.Exists(filename))
        {
            File.Delete(filename);
        }
    }
}
```

This creates a temporary file, maps it to memory, and writes an array of
integers starting at position 10, then deletes the file at the end.  The way it
is able to write into the file through the memory mapped file it via a
[`MemoryMappedViewAccessor`](https://docs.microsoft.com/en-us/dotnet/api/system.io.memorymappedfiles.memorymappedviewaccessor?view=net-6.0)
which provides random access to the contents of the file.

This would probably be adequate for a first version, but there is an API used
with accessing blocks of memory that has been around for a while.

## `Span<T>` and `Memory<T>`

The
[`Memory<T>`](https://docs.microsoft.com/en-us/dotnet/standard/memory-and-spans/memory-t-usage-guidelines)
structure acts as an adapter allowing you to have type safe access to the
contents of a block of memory.  It allows you to extract the contents of the
region as well as take slices of the memory, ensuring bounds checking is
enforced.  This is handy if we need to implement something like a B+ Tree over
the top of a page of raw bytes.  Right now, you need to use the
`DotNext.IO.MemoryMappedFiles` package (supported by the dotnetfoundation), that
has some nice extension methods to handle the creation of wrappers to the memory
mapped file.

Let's see what it looks like:

```csharp
using DotNext.IO.MemoryMappedFiles;

[TestMethod]
public void AccessMemoryMappedFileUsingMemoryOfT()
{
    var filename = Path.GetTempFileName();
    using var file = File.Create(filename, 2048, FileOptions.RandomAccess);
    using var mappedFile = MemoryMappedFile.CreateFromFile(file,
                                                            null,
                                                            1024,
                                                            MemoryMappedFileAccess.ReadWrite,
                                                            HandleInheritability.None,
                                                            false);
    // 1. Create a Direct Accessor
    var accessor = mappedFile.CreateMemoryAccessor();

    // 2. Create a `Span<int>` from the accessor's Span<byte>
    var memInts = MemoryMarshal.Cast<byte, int>(accessor.Bytes);

    // 3. Directly write bytes to the memory region
    for (int i = 0; i < 5; i++)
    {
        memInts[i] = i;
    }

    // 4. push to disk
    accessor.Flush();

    // 5. Read it back as before
    using var accessor2 = mappedFile.CreateViewAccessor(0, sizeof(int) * 10);
    var newArray = new int[5];
    accessor2.ReadArray<int>(0, newArray, 0, 5);
    foreach (var item in newArray)
    {
        Console.WriteLine(item);
    }
}
```

The `CreatememoryAccessor` provides a `Bytes` property of type `Span<byte>` that
is compatible with the other commonly adopted mechanisms to work with byte
blocks in .NET.  Now we can cast the byte span as an int span, and work with it
in much the same way as an `int[]`.

To those that are familiar with the techniques used in the old days to shovel
binary data around in C++, this is like a safe version of the trick of casting a
`void *` pointer to be a pointer to `T`.  Naughty but nice.

## Conclusion

Now we've got safe, very fast low level access to memory mapped files, we're in
a position to start implementing data structures like B+ Trees over the top of
it.  Next time I'll show how we might start to implement a rudimentary Storage
Engine for the triple store.
