#!/bin/bash

#假设已经安装了一个可用的archlinux系统，故只安装一些必须的包
export META_PACKAGE="\
    kf5 \
    plasma \
    plasma-meta \
    kde-system \
    fcitx5-im \
"

export KDE_PACKAGE_EXTRA="\
    plasma-wayland-session \
    plasma-wayland-protocols \
    ark \
    kio-extras \
    kio-fuse \
"

export SYSTEM_PACKAGE_EXTRA="\
    fcitx5-chinese-addons \
    fcitx5-pinyin-zhwiki \
    cpupower \
    efibootmgr \
    noto-fonts-cjk \
    wqy-microhe \
    p7zip \
    unzip \
    unrar \
    zip \
    coreutils \
"

export AMD_PACKAGE="\
    mesa \
    lib32-mesa \
    xf86-video-amdgpu \
    vulkan-radeon \
    lib32-vulkan-radeon \
    libva-mesa-driver \
    lib32-libva-mesa-driver \
    mesa-vdpau \
    lib32-mesa-vdpau \
"

export PACMAN_PACKAGE="\
    ${META_PACKAGE} \
    ${KDE_PACKAGE_EXTRA} \
    ${SYSTEM_PACKAGE_EXTRA} \
    ${AMD_PACKAGE} \
"

export AUR_PACKAGE="\
    gamescope-session-steam-git \
	gamescope-session-steam-plus-git \
    opengamepadui-bin \
	opengamepadui-session-git \
    powerstation-bin \
    protonup-qt \
    ryzenadj-git \
	steam_notif_daemon \
	steam-removable-media-git \
"
#    zenergy-dkms-git \


export PACKAGES_TO_DELETE="\
	amdvlk \
	lib32-amdvlk \
"