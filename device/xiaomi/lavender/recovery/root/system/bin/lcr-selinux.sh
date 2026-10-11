#!/system/bin/sh
#
# LCR - Show / set SELinux mode (recovery is usually permissive already).
#
# Usage: lcr-selinux.sh [enforcing|permissive|status]
#

PATH=/sbin:/system/bin:/system/xbin:$PATH
export PATH

ACTION="${1:-status}"

case "$ACTION" in
    status)
        echo "LCR: SELinux: $(getenforce 2>/dev/null || cat /sys/fs/selinux/enforce 2>/dev/null)"
        ;;
    permissive|0)
        setenforce 0 2>/dev/null
        [ -w /sys/fs/selinux/enforce ] && echo 0 > /sys/fs/selinux/enforce
        echo "LCR: SELinux -> permissive ($(getenforce 2>/dev/null))"
        ;;
    enforcing|1)
        setenforce 1 2>/dev/null
        [ -w /sys/fs/selinux/enforce ] && echo 1 > /sys/fs/selinux/enforce
        echo "LCR: SELinux -> enforcing ($(getenforce 2>/dev/null))"
        ;;
    *)
        echo "usage: lcr-selinux.sh [enforcing|permissive|status]"
        exit 1
        ;;
esac
exit 0
