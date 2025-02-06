#!/bin/sh

IMG_FILE=""
BOOT_SIZE=32
ROOTFS_SIZE=120

boot_img="/tmp/boot.vfat"
rootfs_img="/tmp/rootfs.ext2"
mnt_dir="/tmp/mntbootlo"
cmdline_file="$mnt_dir/extlinux/extlinux.conf"
root_param=$(grep -o 'root=/dev/mmcblk0p[23]' /proc/cmdline)

#down all netif
for interface in $(ifconfig | grep '^[a-zA-Z]' | awk '{print $1}'); do
    echo "Bringing down interface: $interface"
    ifconfig "$interface" down
done

echo "All interfaces are down."

while getopts "i:" opt; do
  case $opt in
    i)
      IMG_FILE="$OPTARG"
      ;;
    *)
      echo "Usage: $0 -i <img_file>"
      exit 1
      ;;
  esac
done

# check img is inputed
if [ -z "$IMG_FILE" ]; then
  echo "Error: You must specify an img file with -i"
  exit 1
fi

# chek if fw exist
if [ ! -f "$IMG_FILE" ]; then
  echo "Error: The file '$IMG_FILE' does not exist."
  exit 1
fi

# take boot.vfat and rootfs.ext2 from rom
dd if="$IMG_FILE" of="$boot_img" bs=1M count=$BOOT_SIZE
dd if="$IMG_FILE" of="$rootfs_img" bs=1M skip=$BOOT_SIZE count=$ROOTFS_SIZE
# update boot.vfat bootpart for dual rootfs
mkdir -p "$mnt_dir"
mount -o loop "$boot_img" "$mnt_dir"
if [ "$root_param" = "root=/dev/mmcblk0p2" ]; then
    sed -i 's|root=/dev/mmcblk0p2|root=/dev/mmcblk0p3|' "$cmdline_file"
    echo "change rootfs to /dev/mmcblk0p3"
else
    sed -i 's|root=/dev/mmcblk0p3|root=/dev/mmcblk0p2|' "$cmdline_file"
    echo "change rootfs -> /dev/mmcblk0p2"
fi
echo "-------------------------------------------"
echo "extlinux.conf update :"
echo "$(cat $cmdline_file)"
echo "-------------------------------------------"
umount "$mnt_dir"
rmdir "$mnt_dir"

#busybox unint script
#sh /etc/init.d/rcK
#umount -a -r -f
/bin/busybox sleep 1

# write boot partition
dd if="$boot_img" of=/dev/mmcblk0p1 bs=2M conv=fsync
# write dual rootfs partition
if [ "$root_param" = "root=/dev/mmcblk0p2" ]; then
    dd if="$rootfs_img" of=/dev/mmcblk0p3 bs=2M conv=fsync
else
    dd if="$rootfs_img" of=/dev/mmcblk0p2 bs=2M conv=fsync
fi

echo "fwup finished...reboot !!"
/bin/busybox sleep 1
/bin/busybox reboot
