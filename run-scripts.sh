#!/usr/bin/env bash

set -xe

REMASTERED_IMAGE="$1"
ARCH="$2"

apt install -y binfmt-support qemu-user-static
update-binfmts --display

loop_disk_image=$(losetup --show -P -f $REMASTERED_IMAGE)
mount_dir=/mnt/remaster

mkdir -p $mount_dir
mount ${loop_disk_image}p2 $mount_dir

cp /usr/bin/qemu-$ARCH-static ${mount_dir}/usr/bin

for script in `ls scripts\*.sh`
do
  bash $script
done

umount $mount_dir
losetup -D $loop_disk_image