#!/bin/bash

# Meaningful aliases for arguments:
path="$1"            # Full path of the selected file
width="$2"           # Width of the preview pane (number of fitting characters)
height="$3"          # Height of the preview pane (number of fitting characters)

# Find out something about the file:
mimetype=$(file --mime-type -Lb "$path")
extension=$(/bin/echo "${path##*.}" | awk '{print tolower($0)}')

# Functions:
# runs a command and saves its output into $output.  Useful if you need
# the return value AND want to use the output in a pipe
try() { output=$(eval '"$@"'); }

# writes the output of the previously used "try" command
dump() { cat <<< "$output"; }

# a common post-processing function used after most commands
trim() { head -n "$height"; }

# Skip previews on dirs mounted through sshfs
if [[ "$path" == "$HOME/mnt/"* ]]; then
    exit 0
fi

case "$extension" in
    # Archive extensions:
    a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
    rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
        try bsdtar -tf "$path" && { dump | trim; exit 0; }
        exit 0
        ;;
    rar)
        # avoid password prompt by providing empty password
        try unrar -p- lt "$path" && { dump | trim; exit 0; }
        exit 0
        ;;
    7z)
        # avoid password prompt by providing empty password
        try 7z -p l "$path" && { dump | trim; exit 0; }
        exit 0
        ;;
    # PDF documents:
    pdf)
        try pdftotext -l 10 -nopgbrk -q "$path" - && { dump | trim | fmt -s -w $width; exit 0; }
        exit 0
        ;;
    # ODT Files
    odt|ods|odp|sxw)
        try odt2txt "$path" && { dump | trim; exit 5; }
        exit 0
        ;;
    # HTML Pages:
    htm|html|xhtml)
        try w3m    -dump "$path" && { dump | trim | fmt -s -w $width; exit 0; }
        try lynx   -dump "$path" && { dump | trim | fmt -s -w $width; exit 0; }
        try elinks -dump "$path" && { dump | trim | fmt -s -w $width; exit 0; }
        ;; # fall back to highlight/cat if the text browsers fail
    # disable preview of VTK files
    vtk|vtu|vti)
        exit 0
        ;;
    # disable highlighting of subtitles
    srt|sub)
        exit 0
        ;;
esac

case "$mimetype" in
    # Syntax highlight for text files:
    text/* | */xml)
        try bat --paging=never --style=numbers --terminal-width $(($width-5)) -f "$path" \
            && { dump | trim; exit 0; }
        ;;
    # Display information about media files:
    video/* | audio/*)
        exiftool "$path"
        ;;
esac
