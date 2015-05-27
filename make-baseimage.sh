#!/bin/bash

MIRROR="$1"
SUIT="$2"

if [[ "$1" == "" ]]
then
    MIRROR="http://ftp.debian.org/debian"
fi

if [[ "$2" == "" ]]
then
    SUIT="stable"
fi

BUILD_DIR=$(mktemp -d)

echo "Preparing system image using Debian $SUIT in $BUILD_DIR"
sudo debootstrap --include=wget,sudo --variant=minbase $3 "$SUIT" "$BUILD_DIR" "$MIRROR"
if [[ $? == "0" ]]
then
    echo ""
    echo -n "System image prepared, import into docker... "
    sudo tar cf - -C "$BUILD_DIR" . | sudo docker import - dst_base
fi
sudo rm -fr "$BUILD_DIR"
