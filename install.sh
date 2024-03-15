#!/bin/bash

CONFIG_PATH="${HOME}/printer_data"
KLIPPER_PATH="${HOME}/klipper"
INSTALL_PATH="${HOME}/klipper-toolchanger"

set -eu
export LC_ALL=C

function preflight_checks {
    if [ "$EUID" -eq 0 ]; then
        echo "[PRE-CHECK] This script must not be run as root!"
        exit -1
    fi

    if [ "$(sudo systemctl list-units --full -all -t service --no-legend | grep -F 'klipper.service')" ]; then
        printf "[PRE-CHECK] Klipper service found! Continuing...\n\n"
    else
        echo "[ERROR] Klipper service not found, please install Klipper first!"
        exit -1
    fi
}

function check_download {
    local installdirname installbasename
    installdirname="$(dirname ${INSTALL_PATH})"
    installbasename="$(basename ${INSTALL_PATH})"

    if [ ! -d "${INSTALL_PATH}" ]; then
        echo "[DOWNLOAD] Downloading repository..."
        if git -C $installdirname clone https://github.com/StealthChanger/klipper-toolchanger.git $installbasename; then
            chmod +x ${INSTALL_PATH}/install.sh
            printf "[DOWNLOAD] Download complete!\n\n"
        else
            echo "[ERROR] Download of git repository failed!"
            exit -1
        fi
    else
        printf "[DOWNLOAD] repository already found locally. Continuing...\n\n"
    fi
}

function remove_links {
    for path in "${KLIPPER_PATH}"/klippy/extras/ "${CONFIG_PATH}"/config/; do
        echo "[UNINSTALL] Old links in ${path}";
        for file in $(find "${KLIPPER_PATH}"/klippy/extras -type l -exec readlink -f {} \; | grep -F "${HOME}"/klipper-toolchanger); do
            rm ${file};
        done
    done
}

function link_extension {
    echo "[INSTALL] Linking extension to Klipper..."
    for file in "${INSTALL_PATH}"/klipper/extras/*.py; do
        ln -sfn ${file} "${KLIPPER_PATH}"/klippy/extras/;
    done
}

function link_macros {
    echo "[INSTALL] Linking macros to Klipper..."
    for file in "${INSTALL_PATH}"/macros/*.cfg; do
        ln -sfn ${file} "${CONFIG_PATH}"/config/;
    done
}

function copy_examples {
    echo "[INSTALL] Copying in examples to Klipper..."
    for file in "${INSTALL_PATH}"/examples/*.cfg; do
        cp -n ${file} "${CONFIG_PATH}"/config/;
    done
}

function check_includes {
    echo "[CHECK-INSTALL] Checking for missing includes..."
    for file in "${INSTALL_PATH}"/macros/*.cfg; do
        filename=$(basename ${file});
        if !grep -q "include ${filename}" "${CONFIG_PATH}"/config/printer.cfg; then
            echo " - Missing [include ${filename}] in printer.cfg"
        fi
    done
}

function restart_klipper {
    echo "[POST-INSTALL] Restarting Klipper..."
    sudo systemctl restart klipper
}

printf "\n======================================\n"
echo "- Klipper toolchanger install script -"
echo "-                                    -"
echo "- If you are upgrading maybe sure to -"
echo "- you check for changes in the user  -"
echo "- config files                       -"
printf "======================================\n\n"

install=1;
if [ $1 == 'uninstall' ]; then
    install=0;
fi

# Run steps
if [ $install -eq 1]; then
    preflight_checks
    check_download
fi

remove_links

if [ $install -eq 1]; then
    link_extension
    link_macros
    copy_examples
    restart_klipper
fi
