PACKAGES_FILE="Packages"
ICON_URL="https://api.linkjar.co/open/adad7be4-fb8a-4b70-89a7-c5cb7cc7edf4"
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