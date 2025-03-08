#!/bin/bash

BASE_DIR="./debs"
RELEASE_FILE="Release"
DATE=$(date -Ru)
ARCHS=("arm" "arm64" "arm64e")

> "Packages"

for ARCH in "${ARCHS[@]}"; do
    DEBS_DIR="$BASE_DIR/$ARCH"
    if [ -d "$DEBS_DIR" ] && [ "$(ls -A "$DEBS_DIR")" ]; then
        apt-ftparchive packages "$DEBS_DIR" > "$DEBS_DIR/Packages"
        cat "$DEBS_DIR/Packages" >> "Packages"
    fi
done

cat > "$RELEASE_FILE" <<EOF
Origin:  ‏​‏Λ7M | Repo
Label:  ‏​‏Λ7M | Repo
Suite: stable
Version: 1.0
Codename:  ‏​‏Λ7M | Repo
Architectures: ${ARCHS[*]}
Components: main
Description: rootful & rootless & roothide
Icon: https://a7m.dev/CydiaIcon.png
Date: $DATE
EOF

echo -e "\nMD5Sum:" >> "$RELEASE_FILE"
find . -maxdepth 1 -type f -name "Packages*" -exec md5sum {} + | awk '{print $1, length($2), $2}' >> "$RELEASE_FILE"

echo -e "\nSHA1:" >> "$RELEASE_FILE"
find . -maxdepth 1 -type f -name "Packages*" -exec sha1sum {} + | awk '{print $1, length($2), $2}' >> "$RELEASE_FILE"

echo -e "\nSHA256:" >> "$RELEASE_FILE"
find . -maxdepth 1 -type f -name "Packages*" -exec sha256sum {} + | awk '{print $1, length($2), $2}' >> "$RELEASE_FILE"

echo -e "\nSHA512:" >> "$RELEASE_FILE"
find . -maxdepth 1 -type f -name "Packages*" -exec sha512sum {} + | awk '{print $1, length($2), $2}' >> "$RELEASE_FILE"

echo "✅ Repository updated successfully!"