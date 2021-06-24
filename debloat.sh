#!/bin/bash
function usage() {
    echo -e "USAGE: ${0} -l <PKG_LIST_FILE> -a <ACTION>" 1>&2
    echo -e "\t -l Package List File - List of packages to take action on." 1>&2
    echo -e "\t -a Action to take - disable, uninstall, or enable." 1>&2
    exit 1
}

function check_adb() {
    # check if adb is installed
    if ! which adb > /dev/null; then
        echo "ADB is not installed please install it and try running it again."
    fi
}

function enable_package() {
    echo "[ENABLING] ${1}..."
    adb shell <<< "pm enable --user 0 ${1}"
}

function disable_package() {
    echo "[DISABLING] ${1}..."
    adb shell <<< "pm disable-user --user 0 ${1}"
}

function uninstall_package() {
    echo "[UNINSTALLING] ${1}..."
    adb shell <<< "pm uninstall -k --user 0 ${1}"
}

while getopts ":l:a:" o; do
    case "${o}" in
        l)
            PACKAGE_LIST_FILE=${OPTARG}
            ;;
        a)
            ACTION=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

if [ -z "${PACKAGE_LIST_FILE}" ] || [ -z "${ACTION}" ]; then
    echo "ERROR: missing one or more required arguments!"
    usage
fi

check_adb

cat $PACKAGE_LIST_FILE | while read -r pkg; do
    if [ -n "$pkg" ]; then
        eval "${ACTION}_package ${pkg}"
    fi
done
