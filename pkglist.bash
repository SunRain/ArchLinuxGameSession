#!/usr/bin/env bash

################################################################
#                                                              #
#  假设已经安装了一个可用的archlinux系统，故只安装一些必须的包 #
#                                                              #
################################################################

####################################################
# packages at archlinux repo or archlinuxcn repo
###################################################
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
    packagekit-qt5 \
    dolphin \
    dolphin-plugins \
    ffmpegthumbs \
    kdegraphics-thumbnailers \
    konsole \
    kate \
"
export SYSTEM_PACKAGE_EXTRA="\
    fcitx5-chinese-addons \
    fcitx5-pinyin-zhwiki \
    cpupower \
    efibootmgr \
    noto-fonts-cjk \
    wqy-microhei \
    7-zip-full \
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
    vulkan-mesa-layers \
    lib32-vulkan-mesa-layers \
    vulkan-swrast \
    lib32-vulkan-swrast \
"
export PACMAN_SYSTEM_PACKAGE="\
    ${META_PACKAGE} \
    ${KDE_PACKAGE_EXTRA} \
    ${SYSTEM_PACKAGE_EXTRA} \
    ${AMD_PACKAGE} \
"
export WINE_PACKAGE="\
    wine-staging \
    winetricks \
    alsa-lib \
    alsa-plugins \
    cups \
    giflib \
    gnutls \
    gsm \
    gst-plugins-base-libs \
    gtk3 \
    lib32-alsa-lib \
    lib32-alsa-plugins \
    lib32-giflib \
    lib32-gnutls \
    lib32-gst-plugins-base-libs \
    lib32-gtk3 \
    lib32-libjpeg-turbo \
    lib32-libldap \
    lib32-libpng \
    lib32-libva \
    lib32-libxcomposite \
    lib32-libxinerama \
    lib32-libxslt \
    lib32-mpg123 \
    lib32-ncurses \
    lib32-openal \
    lib32-opencl-icd-loader \
    lib32-sdl2 \
    lib32-vkd3d \
    lib32-vulkan-icd-loader \
    libgphoto2 \
    libjpeg-turbo \
    libldap \
    libpng \
    libva \
    libxcomposite \
    libxinerama \
    libxslt \
    mpg123 \
    ncurses \
    openal \
    opencl-icd-loader \
    samba \
    sane \
    sdl2 \
    vkd3d \
    vulkan-icd-loader \
    wine_gecko \
    wine-mono \
"
export STEAM_PACKAG="\
    steam \
    steam-native-runtime \
    gcc-libs \
    libgpg-error \
    libva \
    libxcb \
    lib32-gcc-libs \
    lib32-libgpg-error \
    lib32-libva \
    lib32-libxcb \
"
export PACMAN_GAME_PACKAGE="\
    gamemode \
    lib32-gamemode \
    mangohud \
    lib32-mangohud \
    goverlay \
    ${STEAM_PACKAG} \
    xorg-xgamma \
"

export GAME_STORE_PACKAGE="\
    lutris \
    heroic-games-launcher-bin \
"
###################
# AUR packages
##################

# https://github.com/sonic2kk/steamtinkerlaunch
export OP_STEAMLINKER="\
    steamtinkerlaunch \
"
export AUR_GAME_PACKAGE="\
    gamescope-session-git \
    gamescope-session-steam-git \
	gamescope-session-steam-plus-git \
    opengamepadui-bin \
	opengamepadui-session-git \
    steam_notif_daemon \
	steam-removable-media-git \
    vkbasalt \
    lib32-vkbasalt \
    ludusavi \
    game-devices-udev \
    ${OP_STEAMLINKER}
"
#https://www.emudeck.com/
export GS_EmuDeck="\
    emudeck \
"
export AUR_PACKAGE="\
    powerstation-bin \
    protonup-qt \
    ryzenadj-git \
    ${GS_EmuDeck} \
"
#    zenergy-dkms-git \


export PACKAGES_TO_DELETE="\
	amdvlk \
	lib32-amdvlk \
"