#!/bin/bash
cd $(dirname $0)
./steamcmd.sh +login anonymous +force_install_dir /home/dst/dstserver +app_update 343050 validate +quit
