#!/usr/bin/env bash
# Recursively finds Cargo projects from the current directory and runs rustfmt on every *.rs file under src.

set -euo pipefail

readonly DEFAULT_EDITION="2021"

# Prints the first direct child of $1 named $2 (case-insensitive) of find type $3 (f or d).
find_entry() {
    local dir="$1" name="$2" type="$3"
    find "$dir" -mindepth 1 -maxdepth 1 -type "$type" -iname "$name" -print -quit
}

is_cargo_project() {
    local dir="$1"
    [[ -n "$(find_entry "$dir" "Cargo.lock" f)" ]] &&
        [[ -n "$(find_entry "$dir" "Cargo.toml" f)" ]] &&
        [[ -n "$(find_entry "$dir" "src" d)" ]]
}

get_edition() {
    local cargo_toml="$1" edition
    edition="$(sed -nE 's/^[[:space:]]*edition[[:space:]]*=[[:space:]]*"([0-9]+)".*/\1/p' "$cargo_toml" | head -n 1 || true)"
    echo "${edition:-$DEFAULT_EDITION}"
}

format_project() {
    local dir="$1" src_dir edition file
    src_dir="$(find_entry "$dir" "src" d)"
    edition="$(get_edition "$(find_entry "$dir" "Cargo.toml" f)")"

    echo "Cargo project: $dir (edition $edition)"
    while IFS= read -r -d '' file; do
        if rustfmt --edition "$edition" "$file"; then
            echo "  Formatted: $file"
        else
            echo "  Failed: $file" >&2
        fi
    done < <(find "$src_dir" -type f -name '*.rs' -print0)
}

traverse() {
    local dir="$1" sub name
    if is_cargo_project "$dir"; then
        format_project "$dir"
    fi

    while IFS= read -r -d '' sub; do
        name="$(basename "$sub")"
        [[ "$name" == "target" || "$name" == .* ]] && continue
        traverse "$sub"
    done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d -print0)
}

main() {
    if ! command -v rustfmt >/dev/null 2>&1; then
        echo "Error: rustfmt not found in PATH." >&2
        exit 1
    fi
    traverse "$(pwd)"
}

main "$@"
