#!/system/bin/sh
#
# LCR - List block partitions and sizes.
#

PATH=/sbin:/system/bin:/system/xbin:$PATH
export PATH

BYNAME=/dev/block/bootdevice/by-name
[ -d "$BYNAME" ] || BYNAME=/dev/block/by-name

echo "LCR partitions ($BYNAME):"
for p in "$BYNAME"/*; do
    [ -e "$p" ] || continue
    name=$(basename "$p")
    size=$(blockdev --getsize64 "$p" 2>/dev/null)
    if [ -z "$size" ]; then
        real=$(readlink -f "$p")
        size=$(cat "/sys/class/block/$(basename "$real")/size" 2>/dev/null)
        [ -n "$size" ] && size=$((size * 512))
    fi
    printf "  %-24s %s bytes\n" "$name" "${size:-?}"
done
exit 0
