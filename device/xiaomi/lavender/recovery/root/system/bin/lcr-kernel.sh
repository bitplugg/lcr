#!/system/bin/sh
#
# LCR - Inspect the boot image with magiskboot (kernel / ramdisk / dtb info).
#
# Usage: lcr-kernel.sh [/dev/block/.../boot]
#

PATH=/sbin:/system/bin:/system/xbin:$PATH
export PATH

BOOT="${1:-/dev/block/bootdevice/by-name/boot}"
TMP=/tmp/lcr-kernel

if [ ! -e "$BOOT" ]; then
    echo "LCR: boot partition not found: $BOOT"
    exit 1
fi

rm -rf "$TMP"; mkdir -p "$TMP"; cd "$TMP" || exit 1
echo "LCR: dumping $BOOT..."
dd if="$BOOT" of=boot.img bs=1M 2>/dev/null

if ! command -v magiskboot >/dev/null 2>&1; then
    echo "LCR: magiskboot not available, showing header bytes:"
    hexdump -C boot.img 2>/dev/null | head -4
    exit 0
fi

echo "LCR: magiskboot unpack:"
magiskboot unpack boot.img
echo "LCR: files:"
ls -l
if [ -f ramdisk.cpio ]; then
    echo "LCR: ramdisk entries (first 40):"
    magiskboot cpio ramdisk.cpio "ls" 2>/dev/null | head -40
fi
exit 0
