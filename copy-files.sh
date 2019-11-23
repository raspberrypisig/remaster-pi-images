#!/usr/bin/env bash

set -xe

LINUX_DIR=/mnt/remastered
BOOT_DIR=$MOUNT_DIR/boot

mkdir -p $BOOT_DIR

loop_mount_device=$(losetup --show -P -f $REMASTERED_IMAGE)
mount ${loop_mount_device}p2 $LINUX_DIR
mount ${loop_mount_device}p1 $BOOT_DIR  

rsync -av files/ $LINUX_DIR

umount $BOOT_DIR
umount $LINUX_DIR
losetup -D $loop_mount_device

