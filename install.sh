#!/bin/bash
# Default to $HOME/sm64coopdx/mods if SM64COOPDX_MODS_DIR is not set
MODS_DIR="${SM64COOPDX_MODS_DIR:-$HOME/sm64coopdx/mods}/honorable-mentions"

# Create the mods directory if it doesn't exist
mkdir -p "$MODS_DIR"

# Copy mod files to the mods directory
if [ -d "honorable-mentions" ]; then
    cp -r honorable-mentions/* "$MODS_DIR"
    echo "Installed mod to $MODS_DIR"
else
    echo "Error: 'honorable-mentions' folder not found in the current directory"
    exit 1
fi
