#!/system/bin/sh
#
# LCR (Lavender Custom Recovery) - tool menu
#

PATH=/sbin:/system/bin:/system/xbin:$PATH
export PATH

if command -v lcr-banner.sh >/dev/null 2>&1; then
    lcr-banner.sh
fi

cat <<'EOF'
 LCR Tools
 ---------
 [1] Install / patch Magisk      -> lcr-magisk.sh <Magisk.zip>
 [2] Reboot to EDL (9008)        -> lcr-edl.sh
 [3] Backup EFS / persist        -> lcr-backup-efs.sh
 [4] Anti-Rollback info          -> lcr-arb.sh
 [5] Device information          -> lcr-devinfo.sh
 [q] Quit
EOF

printf 'Choose an option: '
read -r choice
case "$choice" in
    1) exec lcr-magisk.sh ;;
    2) exec lcr-edl.sh ;;
    3) exec lcr-backup-efs.sh ;;
    4) exec lcr-arb.sh ;;
    5) exec lcr-devinfo.sh ;;
    *) exit 0 ;;
esac
