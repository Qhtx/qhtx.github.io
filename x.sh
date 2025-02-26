#!/bin/bash

DEBS_DIR="./debs"
PACKAGES_FILE="Packages"
TEMP_FILE="Packages_temp"
DEFAULT_ICON="Icon: https://i.imgur.com/sg9zr2N.jpeg"

[ -f "$PACKAGES_FILE" ] || touch "$PACKAGES_FILE"

> "$TEMP_FILE"

ARCH_DIRS=("arm" "arm64" "arm64e")

for arch in "${ARCH_DIRS[@]}"; do
    if [ -d "$DEBS_DIR/$arch" ]; then
        for deb in "$DEBS_DIR/$arch"/*.deb; do
            [ -f "$deb" ] || continue

            if grep -q "$(basename "$deb")" "$PACKAGES_FILE"; then
                echo "تمت معالجة $deb مسبقًا. تخطي..."
                continue
            fi

            apt-ftparchive packages "$deb" >> "$TEMP_FILE"
        done
    fi
done

cat "$PACKAGES_FILE" "$TEMP_FILE" > "$PACKAGES_FILE.tmp"
mv "$PACKAGES_FILE.tmp" "$PACKAGES_FILE"
rm -f "$TEMP_FILE"

awk -v default_icon="$DEFAULT_ICON" '
BEGIN { RS=""; FS="\n" }
{
    has_icon = 0
    new_package = ""

    for (i=1; i<=NF; i++) {
        if ($i ~ /^Icon:/) {
            has_icon = 1
        }
        new_package = new_package $i "\n"
    }

    if (!has_icon) {
        new_package = new_package default_icon "\n"
    }

    print new_package
}
' "$PACKAGES_FILE" > "$TEMP_FILE"

mv "$TEMP_FILE" "$PACKAGES_FILE"

exit 0