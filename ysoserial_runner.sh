#!/bin/bash

CONTAINER_NAME="ysoserial"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

print_timestamp() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

is_container_running() {
    sudo docker ps -q -f name=$CONTAINER_NAME | grep -q .
    return $?
}

start_container() {
    if ! is_container_running; then
        print_timestamp "Starting container $CONTAINER_NAME..."
        sudo docker start $CONTAINER_NAME
    else
        print_timestamp "${GREEN}Container $CONTAINER_NAME is already running.${NC}"
    fi
}

stop_container() {
    print_timestamp "${RED}Stopping container $CONTAINER_NAME...${NC}"
    sudo docker stop $CONTAINER_NAME
}

run_ysoserial() {
    start_container
    print_timestamp "Running ysoserial in container $CONTAINER_NAME..."
    echo -e "\n==================== ysoserial Output====================\n"
    sudo docker exec -it ysoserial /bin/bash -c 'WINEDEBUG=-all wine /ysoserial/Release/ysoserial.exe '"$@"
    echo -e "\n\n==================== ysoserial Output====================\n"
    stop_container
}

if [ "$#" -lt 2 ] || [ "$1" != "run" ]; then
    print_timestamp "${RED}Error: Invalid arguments.${NC}"
    exit 1
fi

shift
run_ysoserial "$@"