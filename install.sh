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
    echo "[UNINSTALL] Remove old links..."
    for path in "${KLIPPER_PATH}"/klippy/extras/ "${CONFIG_PATH}"/config/; do
        for file in $(find "${path}" -type l); do
            if readlink -f "${file}" | grep -q "${INSTALL_PATH}"; then
              rm ${file};
            fi
        done
    done
    echo
}

function link_extension {
    echo "[INSTALL] Linking extension to Klipper..."
    for file in "${INSTALL_PATH}"/klipper/extras/*.py; do
        ln -sfn ${file} "${KLIPPER_PATH}"/klippy/extras/;
    done
    echo
}

function link_macros {
    echo "[INSTALL] Linking macros to Klipper..."
    for file in "${INSTALL_PATH}"/macros/*.cfg; do
        ln -sfn ${file} "${CONFIG_PATH}"/config/;
    done
    echo
}

function copy_examples {
    echo "[INSTALL] Copying in examples to Klipper..."
    for file in "${INSTALL_PATH}"/examples/*.cfg; do
        cp -n ${file} "${CONFIG_PATH}"/config/;
    done
    echo
}

function check_includes {
    echo "[CHECK-INSTALL] Checking for missing includes..."
    for file in "${INSTALL_PATH}"/macros/*.cfg; do
        filename=$(basename ${file});
        if ! grep -q "include ${filename}" "${CONFIG_PATH}"/config/printer.cfg; then
            echo " - Missing [include ${filename}] in printer.cfg"
        fi
    done
    echo
}

function restart_klipper {
    echo "[POST-INSTALL] Restarting Klipper..."
    sudo systemctl restart klipper
    echo
}

printf "\n======================================\n"
echo "- Klipper toolchanger install script -"
printf "======================================\n\n"

doinstall=1;
if [ $# -gt 0 ]; then
    if [ "$1" == "uninstall" ]; then
        doinstall=0;
    fi
fi

# Run steps
if [ $doinstall -gt 0 ]; then
    preflight_checks
    check_download
fi

remove_links

if [ $doinstall -gt 0 ]; then
    link_extension
    link_macros
    copy_examples
    check_includes
    restart_klipper

    printf "======================================\n"
    echo "- If you are upgrading maybe sure to -"
    echo "- you check for changes in the user  -"
    echo "- config files                       -"
    printf "======================================\n\n"
fi
