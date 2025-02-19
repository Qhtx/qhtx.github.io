PACKAGES_FILE="Packages"
TEMP_FILE="Packages_temp"

if ! grep -q "^Section:" "$PACKAGES_FILE"; then
    sed -i "1i Section: Tweaks" "$PACKAGES_FILE"
else
    sed -i "s/^Section:.*/Section: Tweaks/" "$PACKAGES_FILE"
fi