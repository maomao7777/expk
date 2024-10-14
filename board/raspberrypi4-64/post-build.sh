#!/bin/sh
BASEDIR=$(dirname "$0")

set -u
set -e
rm -rf ${TARGET_DIR}/storage
mkdir ${TARGET_DIR}/storage
install ${BASEDIR}/fwtool.conf  ${TARGET_DIR}/etc/
install ${BASEDIR}/fwupd.sh  ${TARGET_DIR}/etc/
install ${BASEDIR}/initOverlay.sh  ${TARGET_DIR}/etc/init.d/S00initOverlay
install ${BASEDIR}/initNetconf.sh  ${TARGET_DIR}/etc/init.d/S40network

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    if grep -q '^[^#]*::shutdown:/bin/umount -a -r' ${TARGET_DIR}/etc/inittab && 
        ! grep -q '^[^#]*::shutdown:/bin/umount -a -r -f' ${TARGET_DIR}/etc/inittab; then
    sed -i 's|::shutdown:/bin/umount -a -r|::shutdown:/bin/umount -a -r -f|' ${TARGET_DIR}/etc/inittab
    echo "instead '::shutdown:/bin/umount -a -r' to '::shutdown:/bin/umount -a -r -f' in ${TARGET_DIR}/etc/inittab"
    fi
fi

current_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "build time: $current_time" > ${TARGET_DIR}/etc/rversion
