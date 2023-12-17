#!/usr/bin/env bash

#debug
set -e #如果命令执行失败，则立即退出 Shell。
set -u #如果使用未定义的变量，则显示错误信息并退出 Shell。
set -x #显示每个命令执行的详细信息。
#set -v #显示 Shell 中每个命令执行之前的参数和输入。

# shellcheck disable=SC1091
source "${PWD}"/library.bash
source "${PWD}"/pkglist.bash

test_network_connection

# if [ $EUID -ne 0 ]; then
# 	echo "$(basename "$0") must be run as root"
# 	exit 1
# fi

if [ -z "$1" ]; then
    echo "input user name"
fi

USER_NAME=$1;

echo "user name ""${USER_NAME}"

#############################
#  Start set archlinuxcn repo and install basic aur files
#############################

if ! grep "repo.archlinuxcn.org/\$arch" /etc/pacman.conf
then
	cat << EOF >> /etc/pacman.conf

[archlinuxcn]
SigLevel = Never
Server = https://repo.archlinuxcn.org/\$arch

EOF

	pacman -Syy
	pacman_install archlinuxcn-keyring
fi
pacman_install paru

#############################
#  End set archlinuxcn repo and install basic aur files
#############################


# Install system packages
# shellcheck disable=SC2086
pacman_install ${PACMAN_SYSTEM_PACKAGE}

# Install game related packages
# shellcheck disable=SC2086
pacman_install ${PACMAN_GAME_PACKAGE}

# Install 3rd-party game stores
# shellcheck disable=SC2086
pacman_install ${GAME_STORE_PACKAGE}

# Install aur packages
# shellcheck disable=SC2086
aur_install ${AUR_GAME_PACKAGE}

# Optimizing battery
pacman_install auto-cpufreq
run_su_cmd systemctl enable auto-cpufreq









