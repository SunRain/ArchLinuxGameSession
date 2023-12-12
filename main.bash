#!/bin/bash

#debug
set -e #如果命令执行失败，则立即退出 Shell。
set -u #如果使用未定义的变量，则显示错误信息并退出 Shell。
set -x #显示每个命令执行的详细信息。
#set -v #显示 Shell 中每个命令执行之前的参数和输入。

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

#############################
#  set archlinuxcn repo and install basic aur files
#############################

cat << EOF >> /etc/pacman.conf
\n[archlinuxcn]
SigLevel = Never
Server = https://repo.archlinuxcn.org/\$arch
\n
EOF

pacman -Syy
pacman -S --noconfirm archlinuxcn-keyring paru

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




