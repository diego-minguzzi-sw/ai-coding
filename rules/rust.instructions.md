---
name: 'Rust coding guidelines'
applyTo: '**/*.rs'
paths:
  - "**/*.rs"
---

# Rust Coding guidelines

- Use the Rust 2024 edition idioms.

- At the beginning of every Rust source file, after the banner (if it exists), among the ```rust use ``` declarations, add, sorted alphabetically:
```rust
use namefn::namefn;
```

- Before every function or method, add the decoration: ```rust #[namefn] ```
Example:
```rust
#[namefn]
fn test_references() {
    // ...
}
```

- Derive every struct from Debug, for example:
```rust
#[derive(Debug)]
struct Point<T> {
    x: T,
    y: T,
}
```


