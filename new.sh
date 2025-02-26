#!/bin/bash

BASE_DIR="./debs"
OUTPUT_FILE="Packages"
TEMP_FILE="Packages_temp"
ARCHS=("arm" "arm64" "arm64e")

> "$TEMP_FILE"

for ARCH in "${ARCHS[@]}"; do
    DEBS_DIR="$BASE_DIR/$ARCH"

    if [ -d "$DEBS_DIR" ]; then
        apt-ftparchive packages "$DEBS_DIR" >> "$TEMP_FILE"
    fi
done

if [ -s "$TEMP_FILE" ]; then
    mv "$TEMP_FILE" "$OUTPUT_FILE"
    gzip -fk "$OUTPUT_FILE"
else
    rm "$TEMP_FILE"
fi