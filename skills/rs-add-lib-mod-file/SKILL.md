---
name: rs-add-lib-mod-file
description: Use it to create a Rust source file in a library module
---
Instructions to create a Rust source file [rs-file] in the library module [mod].

Required parameters:

  - [rs-file] the name of the Rust source file.  The filename will be [rs-file].rs
  - [mod] the module that will contain the new Rust source file.

Steps:
  - locate the Rust project
  - retrieve the parameters from the user
  - find information related to the environment
  - create the Rust source file
  - create or update mod.rs to include the new module

# Locate the Rust project
This skill is intended to be used in  Rust projects only.
The module is created in a Rust project.
If it not clear, ask the user which one is the Rust project root directory and use it to locate the src directory; the one containing the files Cargo.toml and Cargo.lock.


# Retrieve the parameters from the user
The user must specify all the neede parameters:
  - [rs-file] the name of the Rust source file.  The filename will be [rs-file].rs
  - [mod] the module that will contain the new Rust source file.

In any of these cases, notify the user and exit:

  - the user does not specify all the needed parameters
  - [rs-file] is such that [rs-file].rs is not a valid filename
  - the Rust project does not contain a directory named src/[mod]

# Find information related to the environment
## Username
The username of the current user is required to populate the file header.
Use the skill /utils-get-username to retrieve the username.
Assign the username to the variable [username] .

# Create the Rust source file
Use the skill /rs-create-file to create a Rust source file in the path src/[mod] with name [rs-file].rs

# Create or update mod.rs to include the new module

- If the file src/[mod]/mod.rs does not exist, create it using the skill /rs-create-file.
- otherwise add the following lines to src/[mod]/mod.rs file

Add the following lines to src/[mod]/mod.rs, sorting the child modules by name:
```rust
mod [rs-file];
pub use self::[rs-file]::*;
```


