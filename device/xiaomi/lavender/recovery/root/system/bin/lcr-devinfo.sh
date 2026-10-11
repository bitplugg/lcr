#!/system/bin/sh
#
# LCR - Device information.
#

PATH=/sbin:/system/bin:/system/xbin:$PATH
export PATH

echo "LCR Device Info"
echo "---------------"
echo "device   : $(getprop ro.product.device)"
echo "model    : $(getprop ro.product.model)"
echo "hardware : $(getprop ro.boot.hardware)"
echo "baseband : $(getprop ro.boot.baseband)"
echo "serial   : $(getprop ro.serialno)"
echo "build    : $(getprop ro.build.display.id)"
echo "recovery : $(getprop ro.twrp.version)"
echo
echo "Bootloader / ARB:"
getprop | grep -iE 'arb|rollback|bootloader' 2>/dev/null
exit 0
