#!/bin/bash

# Overwrite mod setup with user specified setup (if exists)
MOD=/home/dst/dstserver/mods/dedicated_server_mods_setup.lua
ORIG=/home/dst/.klei/DoNotStarveTogether/dedicated_server_mods_setup.lua
if [[ -f $ORIG ]]
then
    cp -f $ORIG $MOD
fi

# start server
cd /home/dst/dstserver/bin
exec ./dontstarve_dedicated_server_nullrenderer
