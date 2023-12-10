#!/bin/bash

test_network_connection() {
    curl -s https://ping.archlinux.org/ | grep -c "This domain is used for connectivity checking"
    if [ $? -eq 1 ]; then
        echo "test network failure"
        exit 1
    fi
}