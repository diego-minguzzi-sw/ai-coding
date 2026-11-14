---
name: cpp-create-file
description: Use it to create a new C++ file
---
Instructions to create a C++ header or source file, in the path <source-path> with name <filename>
This skill is intended to be used in C++ projects only.

Required parameters:
  - <source-path> : the path where the new C++ source file will be created.
  - <filename> : the name of the C++ source file to create, including either the .h or the .cpp extension

# Steps to create a new C++ file

## Check whether the file already exists
If the file already exists, stop and notify the user that the file will not be overwritten.

## Check whether the directory <source-path> already exists
If <source-path> does not exist, create it before creating the file.

## Ask for confirmation to the user
Before adding the file, ask confirmation to the user, saying:
"About to create the file <source-path>/<filename> . Proceed?"

If the user denies, stop immediately.

## Find environment information

### Username
The username of the current user is required to populate the file header.
Use the skill /utils-get-username to retrieve the username.
Assign the username to the variable [username] .


## Create the file header
Before creating the C++ source file, read assets/source_header.cpp relative to this SKILL.md.
Read the contents of `assets/source_header.cpp` into a variable called `header`.
In `header` substitute [username] with the username found at the step before.

In the new C++ source file, replace every occurrence of the string `[username]` in the `header` variable with the retrieved username.

## Create the C++ source file
Create a file with filename <source-path>/<filename>

The C++ source file must contain the header

```c++
[header]
```
