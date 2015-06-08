#!/bin/bash

USER_ID=$(id -u)

echo "FROM dst_base
MAINTAINER Ronmi Ren <ronmi.ren@gmail.com>
RUN useradd -d /home/dst -U -u $USER_ID -m dst
COPY initialize.sh /initialize.sh
COPY start.sh /home/dst/start.sh
COPY update.sh /home/dst/update.sh
COPY dedicated_server_mods_setup.lua /home/dst/dedicated_server_mods_setup.lua
RUN chown -R dst:dst /home/dst && /initialize.sh
USER $USER_ID
WORKDIR /home/dst/dstserver/bin
" | tee $(dirname $0)/dst/Dockerfile

docker build -t dstserver "$(dirname "$0")/dst"
