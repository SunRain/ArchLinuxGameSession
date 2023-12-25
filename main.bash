#!/usr/bin/env bash

#debug
set -e #如果命令执行失败，则立即退出 Shell。
#set -u #如果使用未定义的变量，则显示错误信息并退出 Shell。
set -x #显示每个命令执行的详细信息。
#set -v #显示 Shell 中每个命令执行之前的参数和输入。

source ${PWD}/library.bash
source ${PWD}/pkglist.bash

test_network_connection

# if [ $EUID -ne 0 ]; then
# 	echo "$(basename "$0") must be run as root"
# 	exit 1
# fi

# if [ -z "$1" ]; then
# 	echo "input user name"
# fi

USER_NAME=$(whoami)

echo "user name ${USER_NAME} , current  $(whoami)"

#############################
#  Start set archlinuxcn repo and install basic aur files
#############################

test_root_password

# 只检测[archlinuxcn] section以避免使用了镜像地址
if ! grep "[archlinuxcn]" /etc/pacman.conf; then

	# 单独检测root密码，并使用单独的sudo命令，这是由于使用run_root_cmd时候似乎传递的参数会出错
	test_root_password
	echo ${ROOT_PASSWD} | sudo -S -E bash -c 'echo -e "[archlinuxcn] \nSigLevel = Never \nServer = https://repo.archlinuxcn.org/\$arch \n" >> /etc/pacman.conf'

	run_root_cmd pacman -Syy
	pacman_install archlinuxcn-keyring
else
	echo "Find archlinuxcn section"
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
# shellcheck disable=SC2086
source ${PWD}/SteamDeckHomebrew_installer.bash
install_SteamDeckHomebrew

# gamemode for Heroic Games Launcher
# shellcheck disable=SC2086
run_root_cmd cp ${SYS_APP_DESKTOP_DIR}/heroic.desktop ${SYS_APP_DESKTOP_DIR}/heroic-gamemode.desktop
EXEC_VAR=$(echo "${ROOT_PASSWD}" | sudo -S -E bash -c 'crudini --get ${SYS_APP_DESKTOP_DIR}/heroic-gamemode.desktop "Desktop Entry" "Exec"')
EXEC_VAR="\/usr\/bin\/gamemoderun ${EXEC_VAR}"
echo "${ROOT_PASSWD}" | sudo -S -E bash -c "crudini --set ${SYS_APP_DESKTOP_DIR}/heroic-gamemode.desktop \"Desktop Entry\" Exec \"${EXEC_VAR}\""
unset EXEC_VAR
echo "${ROOT_PASSWD}" | sudo -S -E bash -c "crudini --set ${SYS_APP_DESKTOP_DIR}/heroic-gamemode.desktop \"Desktop Entry\" Name \"Lutris - GameMode\""

# steam deck runtime
# shellcheck disable=SC2086
run_root_cmd cp ${SYS_APP_DESKTOP_DIR}/steam.desktop ${SYS_APP_DESKTOP_DIR}/steam_deck_runtime.desktop
echo "${ROOT_PASSWD}" | sudo -S -E bash -c "crudini --set \
                                        	${SYS_APP_DESKTOP_DIR}/steam_deck_runtime.desktop \
                                        	\"Desktop Entry\" \
                                        	Exec \
                                        	\"/usr/bin/steam-runtime -gamepadui %U\""

echo "${ROOT_PASSWD}" | sudo -S -E bash -c "crudini --set \
											${SYS_APP_DESKTOP_DIR}/steam_deck_runtime.desktop \
											\"Desktop Entry\" \
											Name \
											\"Steam Deck Mode\""

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

source ${PWD}/holoiso_installer.bash
install_holoiso_files

source ${PWD}/steam-patch_installer.bash
install_stream_patch

source ${PWD}/chimeraos_installer.bash
install_chimeraos_files
