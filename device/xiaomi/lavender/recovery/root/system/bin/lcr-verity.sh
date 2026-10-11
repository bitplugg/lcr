#!/system/bin/sh
#
# LCR - Remove dm-verity / forceencrypt from vendor fstab and (optionally)
#       the boot ramdisk fstab, so the device can boot modified images.
#
# Usage: lcr-verity.sh            -> patch vendor fstab only
#        lcr-verity.sh boot       -> also patch the boot ramdisk fstab
#

PATH=/sbin:/system/bin:/system/xbin:$PATH
export PATH

DO_BOOT="$1"
TMP=/tmp/lcr-verity

strip() {
    sed -i \
        -e 's/,avb=[^, ]*//g' \
        -e 's/,avb//g' \
        -e 's/,forceencrypt=[^, ]*//g' \
        -e 's/,forcefdeorfbe=[^, ]*//g' \
        -e 's/,fileencryption=[^, ]*//g' \
        -e 's/,encryptable=[^, ]*//g' \
        "$1" 2>/dev/null
}

echo "LCR: removing dm-verity / forceencrypt..."

mount -o remount,rw /vendor 2>/dev/null
for f in /vendor/etc/fstab.qcom /vendor/etc/fstab.default; do
    [ -f "$f" ] || continue
    cp -f "$f" "$f.lcr.bak" 2>/dev/null
    strip "$f"
    echo "LCR: patched $f (backup: $f.lcr.bak)"
done

if [ "$DO_BOOT" = "boot" ]; then
    BOOT=/dev/block/bootdevice/by-name/boot
    rm -rf "$TMP"; mkdir -p "$TMP"; cd "$TMP" || exit 1
    dd if="$BOOT" of=boot.img bs=1M 2>/dev/null
    if command -v magiskboot >/dev/null 2>&1 && magiskboot unpack boot.img >/dev/null 2>&1; then
        if [ -f ramdisk.cpio ]; then
            mkdir ramdisk && cd ramdisk
            magiskboot cpio ../ramdisk.cpio "extract" 2>/dev/null
            found=0
            for f in $(find . -name 'fstab*' -type f 2>/dev/null); do
                strip "$f"
                p=${f#./}
                magiskboot cpio ../ramdisk.cpio "add 0644 $p $f" 2>/dev/null
                echo "LCR: patched ramdisk $p"
                found=1
            done
            cd ..
            if [ "$found" = "1" ] && magiskboot repack boot.img new-boot.img >/dev/null 2>&1; then
                dd if=new-boot.img of="$BOOT" bs=1M conv=notrunc
                echo "LCR: boot ramdisk patched and flashed."
            fi
        fi
    else
        echo "LCR: magiskboot unavailable, skipped boot ramdisk patch."
    fi
fi

sync
echo "LCR: done."
exit 0
