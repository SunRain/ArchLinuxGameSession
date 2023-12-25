#!/usr/bin/env bash


source ${PWD}/library.bash

function install_stream_patch() {

    echo "Installing Steam Patch release..."

    local OLD_DIR="$HOME/steam-patch"

    # 获取 $USER_DIR/steam-patch 的所属用户 如果是root， 则删除
    if [ -d "$OLD_DIR" ]; then
        local USER_DIR_OWNER=$(stat -c '%U' $OLD_DIR)
        if [ "$USER_DIR_OWNER" == "root" ]; then
            run_root_cmd rm -rf $OLD_DIR
        fi
    fi

    if [ ! -d ${OLD_DIR} ]; then
        mkdir -p ${OLD_DIR}
    fi

    local TEMP_FOLDER=$(mktemp -d)

    # Enable CEF debugging
    touch "$HOME/.steam/steam/.cef-enable-remote-debugging"

    # Download latest release and install it
    local RELEASE=$(curl -s 'https://api.github.com/repos/honjow/steam-patch/releases/latest')

    local MESSAGE=$(echo "$RELEASE" | jq -r '.message')

    # if MESSAGE not null, then there is an error
    if [[ "x$MESSAGE" != "xnull" ]]; then
        echo -e "Failed to get latest release info:\n${MESSAGE}" >&2
        exit 1
    fi

    local VERSION=$(jq -r '.tag_name' <<<${RELEASE})
    local DOWNLOAD_URL=$(jq -r '.assets[].browser_download_url | select(endswith("steam-patch"))' <<<${RELEASE})

    if [ -z "$VERSION" ] || [ -z "$DOWNLOAD_URL" ]; then
        echo "Failed to get latest release info" >&2
        exit 1
    fi

    local SERVICES_URL=$(jq -r '.assets[].browser_download_url | select(endswith("steam-patch.service"))' <<<${RELEASE})
    local SERVICES_BOOT_URL=$(jq -r '.assets[].browser_download_url | select(endswith("restart-steam-patch-on-boot.service"))' <<<${RELEASE})
    local CONFIG_URL=$(jq -r '.assets[].browser_download_url | select(endswith("config.toml"))' <<<${RELEASE})
    local POLKIT_URL=$(jq -r '.assets[].browser_download_url | select(endswith("steamos-priv-write-updated"))' <<<${RELEASE})

    if ! run_root_cmd systemctl --user stop steam-patch 2>/dev/null; then
         echo "stop steam-patch by user fail"
    fi

    if ! run_root_cmd systemctl --user disable steam-patch 2>/dev/null; then
        echo "disable steam-patch by user fail"
    fi

    if ! run_root_cmd systemctl stop steam-patch 2>/dev/null; then
         echo "stop steam-patch by root fail"
    fi

    if ! run_root_cmd systemctl disable steam-patch 2>/dev/null; then
         echo "disable steam-patch by root fail"
    fi

    printf "Installing version %s...\n" "${VERSION}"
    curl -L $DOWNLOAD_URL --output ${TEMP_FOLDER}/steam-patch
    curl -L $SERVICES_URL --output ${TEMP_FOLDER}/steam-patch.service
    curl -L $SERVICES_BOOT_URL --output ${TEMP_FOLDER}/restart-steam-patch-on-boot.service
    curl -L $CONFIG_URL --output ${TEMP_FOLDER}/config.toml
    curl -L $POLKIT_URL --output ${TEMP_FOLDER}/steamos-priv-write-updated

    run_root_cmd sed -i "s@\$USER@$USER@g" ${TEMP_FOLDER}/steam-patch.service
    run_root_cmd cp ${TEMP_FOLDER}/steam-patch.service /etc/systemd/system/
    run_root_cmd cp ${TEMP_FOLDER}/restart-steam-patch-on-boot.service /etc/systemd/system/

    polkit_bak_path=/usr/bin/steamos-polkit-helpers/steamos-priv-write.bak
    if [ ! -f "$polkit_bak_path" ]; then
        echo "Backing up steamos-priv-write..."
        run_root_cmd cp /usr/bin/steamos-polkit-helpers/steamos-priv-write /usr/bin/steamos-polkit-helpers/steamos-priv-write.bak
    fi

    run_root_cmd cp ${TEMP_FOLDER}/steamos-priv-write-updated /usr/bin/steamos-polkit-helpers/steamos-priv-write

    chmod +x ${TEMP_FOLDER}/steam-patch
    run_root_cmd cp ${TEMP_FOLDER}/steam-patch /usr/bin/steaam-patch-pro

    run_root_cmd mkdir -p /etc/steam-patch
    local config_path=/etc/steam-patch/config.toml
    if [ -f "$config_path" ]; then
        echo "Backing up config.toml..."
        run_root_cmd cp $config_path "${config_path}.bak"
    fi
    cp ${TEMP_FOLDER}/config.toml $HOME/steam-patch/config.toml

    # DEVICENAME=$(cat /sys/devices/virtual/dmi/id/product_name)
    # if [[ "${DEVICENAME}" == "ROG Ally RC71L_RC71L" ]]; then
    #     sed -i "s/auto_nkey_recovery = false/auto_nkey_recovery = true/" $HOME/steam-patch/config.toml
    # fi

    # Run service
    run_root_cmd systemctl daemon-reload
    run_root_cmd systemctl enable steam-patch.service
    # run_root_cmd systemctl start steam-patch.service
    run_root_cmd systemctl enable restart-steam-patch-on-boot.service
    # run_root_cmd systemctl start restart-asteam-patch-on-boot.service

}
