#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 
   exit 1
fi

cd ../../../output/images

rm -f r36s_clone.img

truncate -s 1090M r36s_clone.img
parted r36s_clone.img mktable msdos
dd if=../../../board/myosotis/r36s_clone/uboot.img of=r36s_clone.img bs=512 skip=1 seek=1 count=32767 conv=notrunc

parted r36s_clone.img mkpart primary fat32 32768s 135167s
parted r36s_clone.img mkpart primary ext4 135168s 2232319s
parted r36s_clone.img unit MiB print

DEV_LOOP=$(losetup --show --find --partscan r36s_clone.img)
ls -la "${DEV_LOOP}"*
mkfs.fat -F32 -n BOOT ${DEV_LOOP}p1
mkfs.ext4 -L rootfs ${DEV_LOOP}p2

mkdir -p /mnt/BOOT && mount -t vfat ${DEV_LOOP}p1 /mnt/BOOT
mkdir -p /mnt/rootfs && mount -t ext4 ${DEV_LOOP}p2 /mnt/rootfs

tar -xJf ../../../board/myosotis/r36s_clone/BOOT.tar.xz -C /mnt/BOOT --no-same-owner
tar -xf rootfs.tar -C /mnt/rootfs --no-same-owner
sync

umount /mnt/BOOT
umount /mnt/rootfs
losetup --detach-all

cd ../../../board/myosotis/r36s_clone

echo "Done."
