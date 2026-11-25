#!/usr/bin/env bash

# lib/categories.sh – extension → category mappings
# Declares an associative array "declare -A EXT_TO_CAT" where keys are lower‑case extensions
# and values are the target folder name.

# Bash associative arrays require Bash 4+. Git Bash provides it.

declare -A EXT_TO_CAT=(
    # PDFs
    [pdf]="PDFs"
    # Images
    [jpg]="Images" [jpeg]="Images" [png]="Images" [gif]="Images" [bmp]="Images" [svg]="Images" [webp]="Images"
    # Documents (office)
    [doc]="Documents" [docx]="Documents" [odt]="Documents" [xls]="Documents" [xlsx]="Documents" [ppt]="Documents" [pptx]="Documents" [txt]="Documents" [rtf]="Documents"
    # Videos
    [mp4]="Videos" [mov]="Videos" [avi]="Videos" [mkv]="Videos" [webm]="Videos" [flv]="Videos"
    # Audio
    [mp3]="Audio" [wav]="Audio" [aac]="Audio" [flac]="Audio" [ogg]="Audio"
    # Archives
    [zip]="Archives" [tar]="Archives" [gz]="Archives" [bz2]="Archives" [7z]="Archives" [rar]="Archives"
    # Code (source files)
    [c]="Code" [cpp]="Code" [h]="Code" [hpp]="Code" [py]="Code" [js]="Code" [ts]="Code" [java]="Code" [cs]="Code" [sh]="Code" [rb]="Code" [go]="Code" [rs]="Code"
    # Installers / executables
    [exe]="Installers" [msi]="Installers" [dmg]="Installers" [pkg]="Installers" [deb]="Installers" [rpm]="Installers"
)

# Function: get_category
#   $1 – filename (may contain path, we only need the extension)
#   Echoes the category name or "Others" if not listed.
get_category() {
    local filename="$1"
    local ext="${filename##*.}"
    # If there is no extension or filename ends with a dot, treat as Others
    if [[ "$filename" == "$ext" ]]; then
        echo "Others"
        return
    fi
    ext="${ext,,}"  # lower‑case
    local cat="${EXT_TO_CAT[$ext]}"
    if [[ -z "$cat" ]]; then
        echo "Others"
    else
        echo "$cat"
    fi
}

# Export for subshells (organizer.sh sources this file, so not needed, but kept for completeness)
export -f get_category
