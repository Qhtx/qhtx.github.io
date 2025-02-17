PACKAGES_FILE="Packages"
ICON_URL="https://i.imgur.com/VAEwLFR.jpeg"
TEMP_FILE="Packages_temp"

awk -v icon="$ICON_URL" '
/^Filename:/ {
    print $0
    getline nextLine
    if (nextLine !~ /^Icon:/) {
        print "Icon: " icon
    }
    print nextLine
    next
}
{ print }
' "$PACKAGES_FILE" > "$TEMP_FILE"

mv "$TEMP_FILE" "$PACKAGES_FILE"