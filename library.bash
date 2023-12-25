#!/usr/bin/env bash

export USER_NAME=${USER_NAME}
export ROOT_PASSWD=${ROOT_PASSWD}
export SYS_APP_DESKTOP_DIR="/usr/share/applications"

export HOLOISO_PATH="${PWD}/3rd-party/holoiso_install_main/src"
export STEAM_JUPITER_PATH="${PWD}/3rd-party/jupiter-hw-support"
export CHIMEROS_PATH="${PWD}/3rd-party/chimeraos"

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
        read -s -r rpwd
        echo "rpwd is""$rpwd"
        if echo $rpwd | su -c whoami | grep -c "root"; then
            ROOT_PASSWD=$rpwd
            break
        fi
    done
}

pacman_install() {
    test_root_password
    # shellcheck disable=SC2086
    # shellcheck disable=SC2068
    echo ${ROOT_PASSWD} | sudo -S pacman -S --noconfirm --needed $@
}

aur_install() {
    test_root_password
    echo "install packages [ $* ]"
    while true; do
        # shellcheck disable=SC2086
        if echo ${ROOT_PASSWD} | paru -S --noconfirm --removemake "$@"; then
            break
        fi
    done
}

aur_install_each() {
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
    # shellcheck disable=SC2086
    echo ${ROOT_PASSWD} | sudo -S -E $@
    # echo ${ROOT_PASSWD} | sudo -S -E bash -c $@
}
