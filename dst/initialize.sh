#!/bin/bash

function amd64() {
    dpkg --add-architecture i386
    apt-get update
    apt-get -y install lib32gcc1 lib32stdc++6 libcurl4-gnutls-dev:i386 wget sudo
}

function i386() {
    apt-get update
    apt-get -y install libcurl4-gnutls-dev libgcc1 wget sudo
}


# test whether running i386 or amd64
if [[ $(uname -m) == "x86_64" ]]
then
    amd64
else
    i386
fi

# grab steam-cli
sudo -u dst -H -n -- wget -O /home/dst/steam.tgz http://media.steampowered.com/installer/steamcmd_linux.tar.gz
sudo -u dst -H -n -- tar zxvf /home/dst/steam.tgz -C /home/dst

# run update for the first time
sudo -u dst -H -n -- /home/dst/update.sh
