#!/usr/bin/env bash

export USER_NAME=${USER_NAME}
export ROOT_PASSWD=${ROOT_PASSWD}
export SYS_APP_DESKTOP_DIR="/usr/share/applications/heroic-gamemode.desktop"

test_network_connection() {
    if ! curl -s https://ping.archlinux.org/ | grep -c "This domain is used for connectivity checking"; then
        echo "test network failure"
        exit 1
    fi
}

test_root_password() {
    if [ "$ROOT_PASSWD" ]; then
        # shellcheck disable=SC2086
        if echo ${ROOT_PASSWD} | su -c whoami | grep -c "root"; then
            return 0
        fi
    fi
    while true; do
        echo "Input root password: "
        read -s -r pwd
        if echo $pwd | su -c whoami | grep -c "root"; then
            ROOT_PASSWD=$pwd
            break
        fi
    done
}

pacman_install() {
    test_root_password
    # shellcheck disable=SC2086
    echo ${ROOT_PASSWD} | sudo -S pacman -S --noconfirm --needed "$@"
}

aur_install() {
    test_root_password
    echo "install packages [ $* ]"
    for pkg in "$@"; do
        while true; do
            echo "install $pkg"
            # shellcheck disable=SC2086
            if echo ${ROOT_PASSWD} | paru -S --noconfirm --removemake $pkg; then
                break
            fi
        done
    done
}

run_root_cmd() {
    test_root_password
    echo ${ROOT_PASSWD} | sudo -S "$@"
}

