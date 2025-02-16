DEBS_DIR="./debs"
PACKAGES_FILE="Packages"

apt-ftparchive packages "$DEBS_DIR" > "$PACKAGES_FILE"
sed -i '/Section: /a Header: https:\/\/i.imgur.com\/ffTbQHi.jpeg' "$PACKAGES_FILE"