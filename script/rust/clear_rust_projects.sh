#!/usr/bin/env bash
# Recursively finds Cargo projects from the current directory and runs cargo clean on each one.

set -euo pipefail

# Prints the first direct child of $1 named $2 (case-insensitive) of find type $3 (f or d).
find_entry() {
    local dir="$1" name="$2" type="$3"
    find "$dir" -mindepth 1 -maxdepth 1 -type "$type" -iname "$name" -print -quit
}

is_cargo_project() {
    local dir="$1"
    [[ -n "$(find_entry "$dir" "Cargo.lock" f)" ]] &&
        [[ -n "$(find_entry "$dir" "Cargo.toml" f)" ]] &&
        [[ -n "$(find_entry "$dir" "src" d)" ]] &&
        [[ -n "$(find_entry "$dir" "target" d)" ]]
}

clean_project() {
    local dir="$1" manifest target size
    manifest="$(find_entry "$dir" "Cargo.toml" f)"
    target="$(find_entry "$dir" "target" d)"
    size="$(du -sh "$target" 2>/dev/null | cut -f1 || true)"

    echo "Cargo project: $dir (target: ${size:-?})"
    # --manifest-path prevents cargo from walking up to a parent project.
    if cargo clean --manifest-path "$manifest"; then
        echo "  Cleaned: $dir"
    else
        echo "  Failed: $dir" >&2
    fi
}

traverse() {
    local dir="$1" sub name
    if is_cargo_project "$dir"; then
        clean_project "$dir"
        return
    fi

    while IFS= read -r -d '' sub; do
        name="$(basename "$sub")"
        [[ "${name,,}" == "target" || "$name" == .* ]] && continue
        traverse "$sub"
    done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d -print0)
}

main() {
    local answer=""
    if ! command -v cargo >/dev/null 2>&1; then
        echo "Error: cargo not found in PATH." >&2
        exit 1
    fi

    read -r -p "Clean all Cargo projects under $PWD? [y/N] " answer || true
    if [[ "$answer" != [yY] ]]; then
        echo "Aborted."
        exit 0
    fi

    traverse "$PWD"
}

main "$@"
