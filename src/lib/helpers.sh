#!/usr/bin/env bash

# lib/helpers.sh – utility functions shared across the project

# Ensure logs directory exists and return its absolute path
create_log_dir() {
    local base_dir="$1"
    local log_dir="$base_dir/logs"
    mkdir -p "$log_dir"
    echo "$log_dir"
}

# Write a TSV log entry: timestamp\tsrc\tdst\tstatus\tmessage
log_entry() {
    local log_file="$1"
    local src="$2"
    local dst="$3"
    local status="$4"
    local msg="$5"
    local ts=$(date '+%Y-%m-%d %H:%M:%S')
    printf "%s\t%s\t%s\t%s\t%s\n" "$ts" "$src" "$dst" "$status" "$msg" >> "$log_file"
}

# Generate a unique destination filename when a conflict occurs.
#   $1 – target directory (already exists)
#   $2 – original filename (basename only)
# Returns the new filename (may be same as input if no conflict).
unique_dest() {
    local dir="$1"
    local base="$2"
    local name="${base%.*}"
    local ext="${base##*.}"
    if [[ "$name" == "$ext" ]]; then
        # No extension
        ext=""
    else
        ext=".$ext"
    fi
    local candidate="$base"
    local i=1
    while [[ -e "$dir/$candidate" ]]; do
        candidate="${name} (${i})${ext}"
        ((i++))
    done
    echo "$candidate"
}

# Safely move a file without overwriting existing files.
#   $1 – source path (absolute)
#   $2 – destination directory (absolute)
#   $3 – log file path
# Returns 0 on success, 1 on failure.
safe_move() {
    local src="$1"
    local dst_dir="$2"
    local log_file="$3"
    local filename=$(basename "$src")
    mkdir -p "$dst_dir"
    local target_path="$dst_dir/$filename"
    if [[ -e "$target_path" ]]; then
        # Resolve duplicate
        local new_name=$(unique_dest "$dst_dir" "$filename")
        target_path="$dst_dir/$new_name"
    fi
    # Use mv -n (no overwrite) plus error capture
    if mv -n "$src" "$target_path"; then
        log_entry "$log_file" "$src" "$target_path" "SUCCESS" ""
        echo "$src|$target_path"   # transaction line for undo (pipe separated)
        return 0
    else
        local err=$(echo "$?" )
        log_entry "$log_file" "$src" "$target_path" "FAIL" "mv exit $err"
        return 1
    fi
}

# Record a transaction file (JSON‑like) for undo.
#   $1 – base directory (project root)
#   $2 – timestamp string (no spaces, e.g., 20261130-235959)
#   $3 – transaction lines (newline‑separated "src|dst")
record_transaction() {
    local base_dir="$1"
    local ts="$2"
    local lines="$3"
    local txn_file="$base_dir/logs/txn-${ts}.log"
    printf "%s\n" "$lines" > "$txn_file"
    echo "$txn_file"
}

# Undo the most recent transaction (based on newest txn‑*.log file).
undo_last() {
    local base_dir="$1"
    local log_dir="$base_dir/logs"
    local latest=$(ls -t "$log_dir"/txn-*.log 2>/dev/null | head -n1)
    if [[ -z "$latest" ]]; then
        echo "No transaction log found. Nothing to undo." >&2
        return 1
    fi
    local reverted=0
    while IFS='|' read -r src dst; do
        # Move back only if destination still exists
        if [[ -e "$dst" ]]; then
            mkdir -p "$(dirname "$src")"
            mv -n "$dst" "$src"
            ((reverted++))
        fi
    done < "$latest"
    echo "Undo completed: $reverted files restored."
    # Optionally keep the txn file for audit
    return 0
}

export -f create_log_dir log_entry safe_move unique_dest record_transaction undo_last
