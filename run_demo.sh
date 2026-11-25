#!/usr/bin/env bash
set -euo pipefail

# Change to the directory where this script lives (project root)
cd "$(dirname "${BASH_SOURCE[0]}")"

# Create demo files
mkdir -p demo
touch demo/report.pdf demo/photo.jpg demo/script.sh demo/archive.zip demo/music.mp3 "demo/file with spaces.txt"

# Run the organizer in dry‑run mode
./src/organizer.sh --directory "$(pwd)/demo" --dry-run
