#!/system/bin/sh
#
# LCR - Backup critical Xiaomi/Qualcomm partitions (EFS, persist, modem, firmware).
# Writes raw images + sha256 checksums to /sdcard/LCR-backups.
#

PATH=/sbin:/system/bin:/system/xbin:$PATH
export PATH

DEST="${1:-/sdcard/LCR-backups}"
mkdir -p "$DEST" || exit 1

echo "LCR: backing up critical partitions to $DEST"
echo "LCR: date: $(date)"

for p in modem modemst1 modemst2 fsg fsc persist; do
    blk="/dev/block/bootdevice/by-name/$p"
    [ -e "$blk" ] || { echo "LCR:   skip $p (missing)"; continue; }
    echo "LCR:   dumping $p ..."
    dd if="$blk" of="$DEST/$p.img" bs=4096 2>/dev/null
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$DEST/$p.img" >> "$DEST/checksums.txt"
    fi
done

sync
echo "LCR: backup complete."
exit 0
