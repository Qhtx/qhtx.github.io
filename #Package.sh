DEBS_DIR="./debs"
PACKAGES_FILE="Packages"

apt-ftparchive packages "$DEBS_DIR" > "$PACKAGES_FILE"