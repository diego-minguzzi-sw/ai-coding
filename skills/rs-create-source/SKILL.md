---
name: rs-create-source
description: Create a new Rust source file
---
Instructions to create a Rust source file in the path <source-path> with name <filename>

Find the current user name let's say the username is [username].
In Windows:
```bat
echo %USERNAME%
```

Create a file with filename src/<source-path>/<filename>.rs relative to the current Cargo project.

Before adding the file, ask confirmation to the user, saying:
"About to create the file src/<source-path>/<filename>.rs . Proceed?"

If the user denies, stop.

The Rust source file must have the following content:
```rust
//------------------------------------------------------------------------------------------------
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

