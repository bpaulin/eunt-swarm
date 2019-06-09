#!/bin/bash
# flash.sh sdb

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [ -z $1 ]; then
  echo "Usage: ./make-rpi.sh <dev>"
  echo "       ./make-rpi.sh sdb"
  exit 1
fi

if ls *.img; then
    echo "Let's use this file"
else
    echo "no image found, let's download it"
    curl -L https://downloads.raspberrypi.org/raspbian_lite_latest -o raspbian_latest.zip
    unzip raspbian_latest.zip
fi

IMAGE=`ls *.img`
DEV=$1

echo "Writing Raspbian Lite image to SD card"
time dd if=$IMAGE of=/dev/$DEV bs=1M

sync

echo "Mounting SD card from /dev/$DEV"
mkdir -p /mnt/rpi/boot
mkdir -p /mnt/rpi/root
mount /dev/${DEV}1 /mnt/rpi/boot
mount /dev/${DEV}2 /mnt/rpi/root


echo "Enabling ssh"
touch /mnt/rpi/boot/ssh

echo "Unmounting SD Card"

umount /mnt/rpi/boot
umount /mnt/rpi/root

sync
