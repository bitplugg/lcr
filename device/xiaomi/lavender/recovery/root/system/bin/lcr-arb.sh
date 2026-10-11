#!/system/bin/sh
#
# LCR - Anti-Rollback (ARB) information and management.
#
# Usage:
#   lcr-arb.sh            -> dump current ARB index from misc
#   lcr-arb.sh dump       -> dump current ARB index from misc
#   lcr-arb.sh backup     -> back up misc to /sdcard/LCR-backups
#   lcr-arb.sh clear      -> zero the ARB index in misc  (DANGEROUS, own risk)
#

PATH=/sbin:/system/bin:/system/xbin:$PATH
export PATH

MISC=/dev/block/bootdevice/by-name/misc
DEST=/sdcard/LCR-backups
ACTION="${1:-dump}"

if [ ! -e "$MISC" ]; then
    echo "LCR: misc partition not found."
    exit 1
fi

mkdir -p "$DEST"

case "$ACTION" in
    dump)
        echo "LCR: ARB / misc header (first 64 bytes):"
        dd if="$MISC" bs=1 count=64 2>/dev/null | od -An -tx1
        ;;
    backup)
        echo "LCR: backing up misc -> $DEST/misc.img"
        dd if="$MISC" of="$DEST/misc.img" bs=4096 2>/dev/null
        sync
        echo "LCR: done."
        ;;
    clear)
        echo "LCR: !!! zeroing ARB index in misc (own risk) !!!"
        dd if="$DEST/misc.img" of="$MISC" bs=1M 2>/dev/null
        printf '\0\0\0\0\0\0\0\0' | dd of="$MISC" bs=1 seek=0 conv=notrunc 2>/dev/null
        sync
        echo "LCR: ARB index cleared."
        ;;
    *)
        echo "usage: lcr-arb.sh [dump|backup|clear]"
        exit 1
        ;;
esac
exit 0
