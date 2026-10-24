---
name: rs-create-file
description: Use it to create a new Rust source file
---
Instructions to create a Rust source file in the path <source-path> with name <filename>
This skill is intended to be used in  Rust projects only.

Required parameters:
  - <source-path> : the path relative to the src directory where the new Rust source file will be created.
  - <filename> : the name of the Rust source file to create, without the .rs extension.

# Steps to create a new Rust file

# Locate the Rust project
This skill is intended to be used in  Rust projects only.
The module is created in a Rust project.
If it not clear, ask the user which is the Rust project root directory and use it to locate the src directory; the one containing the files Cargo.toml and Cargo.lock.

## Ask for confirmation to the user
Before adding the file, ask confirmation to the user, saying:
"About to create the file src/<source-path>/<filename>.rs . Proceed?"

If the user denies, stop immediately.

## Find environment information

### Username
The username of the current user is required to populate the file header.
Use the skill /utils-get-username to retrieve the username.
Assign the username to the variable [username] .


## Create the file header
Before creating the Rust source file, read assets/source_header.rs relative to this SKILL.md.
Read the contents of `assets/source_header.rs` into a variable called `header`.
In `header` substitute [username] with the username found at the step before.

In the new Rust source file, you will replace `[header]` with the contents of `assets/source_header.rs`.

## Create the Rust source file
Create a file with filename src/<source-path>/<filename>.rs relative to the current Cargo project.

The Rust source file must have the following content:

```rust
[header]
// [username]
//------------------------------------------------------------------------------------------------
use namefn::namefn;

/*
//------------------------------------------------------------------------------------------------
#[namefn]
fn my_function() {
}
*/
```