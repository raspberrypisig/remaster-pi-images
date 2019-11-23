#!/usr/bin/env bash
set -xe

#./$0 REMASTERED_IMAGE INCREASE_DISK_SIZE_AMOUNT_MB
REMASTERED_IMAGE="$1"
INCREASE_DISK_SIZE_AMOUNT_MB="$2"

dd if=/dev/zero bs=1M count=$INCREASE_DISK_SIZE_AMOUNT_MB >> $REMASTERED_IMAGE

# Loop mount disk image
loop_mount_device=$(losetup --show -P -f $REMASTERED_IMAGE)
#ls $loop_mount_device*

# Resize second partition to incorporate the new created space, then grow the ext4 filesystem to fill the partition space.
parted $loop_mount_device resizepart 2 100%
e2fsck -f -y ${loop_mount_device}p2
resize2fs ${loop_mount_device}p2

losetup -D $loop_mount_device
