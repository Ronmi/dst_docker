#!/bin/bash

. /lib/lsb/init-functions

MY_DIR="$(dirname "$(readlink -fn "$0")")"
BASEDIR="${MY_DIR}/servers"
DIRS=$(find "$BASEDIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)
SUDO=

# detect if we have proper privilege to use docker
docker ps > /dev/null 2>&1
if [[ $? != 0 ]]
then
    SUDO=sudo
fi

function removeall() {
    for i in $DIRS
    do
	stop $i
	remove $i
    done
}

function createall() {
    for i in $DIRS
    do
	create $i
    done
}

function do_install() {
    USER_ID=$(id -u)

    echo "FROM debian:jessie
MAINTAINER Ronmi Ren <ronmi.ren@gmail.com>
RUN useradd -d /home/dst -U -u $USER_ID -m dst
COPY initialize.sh /initialize.sh
COPY start.sh /home/dst/start.sh
COPY update.sh /home/dst/update.sh
RUN chown -R dst:dst /home/dst && /initialize.sh
USER $USER_ID
WORKDIR /home/dst/dstserver/bin
" | tee "${MY_DIR}/dst/Dockerfile"

    $SUDO docker build -t dstserver "${MY_DIR}/dst"
}

function do_uninstall() {
    removeall
    $SUDO docker rmi -f dstserver
}

function help() {
    echo "Usage: $0 action server"
    echo ""
    echo "Valid actions: start stop restart reset remove create update create-all remove-all install uninstall"
    exit 1
}

function start() {
    CONTAINER="dst_$1"
    log_action_begin_msg "Starting docker container $1"
    $SUDO docker start "$CONTAINER" > /dev/null 2>&1
    log_action_end_msg $?
}

function stop() {
    CONTAINER="dst_$1"
    log_action_begin_msg "Stoping docker container $1"
    $SUDO docker stop "$CONTAINER" > /dev/null 2>&1
    log_action_end_msg $?
}

function cls() {
    log_action_begin_msg "Clearing saved data for $1"
    rm -fr "$BASEDIR/$1/save"
    log_action_end_msg $?
}

function remove() {
    CONTAINER="dst_$1"
    log_action_begin_msg "Removing docker container $1"
    $SUDO docker rm "$CONTAINER" > /dev/null 2>&1
    log_action_end_msg $?
}

function create() {
    CONTAINER="dst_$1"
    FN="$BASEDIR/$1/settings.ini"
    PORT=$(grep -F server_port "$FN" | sed 's/ //g' | cut -d '=' -f 2)
    log_action_begin_msg "Creating container $CONTAINER (port $PORT)"
    $SUDO docker create -v $BASEDIR/$1:/home/dst/.klei/DoNotStarveTogether --entrypoint /home/dst/start.sh --name $CONTAINER -p $PORT:$PORT/udp dstserver > /dev/null 2>&1
    log_action_end_msg $?
}

function update_baseimage() {
    log_action_begin_msg "Force removing dstserver_upgrade container"
    $SUDO docker rm -f dstserver_upgrade > /dev/null 2>&1
    log_action_end_msg

    log_action_begin_msg "Running update.sh"
    $SUDO docker run -it -u dst --name dstserver_upgrade --entrypoint /home/dst/update.sh dstserver > /dev/null 2>&1
    log_action_end_msg $?

    log_action_begin_msg "Commit dstserver_upgrade to dstserver"
    $SUDO docker commit dstserver_upgrade dstserver > /dev/null
    log_action_end_msg $?

    log_action_begin_msg "Remove dstserver_upgrade container"
    $SUDO docker rm dstserver_upgrade > /dev/null
    log_action_end_msg $?
}

function update() {
    removeall
    update_baseimage
}


if [[ "$1" == "" ]]
then
    help
fi

if [[ "$1" != "update" && "$1" != "uninstall" && "$1" != "install" && "$1" != "remove-all" && "$1" != "create-all" && "$2" == "" ]]
then
    help
fi

ACTION="$1"
SERVER="$2"

case "$ACTION" in
    start)
	start "$SERVER"
	;;
    stop)
	stop "$SERVER"
	;;
    reset)
	stop "$SERVER"
	cls "$SERVER"
	start "$SERVER"
	;;
    remove)
	stop "$SERVER"
	remove "$SERVER"
	;;
    restart)
	stop "$SERVER"
	start "$SERVER"
	;;
    create)
	create "$SERVER"
	;;
    update)
	update
	;;
    install)
	do_install
	;;
    uninstall)
	do_uninstall
	;;
    create-all)
	createall
	;;
    remove-all)
	removeall
	;;
    *)
	help
	;;
esac
