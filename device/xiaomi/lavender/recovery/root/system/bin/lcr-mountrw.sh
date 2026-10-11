#!/system/bin/sh
#
# LCR - Remount system / vendor / root read-write (in recovery).
#

PATH=/sbin:/system/bin:/system/xbin:$PATH
export PATH

for mp in / /system /vendor /product /odm; do
    [ -d "$mp" ] || continue
    mount -o remount,rw "$mp" 2>/dev/null && echo "LCR:   rw  $mp" || echo "LCR:   --  $mp (not mounted/rw)"
done
exit 0
