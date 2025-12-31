#!/usr/bin/env bash

set -euo pipefail

DIR="$HOME/Pictures/Screenshot"
mkdir -p "$DIR"

# 1. Capture geometry
if ! GEOM=$(slurp -b 00000088 -c ffffffff -w 2); then
    exit 0
fi

FILE="$DIR/$(date +'%Y-%m-%d-%H%M%S_screenshot.png')"

# 2. Take screenshot and pipe to both the file and the clipboard
# The '-' tells grim to output to stdout
# 'tee' writes that output to the $FILE and passes it to wl-copy
grim -g "$GEOM" - | tee "$FILE" | wl-copy -t image/png

# 3. Notify
notify-send \
    "Screenshot Captured" \
    "Saved to $FILE and copied to clipboard" \
    -i camera-photo
