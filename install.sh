#!/bin/bash
MODS_DIR="/home/sm64sock/sm64coopdx/mods/honorable-mentions"
mkdir -p "$MODS_DIR"
cp -r honorable-mentions/* "$MODS_DIR"
echo "Installed to $MODS_DIR"
