#!/bin/bash

BASE_DIR="./debs"
OUTPUT_FILE="Packages"
TEMP_FILE="Packages_temp"
ARCHS=("arm" "arm64" "arm64e")

for ARCH in "${ARCHS[@]}"; do
    mkdir -p "$BASE_DIR/$ARCH"
done

for deb in "$BASE_DIR"/*.deb; do
    [ -e "$deb" ] || continue

    name=$(dpkg-deb -f "$deb" Name | sed 's/[[:space:]]//g')
    version=$(dpkg-deb -f "$deb" Version | sed 's/[[:space:]]//g')
    arch=$(dpkg-deb -f "$deb" Architecture | sed 's/^iphoneos-//')

    new_name="${name}.${version}.${arch}.deb"
    new_path="$BASE_DIR/$new_name"

    mv "$deb" "$new_path"

    case "$arch" in
        arm)
            mv "$new_path" "$BASE_DIR/arm/"
            ;;
        arm64)
            mv "$new_path" "$BASE_DIR/arm64/"
            ;;
        arm64e)
            mv "$new_path" "$BASE_DIR/arm64e/"
            ;;
    esac
done

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
    zstd -qf --ultra -22 "$OUTPUT_FILE"
else
    rm "$TEMP_FILE"
fi