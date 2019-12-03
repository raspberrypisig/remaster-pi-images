#!/usr/bin/env bash

set -xe

REMASTERED_IMAGE="$1"
ARCH="$2"

apt install -y binfmt-support qemu qemu-user-static systemd-container
update-binfmts --display

loop_disk_image=$(losetup --show -P -f $REMASTERED_IMAGE)
mount_dir=/mnt/remaster


mkdir -p $mount_dir/boot
mount ${loop_disk_image}p2 $mount_dir
mount ${loop_disk_image}p1 $mount_dir/boot

#cp /usr/bin/qemu-$ARCH-static ${mount_dir}/usr/bin/qemu-$ARCH-static
mkdir -p $mount_dir/scripts
mount --bind scripts $mount_dir/scripts


mv $mount_dir/etc/ld.so.preload $mount_dir/etc/ld.so.preload.bak
touch $mount_dir/etc/ld.so.preload

for script in `ls scripts/*.sh`
do
  systemd-nspawn -D $mount_dir /$script
done

umount $mount_dir/scripts
rmdir $mount_dir/scripts
#rm $mount_dir/usr/bin/qemu-$ARCH-static
mv $mount_dir/etc/ld.so.preload.bak $mount_dir/etc/ld.so.preload 
umount $mount_dir/boot
umount $mount_dir
losetup -D $loop_disk_image
