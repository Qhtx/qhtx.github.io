#!/bin/bash

DEBS_DIR="./debs/"
PACKAGES_FILE="Packages"
PACKAGES_OLD="Packages.old"
TEMP_NEW="temp_new"

set -e

[ -f "$PACKAGES_FILE" ] && mv -f "$PACKAGES_FILE" "$PACKAGES_OLD" || touch "$PACKAGES_OLD"

apt-ftparchive packages "$DEBS_DIR" | grep -Ev "^(Depiction|Homepage|Installed-Size|Sileodepiction|Pre-Depends|Recommended|SHA512|SileoDepiction|Tag):" | sed -E 's/^Section: .*/Section: Tweaks/' > "$TEMP_NEW"

mv -f "$TEMP_NEW" "$PACKAGES_FILE"

awk '/Filename:/ {print $2}' "$PACKAGES_OLD" > old_debs_list
awk '/Filename:/ {print $2}' "$PACKAGES_FILE" > new_debs_list

echo "info extracted: MD5sum, Size, SHA1, SHA256 ✅"

grep -Fxv -f old_debs_list new_debs_list | while read -r new_deb; do
    echo "Filename: $new_deb added ✅"
done

rm -f "$PACKAGES_OLD" old_debs_list new_debs_list

echo "✅ Done!"
exit 0