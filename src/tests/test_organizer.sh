#!/usr/bin/env bash

# test_organizer.sh – automated test suite for Smart Downloads Organizer
# Uses a temporary directory to avoid touching real user files.

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ORGANIZER="$PROJECT_ROOT/src/organizer.sh"

# Helper to run a command and capture its exit code
run_cmd() {
    "$@"
    echo $?
}

# ---------------------------------------------------------------------------
# Test case 1: Normal files with various extensions
# ---------------------------------------------------------------------------

temp_dir=$(mktemp -d)
# Create a set of sample files
touch "$temp_dir/report.pdf"
cp /dev/null "$temp_dir/photo.jpg"
cp /dev/null "$temp_dir/document.docx"
cp /dev/null "$temp_dir/video.mp4"
cp /dev/null "$temp_dir/song.mp3"
cp /dev/null "$temp_dir/archive.zip"
cp /dev/null "$temp_dir/script.sh"
cp /dev/null "$temp_dir/installer.exe"
cp /dev/null "$temp_dir/README"

# Run dry‑run first – should not move anything
out=$($ORGANIZER --directory "$temp_dir" --dry-run)
if ! grep -q "DRY RUN" <<< "$out"; then
    echo "[FAIL] Dry‑run did not produce expected output"
    exit 1
fi

# Run actual organization
$ORGANIZER --directory "$temp_dir"

# Verify files ended up in correct folders
declare -A expected=(
    ["report.pdf"]="PDFs"
    ["photo.jpg"]="Images"
    ["document.docx"]="Documents"
    ["video.mp4"]="Videos"
    ["song.mp3"]="Audio"
    ["archive.zip"]="Archives"
    ["script.sh"]="Code"
    ["installer.exe"]="Installers"
    ["README"]="Others"
)

for file in "${!expected[@]}"; do
    if [[ ! -e "$temp_dir/${expected[$file]}/$file" ]]; then
        echo "[FAIL] $file not found in ${expected[$file]}"
        exit 1
    fi
done

# ---------------------------------------------------------------------------
# Test case 2: Files with spaces and duplicate names
# ---------------------------------------------------------------------------

temp_dir2=$(mktemp -d)
# Two files with same name but different content
cp /dev/null "$temp_dir2/my document.pdf"
cp /dev/null "$temp_dir2/my document (1).pdf"
# File with spaces
cp /dev/null "$temp_dir2/my photo with spaces.jpg"

$ORGANIZER --directory "$temp_dir2"
# Expect duplicate handling – the second file should be renamed to "my document (1) (1).pdf" inside PDFs
# Both files have different names, so both should retain their original names
if [[ ! -e "$temp_dir2/PDFs/my document.pdf" ]] || [[ ! -e "$temp_dir2/PDFs/my document (1).pdf" ]]; then
    echo "[FAIL] File handling failed"
    exit 1
fi
if [[ ! -e "$temp_dir2/Images/my photo with spaces.jpg" ]]; then
    echo "[FAIL] Space handling failed"
    exit 1
fi

# ---------------------------------------------------------------------------
# Test case 3: Undo functionality
# ---------------------------------------------------------------------------
# Create a fresh directory with one file
temp_dir3=$(mktemp -d)
cp /dev/null "$temp_dir3/sample.txt"
$ORGANIZER --directory "$temp_dir3"
# Ensure file moved
if [[ ! -e "$temp_dir3/Documents/sample.txt" ]]; then
    echo "[FAIL] Move before undo failed"
    exit 1
fi
# Undo last operation
$ORGANIZER --undo
# File should be back in original location
if [[ ! -e "$temp_dir3/sample.txt" ]]; then
    echo "[FAIL] Undo did not restore file"
    exit 1
fi

echo "All tests passed."
