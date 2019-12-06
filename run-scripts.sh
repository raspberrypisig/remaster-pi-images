#!/usr/bin/env bash

set -xe

REMASTERED_IMAGE="$1"

apt install -y binfmt-support qemu-user-static systemd-container
update-binfmts --display

loop_disk_image=$(losetup --show -P -f $REMASTERED_IMAGE)
mount_dir=/mnt/remaster
mkdir -p $mount_dir/boot
mount ${loop_disk_image}p2 $mount_dir
mount ${loop_disk_image}p1 $mount_dir/boot

mkdir -p $mount_dir/scripts
mkdir -p $mount_dir/private
mount --bind scripts $mount_dir/scripts
mount --bind private $mount_dir/private

pip3 install chevron

cp /usr/bin/qemu-arm-static $mount_dir/usr/bin

for script in `ls private/{pre,post}-scripts/*.mustache 2>/dev/null||true`
do
  newfile=$(echo $script|sed  's/.mustache$/.sh/')
  python3 render-template.py $script $newfile
done

mv $mount_dir/etc/ld.so.preload $mount_dir/etc/ld.so.preload.bak
touch $mount_dir/etc/ld.so.preload

runScriptsInsideContainer() {
  for script in $1
  do
    systemd-nspawn -D $mount_dir /$script
  done
}


runScriptsInsideContainer "`ls private/pre-scripts/*.sh`"
runScriptsInsideContainer "`ls scripts/*.sh`"
#runScriptsInsideContainer "`ls private/post-scripts/*.sh`"

rm $mount_dir/usr/bin/qemu-arm-static
cp $mount_dir/etc/ld.so.preload.bak $mount_dir/etc/ld.so.preload

umount $mount_dir/scripts
rmdir $mount_dir/scripts
umount $mount_dir/private
rmdir $mount_dir/private 
umount $mount_dir/boot
umount $mount_dir
losetup -D $loop_disk_image
