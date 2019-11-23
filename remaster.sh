#!/usr/bin/env bash
set -xe

# Run as root

apt -y update
apt install -y python3-pip
pip3 install toml

ORIGINAL_IMAGE=$(python3 readConfig.py ORIGINAL_IMAGE)
REMASTERED_IMAGE=$(python3 readConfig.py REMASTERED_IMAGE)
INCREASE_DISK_SIZE_AMOUNT_MB=$(python3 readConfig.py INCREASE_DISK_SIZE_AMOUNT_MB)
ARCH=$(python3 readConfig.py ARCH)

# Sanity checks

if [ ! -f  $ORIGINAL_IMAGE ];
then
  echo "File $ORIGINAL_IMAGE does not exist"
  exit 1
fi

if [ ! -f $REMASTERED_IMAGE ];
then
  echo "File $REMASTERED_IMAGE exists. Can't proceed until file is moved or deleted."
  exit 1
fi

cp $ORIGINAL_IMAGE $REMASTERED_IMAGE

bash increase-disk-space.sh $REMASTERED_IMAGE $INCREASE_DISK_SIZE_AMOUNT_MB

bash copy-files.sh $REMASTERED_IMAGE

bash run-scripts.sh $REMASTERED_IMAGE $ARCH

