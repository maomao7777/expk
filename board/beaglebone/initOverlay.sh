#!/bin/sh
READFILE="/etc/fwtool.conf"
# ROOT_PART will be replaced in Makefile
ROOT_PART=/dev/mmcblk0p3

INIT_NET_FILE="/storage/initnet"
TARGET_LINK="/etc/init.d/S40network"

start() {
printf 'Starting init storage overlay'
mount -o remount,ro /
# FIXME: dumpe2fs is only for ext2/3/4
#        replace dumpe2fs if data partition
#        is not ext2/3/4
dumpe2fs -b $ROOT_PART > /dev/zero 2>&1

# The missing mtab message is hidden because it is still not generated at this stage
if [ $? != 0 ]; then
        # Format data partition
        mkfs.ext4 $ROOT_PART > /dev/zero 2>&1
        fsck -f -y ${ROOT_PART} > /dev/null 2>&1 | grep -v "missing mtab file"
else
        # Always check if partition is health
        # Auto repair if partition is bad
        fsck -y ${ROOT_PART} > /dev/null 2>&1 | grep -v "missing mtab file"
fi

mount $ROOT_PART /storage

# Run overlayfs
rm -rf /storage/overlayfs/
while read DIR; do
        if [ x"${DIR:0:1}" != x"#" ]&&[ x"${DIR:0:1}" != x"" ] ; then
                UPPER_DIR=/storage/overlayfs${DIR}_rw/upper
                WORK_DIR=/storage/overlayfs${DIR}_rw/work
                mkdir -p ${UPPER_DIR}
                mkdir -p ${WORK_DIR}
                OPTS="-o lowerdir=${DIR},upperdir=${UPPER_DIR},workdir=${WORK_DIR}"
                /bin/mount -t overlay ${OPTS} overlay ${DIR}
        fi
done < $READFILE


if [ -f "$INIT_NET_FILE" ]; then
    
    if [ -e "$TARGET_LINK" ]; then
        rm -f "$TARGET_LINK"
        echo "Removed existing $TARGET_LINK."
    fi
    ln -s "$INIT_NET_FILE" "$TARGET_LINK"
    echo "Linked $INIT_NET_FILE to $TARGET_LINK."
else
    echo "$INIT_NET_FILE does not exist."
fi

}


case "$1" in
        start)
        "$1"
        ;;
        stop)
	echo "no uninitOverlay "
	;;
        restart|reload)
	echo "no uninitOverlay "
	;;
        *)
        exit 1
esac
