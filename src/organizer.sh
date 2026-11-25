#!/usr/bin/env bash

# src/organizer.sh – entry point for Smart Downloads Organizer
# -----------------------------------------------------------
# This script coordinates the workflow:
#   1. Parse CLI options
#   2. If --undo → call undo_last
#   3. Otherwise scan the target directory, categorize files, and move them
#   4. Support dry‑run and interactive confirmation
#   5. Log each operation and generate a transaction file for undo
#
# The script is deliberately kept POSIX‑compatible with Bash‑specific features
# (associative arrays) that are available in Git Bash.

# Resolve script's own directory (project root = parent of src)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Source library modules
source "${PROJECT_ROOT}/src/lib/categories.sh"
source "${PROJECT_ROOT}/src/lib/helpers.sh"
source "${PROJECT_ROOT}/src/lib/cli.sh"

# Parse arguments (populate global associative array OPTS)
parse_args "$@"

# Helper to print messages when verbose is on
verbose_msg() {
    if [[ "${OPTS[verbose]}" == true ]]; then
        echo "$1"
    fi
}

# ---------------------------------------------------------------------------
# Undo mode
# ---------------------------------------------------------------------------
if [[ "${OPTS[undo]}" == true ]]; then
    undo_last "$PROJECT_ROOT"
    exit $?
fi

# ---------------------------------------------------------------------------
# Validate target directory
# ---------------------------------------------------------------------------
TARGET_DIR="${OPTS[directory]}"
if [[ -z "$TARGET_DIR" ]]; then
    echo "Error: --directory=PATH is required (or use --undo)." >&2
    print_help
    exit 1
fi
# Expand ~ and make absolute path
TARGET_DIR="$(cd "$TARGET_DIR" && pwd -P)"
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: Directory '$TARGET_DIR' does not exist or is not accessible." >&2
    exit 1
fi

# Prepare log files
LOG_DIR=$(create_log_dir "$PROJECT_ROOT")
LOG_FILE="${LOG_DIR}/organizer-$(date '+%Y%m%d-%H%M%S').log"
verbose_msg "Log file: $LOG_FILE"

# ---------------------------------------------------------------------------
# Scan files (non‑recursive – only direct children as per spec)
# ---------------------------------------------------------------------------
mapfile -t FILES < <(find "$TARGET_DIR" -maxdepth 1 -type f -printf "%p\n" 2>/dev/null)
TOTAL_FILES=${#FILES[@]}
if [[ $TOTAL_FILES -eq 0 ]]; then
    echo "No files found in '$TARGET_DIR'. Nothing to do."
    exit 0
fi

# Collect moves (src|dst) for transaction log
declare -a TRANSACTION_LINES=()
declare -A CATEGORY_COUNT=(
    [PDFs]=0 [Images]=0 [Documents]=0 [Videos]=0 [Audio]=0 [Archives]=0 [Code]=0 [Installers]=0 [Others]=0
)

# Prepare dry‑run output buffer
DRY_OUTPUT=""

# ---------------------------------------------------------------------------
# Process each file
# ---------------------------------------------------------------------------
for SRC in "${FILES[@]}"; do
    BASENAME="$(basename "$SRC")"
    # Skip this script itself if it resides in the target directory
    if [[ "$SRC" == "${PROJECT_ROOT}/src/organizer.sh" ]]; then
        continue
    fi
    CATEGORY=$(get_category "$BASENAME")
    DEST_DIR="$TARGET_DIR/$CATEGORY"
    ((CATEGORY_COUNT[$CATEGORY]++))
    if [[ "${OPTS[dry_run]}" == true ]]; then
        DRY_OUTPUT+="${SRC} → ${DEST_DIR}/${BASENAME}\n"
        continue
    fi
    # Normal move – safe_move returns transaction line on success
    TXN_LINE=$(safe_move "$SRC" "$DEST_DIR" "$LOG_FILE")
    if [[ $? -eq 0 ]]; then
        TRANSACTION_LINES+=("$TXN_LINE")
    fi
done

# ---------------------------------------------------------------------------
# Dry‑run handling
# ---------------------------------------------------------------------------
if [[ "${OPTS[dry_run]}" == true ]]; then
    echo -e "DRY RUN – no files were moved.\n"
    echo -e "$DRY_OUTPUT"
    echo "Summary: $TOTAL_FILES files would be processed."
    exit 0
fi

# ---------------------------------------------------------------------------
# Interactive confirmation (if requested)
# ---------------------------------------------------------------------------
if [[ "${OPTS[interactive]}" == true ]]; then
    echo "The following moves will be performed:" 
    for line in "${TRANSACTION_LINES[@]}"; do
        IFS='|' read -r src dst <<< "$line"
        echo "  $src -> $dst"
    done
    read -p "Proceed? [y/N] " -r answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
        echo "Operation cancelled by user."
        exit 0
    fi
fi

# ---------------------------------------------------------------------------
# Record transaction file for undo
# ---------------------------------------------------------------------------
if [[ ${#TRANSACTION_LINES[@]} -gt 0 ]]; then
    TXN_CONTENT=$(printf "%s\n" "${TRANSACTION_LINES[@]}")
    TXN_FILE=$(record_transaction "$PROJECT_ROOT" "$(date '+%Y%m%d-%H%M%S')" "$TXN_CONTENT")
    verbose_msg "Transaction log written to $TXN_FILE"
fi

# ---------------------------------------------------------------------------
# Summary report
# ---------------------------------------------------------------------------
echo "--- Summary Report ---"
echo "Total files scanned: $TOTAL_FILES"
MOVED_COUNT=0
for cat in "${!CATEGORY_COUNT[@]}"; do
    cnt=${CATEGORY_COUNT[$cat]}
    if [[ $cnt -gt 0 ]]; then
        echo "  $cat: $cnt"
        ((MOVED_COUNT+=cnt))
    fi
done
SKIPPED=$((TOTAL_FILES - MOVED_COUNT))
if [[ $SKIPPED -gt 0 ]]; then
    echo "Files skipped (e.g., already in correct folder or duplicate handling failed): $SKIPPED"
fi
echo "Log written to: $LOG_FILE"

exit 0
