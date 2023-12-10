#!/bin/bash

set -e
set -x

source ${PWD}/library.bash

test_network_connection

if [ $EUID -ne 0 ]; then
	echo "$(basename $0) must be run as root"
	exit 1
fi

if [ -z "$1" ]; then
    echo "input user name"
fi

USER_NAME=$1;

echo "user name "${USER_NAME}
