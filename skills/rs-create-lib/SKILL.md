---
name: rs-create-lib
description: Rust: create a new library in the current project.
---
This skill is intended to be used in  Rust projects only.

If the current project already contains a file called lib.rs , notify the user and exit.
If it not clear, ask the user which is the Rust project root directory and use it to locate the src directory; the one containing the files Cargo.toml and Cargo.lock.

Otherwise, reuse the skill /rs-create-source to create a file lib.rs in the src directory.