#!/system/bin/sh
#
# LCR - Wipe caches / metadata (and optionally data).
#
# Usage: lcr-wipe.sh cache | metadata | data | all
#

PATH=/sbin:/system/bin:/system/xbin:$PATH
export PATH

TARGET="${1:-cache}"

wipe_part() {
    blk="/dev/block/bootdevice/by-name/$1"
    [ -e "$blk" ] || { echo "LCR:   skip $1 (missing)"; return; }
    echo "LCR:   wiping $1 ($blk)"
    dd if=/dev/zero of="$blk" bs=1M count=8 2>/dev/null
    sync
}

echo "LCR: wipe target: $TARGET"
printf "Type YES to confirm: "
read -r ans
[ "$ans" = "YES" ] || { echo "LCR: aborted."; exit 1; }

case "$TARGET" in
    cache)    wipe_part cache; rm -rf /data/dalvik-cache 2>/dev/null ;;
    metadata) wipe_part metadata; wipe_part logdump ;;
    data)     wipe_part userdata ;;
    all)      wipe_part cache; wipe_part metadata; wipe_part logdump; wipe_part userdata ;;
    *) echo "usage: lcr-wipe.sh cache|metadata|data|all"; exit 1 ;;
esac

echo "LCR: done."
exit 0
