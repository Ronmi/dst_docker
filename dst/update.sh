#!/bin/bash
MOD=/home/dst/dstserver/mods/dedicated_server_mods_setup.lua
cd $(dirname $0)
./steamcmd.sh +login anonymous +force_install_dir /home/dst/dstserver +app_update 343050 validate +quit
cp dedicated_server_mods_setup.lua $MOD

# Overwrite mod setup with user specified setup (if exists)
ORIG=/home/dst/.klei/DoNotStarveTogether/dedicated_server_mods_setup.lua
if [[ -f $ORIG ]]
then
    ln -sf $ORIG $MOD
fi
