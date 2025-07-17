#!/bin/sh
set -u
set -e
BASEDIR=$(dirname "$0")
echo "apply ${BASEDIR}/cust_inittab to target"
cat ${BASEDIR}/cust_inittab > ${TARGET_DIR}/etc/inittab

echo "cinfig path ${BR2_CONFIG}"
# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi

eval $(grep ^BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW= ${BR2_CONFIG})
if [ "${BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW}" = "y" ]; then
#   "cust remount rootfs rw"
    sed -i -e '/^#.*-o remount,rw \/$/s~^#\+~~' ${TARGET_DIR}/etc/inittab
else
#   "cust do not remount rootfs rw"
    sed -i -e '/^[^#].*-o remount,rw \/$/s~^~#~' ${TARGET_DIR}/etc/inittab
fi

if [ -x ${TARGET_DIR}/sbin/swapon -a -x ${TARGET_DIR}/sbin/swapoff ]; then 
    sed -i -e '/^#.*\/sbin\/swap/s/^#\+[[:blank:]]*//' ${TARGET_DIR}/etc/inittab;
else 
    sed -i -e '/^[^#].*\/sbin\/swap/s/^/#/' ${TARGET_DIR}/etc/inittab;
fi 
