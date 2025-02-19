#!/bin/bash

DEBS_DIR="./debs"
PACKAGES_FILE="Packages"
ICON_URL="https://i.imgur.com/QiQF4Gl.jpeg"
HEADER_URL="https://i.imgur.com/vrj6wpD.jpeg"
TEMP_FILE="Packages_temp"

apt-ftparchive packages "$DEBS_DIR" > "$PACKAGES_FILE"

sed -i "/Section: /c\Section: Tweaks" "$PACKAGES_FILE"
sed -i "/Section: Tweaks/a Header: $HEADER_URL" "$PACKAGES_FILE"

awk -v icon="$ICON_URL" '
/^Header:/ {
    print $0
    print "Icon: " icon
    next
}
/^(SHA512|dev|Sponsor|Recommended|Installed-Size|Homepage|Depiction|Tag|SileoDepiction|ModernDepiction):/ {
    next
}
{ print }
' "$PACKAGES_FILE" > "$TEMP_FILE"

mv "$TEMP_FILE" "$PACKAGES_FILE"