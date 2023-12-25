#!/usr/bin/env bash

source ${PWD}/library.bash

function install_holoiso_files() {
    local STEAM_POLKIT_HELPER_PATH="/usr/bin/steamos-polkit-helpers"

    local dirlist="\
        /etc/flatpak/remotes.d \
        /etc/sysctl.d \
        /etc/systemd/system \
        /usr/lib/holoiso-hwsupport \
		/usr/lib/systemd/journald.conf.d \
		/usr/lib/sysusers.d \
		${STEAM_POLKIT_HELPER_PATH} \
    "
    local new_steamos_dirs="\
        etc/flatpak/remotes.d/flathub-beta.flatpakrepo \
        etc/sysctl.d/swappiness.conf \
        etc/systemd/system/powerbutton-chmod.service \
        usr/bin/gamescope-wayland-teardown-workaround \
        usr/bin/startplasma-steamos-oneshot \
        usr/lib/holoiso-hwsupport/power-button-handler.py \
        usr/lib/systemd/system/flatpak-modify-flathub-beta.service \
        usr/lib/systemd/system/flatpak-workaround.service \
        usr/lib/systemd/system/multi-user.target.wants/flatpak-modify-flathub-beta.service \
        usr/lib/systemd/system/multi-user.target.wants/flatpak-workaround.service \
        usr/share/polkit-1/actions/org.jittleyang.deeznuts.policy \
        usr/share/wayland-sessions/plasma-steamos-wayland-oneshot.desktop \
        usr/share/xsessions/plasma-steamos-oneshot.desktop \
    "
    local steamos_customizations="\
        etc/grub.d/99_reboot \
        usr/lib/sysctl.d/10-kernel-panic.conf \
        usr/lib/systemd/journald.conf.d/system-max-use.conf \
        usr/lib/sysusers.d/steamos-users.conf \
        usr/share/X11/xorg.conf.d/10-steamos-virtualdisplaysize.conf \
        "
# etc/grub.d/30_efi-prober \
# usr/bin/mkswapfile \
# usr/lib/systemd/journald.conf.d/persistent-store.conf \
# usr/lib/systemd/system/sddm.service.d/steamos-customizations.conf \
# usr/lib/systemd/system/steamos-offload.target.wants/opt.mount \
# usr/lib/systemd/system/steamos-offload.target.wants/root.mount \
# usr/lib/systemd/system/steamos-offload.target.wants/srv.mount \
# usr/lib/systemd/system/steamos-offload.target.wants/usr-lib-debug.mount \
# usr/lib/systemd/system/steamos-offload.target.wants/usr-local.mount \
# usr/lib/systemd/system/steamos-offload.target.wants/var-cache-pacman.mount \
# usr/lib/systemd/system/steamos-offload.target.wants/var-lib-docker.mount \
# usr/lib/systemd/system/steamos-offload.target.wants/var-lib-flatpak.mount \
# usr/lib/systemd/system/steamos-offload.target.wants/var-lib-systemd-coredump.mount \
# usr/lib/systemd/system/steamos-offload.target.wants/var-log.mount \
# usr/lib/systemd/system/steamos-offload.target.wants/var-tmp.mount \
# usr/lib/systemd/system/swap.target.wants/home-swapfile.swap \
# usr/lib/systemd/system/swap.target.wants/swapfile.service \
# usr/lib/systemd/system/boot.mount \
# usr/lib/systemd/system/home-swapfile.swap \
# usr/lib/systemd/system/opt.mount \
# usr/lib/systemd/system/root.mount \
# usr/lib/systemd/system/sddm.service.d \
# usr/lib/systemd/system/srv.mount \
# usr/lib/systemd/system/swapfile.service \
# usr/lib/systemd/system/usr-lib-debug.mount \
# usr/lib/systemd/system/usr-local.mount \
# usr/lib/systemd/system/var-cache-pacman.mount \
# usr/lib/systemd/system/var-lib-docker.mount \
# usr/lib/systemd/system/var-lib-flatpak.mount \
# usr/lib/systemd/system/var-lib-systemd-coredump.mount \
# usr/lib/systemd/system/var-log.mount \
# usr/lib/systemd/system/var-tmp.mount \
# usr/lib/tmpfiles.d/steamos-offload.conf \

    for dir in ${dirlist}; do
        if [ ! -d "${dir}" ]; then
            run_root_cmd mkdir -p "${dir}";
            run_root_cmd chmod 755 "${dir}";
            run_root_cmd chown root:root "${dir}";
        fi
    done

    for files in ${new_steamos_dirs}; do
        run_root_cmd cp "${HOLOISO_PATH}"/new_steamos_dirs/"${files}" /"${files}"
    done

    for files in ${steamos_customizations}; do
        run_root_cmd cp "${HOLOISO_PATH}"/steamos-customizations/"${files}" /"${files}"
    done

    run_root_cmd cp "${HOLOISO_PATH}/steamos-session-select" "/usr/bin/steamos-session-select"
    run_root_cmd chmod 755 "/usr/bin/steamos-session-select"
    run_root_cmd chown root:root "/usr/bin/steamos-session-select"
    run_root_cmd cp "${HOLOISO_PATH}/99-dualshock-dualsense.rules" "/etc/udev/rules.d/99-dualshock-dualsense.rules"

    if [ ! -d ${STEAM_POLKIT_HELPER_PATH} ]; then
        run_root_cmd mkdir -p ${STEAM_POLKIT_HELPER_PATH}
        run_root_cmd chmod 755 ${STEAM_POLKIT_HELPER_PATH}
        run_root_cmd chown root:root ${STEAM_POLKIT_HELPER_PATH}
    fi

    run_root_cmd cp "${STEAM_JUPITER_PATH}/usr/bin/steamos-polkit-helpers/steamos-priv-write" \
                    "${STEAM_POLKIT_HELPER_PATH}/steamos-priv-write"
}
