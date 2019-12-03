#!/usr/bin/env bash
set -x

apt update
apt install -y git
git clone https://github.com/raspberrypisig/remaster-pi-images
