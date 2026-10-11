#!/system/bin/sh
#
# LCR - Install / patch Magisk into the boot image.
#
# Magisk is bundled inside the LCR ramdisk (in "LCR memory"), so no SD card
# is required. A user-provided zip still wins if given.
#
# Usage: lcr-magisk.sh [/path/to/Magisk.zip]
#

PATH=/sbin:/system/bin:/system/xbin:$PATH
export PATH

BOOT=/dev/block/bootdevice/by-name/boot
WORK=/tmp/lcr-magisk
BUNDLED_APK=/system/etc/lcr/Magisk.apk
BUNDLED_ZIP=/system/etc/lcr/Magisk.zip

ZIP="$1"

if [ -z "$ZIP" ]; then
    for z in "$BUNDLED_ZIP" "$BUNDLED_APK" \
             /sdcard/Magisk*.zip /sdcard/Download/Magisk*.zip /sdcard/Magisk*.apk; do
        [ -e "$z" ] && ZIP="$z" && break
    done
fi

if [ -z "$ZIP" ] || [ ! -e "$ZIP" ]; then
    echo "LCR: no bundled Magisk found and none on /sdcard."
    echo "     usage: lcr-magisk.sh /path/to/Magisk.zip"
    exit 1
fi

echo "LCR: using Magisk package: $ZIP"

rm -rf "$WORK"
mkdir -p "$WORK"
cd "$WORK" || exit 1

if command -v unzip >/dev/null 2>&1; then
    unzip -o "$ZIP" -d "$WORK" >/dev/null
else
    busybox unzip -o "$ZIP" -d "$WORK" >/dev/null
fi

if [ ! -f "$WORK/boot_patch.sh" ]; then
    echo "LCR: boot_patch.sh not found in package. Aborting."
    exit 1
fi

# Magisk's own boot_patch.sh patches the boot image in place.
sh "$WORK/boot_patch.sh" "$BOOT" || exit 1

if [ -f "$WORK/new-boot.img" ]; then
    echo "LCR: flashing patched boot image..."
    dd if="$WORK/new-boot.img" of="$BOOT" bs=1M conv=notrunc || exit 1
    echo "LCR: Magisk applied. Reboot to system to finish setup."
else
    echo "LCR: patched boot image not produced. Aborting."
    exit 1
fi
exit 0
