#!/usr/bin/env bash

source ${PWD}/library.bash

function install_chimeraos_files() {
    local CHIMERAOS_ROOTFS_PATH=${CHIMEROS_PATH}/rootfs

    local CHIMERAOS_DIR_LIST="\
        /usr/share/wireplumber/main.lua.d \
        /usr/share/backgrounds/chimeraos \
        /usr/share/polkit-1/actions \
        /usr/share/icons/chimeraos/scalable/actions \
        /etc/bluetooth \
        /etc/systemd/logind.conf.d \
        /etc/systemd/system \
        /etc/systemd/journald.conf.d \
        /etc/dconf/db/local.d \
        /etc/dconf/profile \
        /etc/skel/Templates \
        /etc/NetworkManager/conf.d \
        /etc/sudoers.d \
        /etc/polkit-1/rules.d \
        /etc/udev/rules.d \
        "

    local CHIMERAOS_ROOTFS_FILES="\
        usr/share/wireplumber/main.lua.d/50-alsa-config.lua \
        usr/share/icons/chimeraos/index.theme \
        usr/share/icons/chimeraos/scalable/actions/return-to-game-mode.svg \
        usr/bin/chimera-session \
        etc/bluetooth/main.conf \
        etc/systemd/logind.conf.d/power_off.conf \
        etc/systemd/system/bluetooth-workaround.service \
        etc/systemd/journald.conf.d/00-journal-persistent.conf \
        etc/systemd/journald.conf.d/00-journal-size.conf \
        etc/dconf/profile/user \
        etc/NetworkManager/conf.d/00-disable-rand-mac.conf \
        etc/sudoers.d/systemctl_needed \
        etc/polkit-1/rules.d/40-system-tweaks.rules \
        etc/polkit-1/rules.d/41-steamvr.rules \
        etc/udev/rules.d/00-ntfs3-default-mount.rules \
        etc/udev/rules.d/81-wol.rules \
    "

    for dir in ${CHIMERAOS_DIR_LIST}; do
        if [ ! -d "${dir}" ]; then
            run_root_cmd mkdir -p "${dir}"
            run_root_cmd chmod 755 "${dir}"
            run_root_cmd chown root:root "${dir}"
        fi
    done

    for files in ${CHIMERAOS_ROOTFS_FILES}; do
        run_root_cmd cp "${CHIMERAOS_ROOTFS_PATH}/${files}"  /"${files}"
    done

}
