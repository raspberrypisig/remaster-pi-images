
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

bash run-scripts.sh $REMASTERED_IMAGE $ARCH
