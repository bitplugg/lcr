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
  [1] Install / patch Magisk          (lcr-magisk.sh)
  [2] Reboot to EDL / 9008            (lcr-edl.sh)
  [3] Backup EFS / persist / modem    (lcr-backup-efs.sh)
  [4] Anti-Rollback info              (lcr-arb.sh)
  [5] Device information              (lcr-devinfo.sh)
  [6] List partitions                 (lcr-partitions.sh)
  [7] Kernel / boot image info        (lcr-kernel.sh)
  [8] Flash image to partition        (lcr-flash.sh)
  [9] Remount system/vendor rw        (lcr-mountrw.sh)
 [10] Remove dm-verity / forceencrypt (lcr-verity.sh)
 [11] SELinux mode                    (lcr-selinux.sh)
 [12] Wipe cache / metadata / data    (lcr-wipe.sh)
  [q] Quit
EOF

printf 'Choose an option: '
read -r choice
case "$choice" in
    1)  exec lcr-magisk.sh ;;
    2)  exec lcr-edl.sh ;;
    3)  exec lcr-backup-efs.sh ;;
    4)  exec lcr-arb.sh ;;
    5)  exec lcr-devinfo.sh ;;
    6)  exec lcr-partitions.sh ;;
    7)  exec lcr-kernel.sh ;;
    8)  exec lcr-flash.sh ;;
    9)  exec lcr-mountrw.sh ;;
    10) exec lcr-verity.sh ;;
    11) exec lcr-selinux.sh ;;
    12) exec lcr-wipe.sh ;;
    *)  exit 0 ;;
esac
