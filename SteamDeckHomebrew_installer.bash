#!/usr/bin/env bash

# shellcheck disable=SC2086
# shellcheck disable=SC1091
source ${PWD}/library.bash

# From https://github.com/SteamDeckHomebrew/decky-installer/blob/main/cli/install_release.sh
# and  https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/user_install_script.sh
# with tweaks

install_SteamDeckHomebrew() {
    # check if JQ is installed
    if ! command -v jq &>/dev/null; then
        echo "Installing jq by pacman"
        pacman_install jq
    fi

    # check if github.com is reachable
    # if ! curl -Is https://github.com | head -1 | grep 200 >/dev/null; then
    #     echo "Github appears to be unreachable, you may not be connected to the internet"
    #     exit 1
    # fi

    echo "Installing Steam Deck Plugin Loader release..."${USER_NAME}

    local USER_DIR="$(getent passwd ${USER_NAME} | cut -d: -f6)"
    local HOMEBREW_FOLDER="${USER_DIR}/homebrew"

    # Create folder structure
    echo "# Creating file structure"
    rm -rf "${HOMEBREW_FOLDER}/services"
    sudo -u "$USER_NAME" mkdir -p "${HOMEBREW_FOLDER}/services"
    sudo -u "$USER_NAME" mkdir -p "${HOMEBREW_FOLDER}/plugins"
    sudo -u "$USER_NAME" touch "${USER_DIR}/.steam/steam/.cef-enable-remote-debugging"
    # if installed as flatpak, put .cef-enable-remote-debugging there
    [ -d "${USER_DIR}/.var/app/com.valvesoftware.Steam/data/Steam/" ] && sudo -u "$USER_NAME touch ${USER_DIR}/.var/app/com.valvesoftware.Steam/data/Steam/.cef-enable-remote-debugging"

    # Download latest release and install it
    local RELEASE=$(curl -s 'https://api.github.com/repos/SteamDeckHomebrew/decky-loader/releases' | jq -r "first(.[] | select(.prerelease == "false"))")
    # shellcheck disable=SC2086
    local VERSION=$(jq -r '.tag_name' <<<${RELEASE})
    local DOWNLOADURL=$(jq -r '.assets[].browser_download_url | select(endswith("PluginLoader"))' <<<${RELEASE})

    echo "# Installing version $VERSION"
    # shellcheck disable=SC2086
    curl -L $DOWNLOADURL --output ${HOMEBREW_FOLDER}/services/PluginLoader
    # shellcheck disable=SC2086
    chmod +x ${HOMEBREW_FOLDER}/services/PluginLoader

    echo "Check for SELinux presence and if it is present, set the correct permission on the binary file..."
    # shellcheck disable=SC2086
    hash getenforce 2>/dev/null && getenforce | grep "Enforcing" >/dev/null && chcon -t bin_t ${HOMEBREW_FOLDER}/services/PluginLoader

    # shellcheck disable=SC2086
    echo $VERSION >${HOMEBREW_FOLDER}/services/.loader.version

    echo "# Kiling plugin_loader if it exists"
    if ! run_root_cmd systemctl --user stop plugin_loader 2>/dev/null; then
        echo "Stop user plugin_loader fail"
    fi

    if ! run_root_cmd systemctl --user disable plugin_loader 2>/dev/null; then
        echo "Disable user plugin_loader fial"
    fi

    if ! run_root_cmd systemctl stop plugin_loader 2>/dev/null; then
        echo "Stop system-wide plugin_loader fail"
    fi

    if ! run_root_cmd systemctl disable plugin_loader 2>/dev/null; then
        echo "Disable system-wide plugin_loader fail"
    fi

    curl -L https://raw.githubusercontent.com/SteamDeckHomebrew/decky-loader/main/dist/plugin_loader-release.service --output ${HOMEBREW_FOLDER}/services/plugin_loader-release.service

    cat >"${HOMEBREW_FOLDER}/services/plugin_loader-backup.service" <<-EOM
[Unit]
Description=SteamDeck Plugin Loader
After=network-online.target
Wants=network-online.target
[Service]
Type=simple
User=root
Restart=always
ExecStart=${HOMEBREW_FOLDER}/services/PluginLoader
WorkingDirectory=${HOMEBREW_FOLDER}/services
KillSignal=SIGKILL
Environment=PLUGIN_PATH=${HOMEBREW_FOLDER}/plugins
Environment=LOG_LEVEL=INFO
[Install]
WantedBy=multi-user.target
EOM

    if [[ -f "${HOMEBREW_FOLDER}/services/plugin_loader-release.service" ]]; then
        echo "Grabbed latest release service."
        sed -i -e "s|\${HOMEBREW_FOLDER}|${HOMEBREW_FOLDER}|" "${HOMEBREW_FOLDER}/services/plugin_loader-release.service"
        run_root_cmd cp -f "${HOMEBREW_FOLDER}/services/plugin_loader-release.service" "/etc/systemd/system/plugin_loader.service"
    else
        echo "Could not curl latest release systemd service, using built-in service as a backup!"
        rm -f "/etc/systemd/system/plugin_loader.service"
        run_root_cmd cp "${HOMEBREW_FOLDER}/services/plugin_loader-backup.service" "/etc/systemd/system/plugin_loader.service"
    fi

    # shellcheck disable=SC2086
    mkdir -p ${HOMEBREW_FOLDER}/services/.systemd
    # shellcheck disable=SC2086
    cp ${HOMEBREW_FOLDER}/services/plugin_loader-release.service ${HOMEBREW_FOLDER}/services/.systemd/plugin_loader-release.service
    # shellcheck disable=SC2086
    cp ${HOMEBREW_FOLDER}/services/plugin_loader-backup.service ${HOMEBREW_FOLDER}/services/.systemd/plugin_loader-backup.service
    # shellcheck disable=SC2086
    rm ${HOMEBREW_FOLDER}/services/plugin_loader-backup.service ${HOMEBREW_FOLDER}/services/plugin_loader-release.service

    run_root_cmd systemctl daemon-reload
    run_root_cmd systemctl start plugin_loader
    run_root_cmd systemctl enable plugin_loader
}
