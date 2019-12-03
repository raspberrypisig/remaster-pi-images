#!/usr/bin/env bash
set -x

# Run as root

apt update 2>&1 >/dev/null
set -e
apt install -y python3-pip
pip3 install toml

ORIGINAL_IMAGE=$(python3 readConfig.py Release ORIGINAL_IMAGE)
REMASTERED_IMAGE=$(python3 readConfig.py Release REMASTERED_IMAGE)
INCREASE_DISK_SIZE_AMOUNT_MB=$(python3 readConfig.py Release INCREASE_DISK_SIZE_AMOUNT_MB)
ARCH=$(python3 readConfig.py Release ARCH)

# Sanity checks

if [ ! -f  $ORIGINAL_IMAGE ];
then
  echo "File $ORIGINAL_IMAGE does not exist"
  exit 1
fi

if [ -f $REMASTERED_IMAGE ];
then
  echo "File $REMASTERED_IMAGE exists. Can't proceed until file is moved or deleted."
  exit 1
fi

cp $ORIGINAL_IMAGE $REMASTERED_IMAGE

bash increase-disk-space.sh $REMASTERED_IMAGE $INCREASE_DISK_SIZE_AMOUNT_MB

bash copy-files.sh $REMASTERED_IMAGE

#bash run-scripts.sh $REMASTERED_IMAGE $ARCH

