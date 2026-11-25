#!/usr/bin/env bash

# Parse command-line options for Smart Downloads Organizer

parse_args() {
    DIR=""
    DRY_RUN=false
    INTERACTIVE=false
    UNDO=false
    VERBOSE=false

    while [[ $# -gt 0 ]]; do
        case "$1" in

            --directory)
                if [[ $# -lt 2 ]]; then
                    echo "Error: --directory requires a path." >&2
                    exit 1
                fi
                DIR="$2"
                shift 2
                ;;

            --directory=*)
                DIR="${1#*=}"
                shift
                ;;

            -d)
                if [[ $# -lt 2 ]]; then
                    echo "Error: -d requires a path." >&2
                    exit 1
                fi
                DIR="$2"
                shift 2
                ;;

            --dry-run|-n)
                DRY_RUN=true
                shift
                ;;

            --interactive|-i)
                INTERACTIVE=true
                shift
                ;;

            --undo|-u)
                UNDO=true
                shift
                ;;

            --verbose|-v)
                VERBOSE=true
                shift
                ;;

            --help|-h)
                print_help
                exit 0
                ;;

            -*)
                echo "Error: Unknown option: $1" >&2
                print_help
                exit 1
                ;;

            *)
                if [[ -z "$DIR" ]]; then
                    DIR="$1"
                else
                    echo "Error: Unexpected argument: $1" >&2
                    exit 1
                fi
                shift
                ;;
        esac
    done

    declare -gA OPTS=(
        [directory]="$DIR"
        [dry_run]="$DRY_RUN"
        [interactive]="$INTERACTIVE"
        [undo]="$UNDO"
        [verbose]="$VERBOSE"
    )
}

print_help() {
    cat <<'HELP'
Smart Downloads Organizer – Bash utility

Usage: organizer.sh [OPTIONS]

Options:
  --directory PATH     Folder to organize
  --directory=PATH     Folder to organize
  -d PATH              Folder to organize
  --dry-run, -n        Preview without moving files
  --interactive, -i    Ask before moving files
  --undo, -u           Undo the most recent operation
  --verbose, -v        Enable detailed output
  --help, -h           Display this help

Examples:
  ./organizer.sh --directory "$HOME/Downloads"
  ./organizer.sh --directory "$HOME/Downloads" --dry-run
  ./organizer.sh -d "$HOME/Downloads" -n
  ./organizer.sh --undo
HELP
}

export -f parse_args print_help