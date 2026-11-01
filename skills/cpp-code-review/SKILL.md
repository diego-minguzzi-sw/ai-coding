---
name: cpp-code-review
description: Use it to execute code reviews on C++ source code.
---

Parameters asked to the user:

  - [feature] optional parameter: the name of the class or file, to focus on

If no [feature] is specified, review the modifications that occurred in the current branch, not yet pushed.

When reviewing C++ focus on the areas listed below.

# Multithreading
Analyze the implementation against race conditions, deadlocks, currect use synchronization among threads, for example: 

- mutexes
- condition variables
- semaphores
- shared queues

# Resource leaks
Robust memory allocation and deallocation both in case of correct execution and in case of errors.

# Unhandled conditions 
Check if the code handles all conditions, or if there are:

- corner cases 
- unhandled enumerators 
