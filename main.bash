#!/usr/bin/env bash

#debug
set -e #如果命令执行失败，则立即退出 Shell。
#set -u #如果使用未定义的变量，则显示错误信息并退出 Shell。
set -x #显示每个命令执行的详细信息。
#set -v #显示 Shell 中每个命令执行之前的参数和输入。

# shellcheck disable=SC1091
source "${PWD}"/library.bash
# shellcheck disable=SC1091
source "${PWD}"/pkglist.bash

test_network_connection

# if [ $EUID -ne 0 ]; then
# 	echo "$(basename "$0") must be run as root"
# 	exit 1
# fi

if [ -z "$1" ]; then
	echo "input user name"
fi

USER_NAME=$1

echo "user name ""${USER_NAME}"

#############################
#  Start set archlinuxcn repo and install basic aur files
#############################

if ! grep "repo.archlinuxcn.org/\$arch" /etc/pacman.conf; then
	cat <<EOF >>/etc/pacman.conf

[archlinuxcn]
SigLevel = Never
Server = https://repo.archlinuxcn.org/\$arch

EOF

	pacman -Syy
	pacman_install archlinuxcn-keyring
fi
pacman_install paru

## Install crudini tool
aur_install crudini

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

# shellcheck disable=SC2086
aur_install ${AUR_PACKAGE}

############
#
# TODO delete un-needed package
#
############

# Optimizing battery
pacman_install auto-cpufreq
run_root_cmd systemctl enable auto-cpufreq

# Install SteamDeckHomebrew
# shellcheck disable=SC1091
source "${PWD}/SteamDeckHomebrew_installer.bash“
install_SteamDeckHomebrew

# gamemode for Heroic Games Launcher
run_root_cmd cp "${SYS_APP_DESKTOP_DIR}"/heroic.desktop "${SYS_APP_DESKTOP_DIR}"/heroic-gamemode.desktop
# shellcheck disable=SC2026
run_root_cmd sed -i s'/Exec=\/opt\/Heroic\/heroic\ \%U/Exec=\/usr\/bin\/gamemoderun \/opt\/Heroic\/heroic\ \%U/'g "${SYS_APP_DESKTOP_DIR}"/heroic-gamemode.desktop
run_root_cmd crudini -set "${SYS_APP_DESKTOP_DIR}"/heroic-gamemode.desktop "Desktop Entry" Name "Lutris - GameMode"

# steam deck runtime
run_root_cmd cp "${SYS_APP_DESKTOP_DIR}"/steam.desktop "${SYS_APP_DESKTOP_DIR}"/steam_deck_runtime.desktop
run_root_cmd sed -i s'/Exec=\/usr\/bin\/steam\-runtime\ \%U/Exec=\/usr\/bin\/steam-runtime\ -gamepadui\ \%U/'g "${SYS_APP_DESKTOP_DIR}"/steam_deck_runtime.desktop
run_root_cmd crudini --set "${SYS_APP_DESKTOP_DIR}/steam_deck_runtime.desktop" "Desktop Entry" Name "Steam Deck Mode"

############
#
# TODO zram or zswap?
# https://wiki.archlinuxcn.org/wiki/Zram
#
############

# Instal holoiso files
#run_root_cmd cp "${HOLOISO_PATH}/steamos-session-select" /usr/bin/steamos-session-select
#run_root_cmd cp "${HOLOISO_PATH}/steamos-select-branch" "/usr/bin/steamos-select-branch"
#run_root_cmd cp "${HOLOISO_PATH}/holoiso-disable-sessions" "/usr/bin/holoiso-disable-sessions"
#run_root_cmd cp "${HOLOISO_PATH}/holoiso-enable-sessions" "$/usr/bin/holoiso-enable-sessions"
#run_root_cmd cp "${HOLOISO_PATH}/steamos-gamemode.desktop" "$/etc/skel/Desktop/steamos-gamemode.desktop"
