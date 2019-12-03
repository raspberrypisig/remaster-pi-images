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
mount --bind private $mount_dir/private

#mv $mount_dir/etc/ld.so.preload $mount_dir/etc/ld.so.preload.bak
#touch $mount_dir/etc/ld.so.preload

pip3 install chevron

for script in `ls private/{pre,post}-scripts/*.mustache 2>/dev/null||true`
do
  newfile=$(echo $script|sed  's/.mustache$/.sh/')
  python3 render-template.py $script $newfile
done

for script in `ls private/pre-scripts/*.sh  scripts/*.sh private/post-scripts/*.sh||true`
do
  systemd-nspawn -D $mount_dir /$script
done

umount $mount_dir/scripts
rmdir $mount_dir/scripts
umount $mount_dir/private
rmdir $mount_dir/private
#rm $mount_dir/usr/bin/qemu-$ARCH-static
#mv $mount_dir/etc/ld.so.preload.bak $mount_dir/etc/ld.so.preload 
umount $mount_dir/boot
umount $mount_dir
losetup -D $loop_disk_image
