#!/bin/bash

BASE_DIR="./debs"
OUTPUT_FILE="Packages"
TEMP_FILE="Packages_temp"
ARCHS=("arm" "arm64" "arm64e")

# إنشاء المجلدات إذا لم تكن موجودة
for ARCH in "${ARCHS[@]}"; do
    mkdir -p "$BASE_DIR/$ARCH"
done

# نقل الملفات بناءً على المعمارية
for deb in "$BASE_DIR"/*.deb; do
    [ -e "$deb" ] || continue  # تخطي إذا لم يكن هناك ملفات

    # استخراج المعمارية من الملف
    arch=$(dpkg-deb -f "$deb" Architecture | sed 's/^iphoneos-//')

    # التحقق من المعمارية ونقل الملف إلى المجلد المناسب
    case "$arch" in
        arm)
            mv "$deb" "$BASE_DIR/arm/"
            ;;
        arm64)
            mv "$deb" "$BASE_DIR/arm64/"
            ;;
        arm64e)
            mv "$deb" "$BASE_DIR/arm64e/"
            ;;
        *)
            echo "معمارية غير معروفة: $arch"
            ;;
    esac
done

# إنشاء ملف Packages
> "$TEMP_FILE"

for ARCH in "${ARCHS[@]}"; do
    DEBS_DIR="$BASE_DIR/$ARCH"

    if [ -d "$DEBS_DIR" ]; then
        apt-ftparchive packages "$DEBS_DIR" >> "$TEMP_FILE"
    fi
done

if [ -s "$TEMP_FILE" ]; then
    mv "$TEMP_FILE" "$OUTPUT_FILE"
    gzip -fk "$OUTPUT_FILE"
else
    rm "$TEMP_FILE"
fi