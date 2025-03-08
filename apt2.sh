#!/bin/bash

BASE_DIR="./debs"
OUTPUT_FILE="Packages"
RELEASE_FILE="Release"
DATE=$(date -Ru)
ARCHS=("arm" "arm64" "arm64e")

for deb in "$BASE_DIR"/*.deb; do
    [ -e "$deb" ] || continue

    name=$(dpkg-deb -f "$deb" Name | tr -d '[:space:]')
    version=$(dpkg-deb -f "$deb" Version | tr -d '[:space:]')
    arch=$(dpkg-deb -f "$deb" Architecture | sed 's/^iphoneos-//' | tr -d '[:space:]')

    new_name="${name}.${version}.${arch}.deb"
    new_path="$BASE_DIR/$arch/$new_name"

    if [ ! -f "$new_path" ]; then
        mv "$deb" "$new_path"
    fi
done

for ARCH in "${ARCHS[@]}"; do
    DEBS_DIR="$BASE_DIR/$ARCH"
    if [ -d "$DEBS_DIR" ]; then
        apt-ftparchive packages "$DEBS_DIR" > "$DEBS_DIR/Packages"
    fi
done

cat > "$RELEASE_FILE" <<EOF
Origin:  ‏​‏  Λ7M | Repo
Label:  ‏​‏  Λ7M | Repo
Suite: stable
Version: 1.0
Codename:  ‏​‏  Λ7M | Repo
Architectures: ${ARCHS[*]}
Components: main
Description: rootful & rootless & roothide
Icon: https://a7m.dev/CydiaIcon.png
Date: $DATE
EOF

echo -e "\nMD5Sum:" >> "$RELEASE_FILE"
find "$BASE_DIR" -type f -name "Packages*" -exec md5sum {} + | awk '{print $1, length($2), $2}' >> "$RELEASE_FILE"

echo -e "\nSHA1:" >> "$RELEASE_FILE"
find "$BASE_DIR" -type f -name "Packages*" -exec sha1sum {} + | awk '{print $1, length($2), $2}' >> "$RELEASE_FILE"

echo -e "\nSHA256:" >> "$RELEASE_FILE"
find "$BASE_DIR" -type f -name "Packages*" -exec sha256sum {} + | awk '{print $1, length($2), $2}' >> "$RELEASE_FILE"

echo -e "\nSHA512:" >> "$RELEASE_FILE"
find "$BASE_DIR" -type f -name "Packages*" -exec sha512sum {} + | awk '{print $1, length($2), $2}' >> "$RELEASE_FILE"

echo "✅ Repository updated successfully!"