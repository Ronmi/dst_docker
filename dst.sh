#!/bin/bash

. /lib/lsb/init-functions

BASEDIR="$(dirname "$(readlink -fn "$0")")/servers"

function help() {
    echo "Usage: $0 action server"
    echo ""
    echo "Valid actions: start stop restart reset remove create update"
    exit 1
}

function start() {
    CONTAINER="dst_$1"
    log_action_begin_msg "Starting docker container $1"
    docker start "$CONTAINER" > /dev/null 2>&1
    log_action_end_msg $?
}

function stop() {
    CONTAINER="dst_$1"
    log_action_begin_msg "Stoping docker container $1"
    docker stop "$CONTAINER" > /dev/null 2>&1
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
    docker rm "$CONTAINER" > /dev/null 2>&1
    log_action_end_msg $?
}

function create() {
    CONTAINER="dst_$1"
    FN="$BASEDIR/$1/settings.ini"
    PORT=$(grep -F server_port "$FN" | sed 's/ //g' | cut -d '=' -f 2)
    log_action_begin_msg "Creating container $CONTAINER (port $PORT)"
    docker create -v $BASEDIR/$1:/home/dst/.klei/DoNotStarveTogether --entrypoint /home/dst/start.sh --name $CONTAINER -p $PORT:$PORT/udp dstserver > /dev/null 2>&1
    log_action_end_msg $?
}

function update_baseimage() {
    log_action_begin_msg "Force removing dstserver_upgrade container"
    docker rm -f dstserver_upgrade > /dev/null 2>&1
    log_action_end_msg $?

    log_action_begin_msg "Running update.sh"
    docker run -it -u dst --name dstserver_upgrade --entrypoint /home/dst/update.sh dstserver > /dev/null 2>&1
    log_action_end_msg $?

    log_action_begin_msg "Commit dstserver_upgrade to dstserver"
    docker commit dstserver_upgrade dstserver > /dev/null
    log_action_end_msg $?

    log_action_begin_msg "Remove dstserver_upgrade container"
    docker rm dstserver_upgrade > /dev/null
    log_action_end_msg $?
}

function update() {
    DIRS=$(find "$BASEDIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)
    for i in $DIRS
    do
	stop $i
	remove $i
    done

    update_baseimage

    for i in $DIRS
    do
	create $i
    done
}


if [[ "$1" == "" ]]
then
    help
fi

if [[ "$1" != "update" && "$2" == "" ]]
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
    *)
	help
	;;
esac
