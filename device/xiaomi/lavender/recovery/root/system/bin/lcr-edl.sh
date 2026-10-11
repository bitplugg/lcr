#!/system/bin/sh
#
# LCR - Reboot the device into Qualcomm EDL (9008 / download) mode.
#

PATH=/sbin:/system/bin:/system/xbin:$PATH
export PATH

echo "LCR: rebooting to EDL (9008)..."
sync

if [ -w /sys/module/msm_poweroff/parameters/download_mode ]; then
    echo 1 > /sys/module/msm_poweroff/parameters/download_mode
fi

if [ -w /sys/module/msm_poweroff/parameters/force_download_mode ]; then
    echo 1 > /sys/module/msm_poweroff/parameters/force_download_mode
fi

echo 1 > /proc/sys/kernel/sysrq 2>/dev/null
echo b > /proc/sysrq-trigger 2>/dev/null

reboot edl 2>/dev/null
reboot -f 2>/dev/null
exit 0
