#!/bin/sh
BASEDIR=$(dirname "$0")

set -u
set -e
rm -rf ${TARGET_DIR}/storage
mkdir ${TARGET_DIR}/storage
install ${BASEDIR}/fwtool.conf  ${TARGET_DIR}/etc/
install ${BASEDIR}/initOverlay.sh  ${TARGET_DIR}/etc/init.d/S00initOverlay.sh
# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    sed -i -e '/^[^#].*\/bin\/umount/s/^/#/' ${TARGET_DIR}/etc/inittab
    echo "::shutdown:/bin/umount -a -f -r" >> ${TARGET_DIR}/etc/inittab
fi
