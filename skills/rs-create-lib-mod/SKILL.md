---
name: rs-create-lib-mod
description: Use with Rust, to create a new module in the project library.
---
This skill is intended to be used in  Rust projects only.

Required parameters:
  - [mod-name] : the name of the module to create.

# Locate the Rust project

The module is created in a Rust project.
If it not clear, ask the user which is the Rust project root directory and use it to locate the src directory; the one containing the files Cargo.toml and Cargo.lock.

# Ask the new module name
Ask the user for the name of the module: that populates the placeholder [mod-name]

# Create the module directory
if the src directory already contains a directory called [mod-name], notify the user and exit.

Otherwise, create a new directory called [mod-name] inside the src directory and add a mod.rs file inside it.

Use the skill /rs-create-source to create the mod.rs file inside the [mod-name] directory.
Then, remove the line
```rust
use namefn::namefn;
```
, from mod.rs , since it is not used.

# Update or create the lib.rs file

If the src directory contains a lib.rs file, add the line ```rust
pub mod [mod-name];
``` to it.

If the src directory does not contain a lib.rs file, create one and add the line ```rust
pub mod [mod-name];
``` to it.

Use the skill /rs-create-source to create the lib.rs file if it does not exist.

Suppose that the user specified the mod-name = cli_args

The directory structure should look like this:

```
src/
  cli_args/
    mod.rs
  lib.rs
```

Suppose that the lib.rs file was just created, it should contain the following line:

```rust
pub mod cli_args;
```




