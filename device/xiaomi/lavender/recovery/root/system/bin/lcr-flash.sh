#!/system/bin/sh
#
# LCR - Flash a raw image to a partition.
#
# Usage: lcr-flash.sh <image-file> <partition-name>
#   e.g. lcr-flash.sh /sdcard/boot.img boot
#

PATH=/sbin:/system/bin:/system/xbin:$PATH
export PATH

IMG="$1"
PART="$2"

if [ -z "$IMG" ] || [ -z "$PART" ] || [ ! -e "$IMG" ]; then
    echo "usage: lcr-flash.sh <image-file> <partition-name>"
    echo "partitions: $(ls /dev/block/bootdevice/by-name | tr '\n' ' ')"
    exit 1
fi

BLK="/dev/block/bootdevice/by-name/$PART"
if [ ! -e "$BLK" ]; then
    echo "LCR: partition '$PART' not found."
    exit 1
fi

echo "LCR: about to flash:"
echo "     image     : $IMG"
echo "     partition : $PART ($BLK)"
printf "Type YES to confirm: "
read -r ans
[ "$ans" = "YES" ] || { echo "LCR: aborted."; exit 1; }

echo "LCR: flashing..."
dd if="$IMG" of="$BLK" bs=1M conv=notrunc || exit 1
sync
echo "LCR: done."
exit 0
