#!/usr/bin/env sh

function checkErr() {
    err=$?
    message=$1

    if [ $err -ne 0 ]; then
        logErr "${message:-Operation failed} (exit code: ${err})"
        exit 1
    fi
}

function logInfo() {
    echo "INF: $1"
}

function logErr() {
    echo "ERR: $1"
}

function linkWithBackup() {
    if [ "$#" -ne 2 ]; then
        logInfo "Exactly 2 arguments required"
        exit 1
    fi

    source=$(realpath "$1")
    dest="$2"

    if [ ! -e "$2" ]; then
        logInfo "CREATE ${dest} -> ${source}"
        # sudo ln -s "${source}" "${dest}"
        checkErr "Couldn't create link"
    fi

    if [ ! -L "${dest}" ]; then
        logInfo "BACKUP ${dest} -> ${dest}.bak"
        # sudo mv "${dest}" "${dest}.bak"
        checkErr "Couldn't create backup"
    fi

    # Delete and recreate link
    logInfo "CREATE ${dest} -> ${source}"
    sudo rm "${dest}"
    sudo ln -s "${source}" "${dest}"
    checkErr "Couldn't create backup for ${dest}"
}

# Change shell to fish
fish="/usr/bin/fish"
if [ ! -e "$fish" ]; then
    logErr "Fish is not installed! ('/usr/bin/fish' missing)"
    exit 1
fi
username=$(whoami)
loginShell=$(getent passwd "${username}"  | cut -d: -f7)
if [ "${loginShell}" != "${fish}" ]; then
    logInfo "Changing shell to ${fish}"
    sudo chsh -s /usr/bin/fish "${username}"
    checkErr "Failed to change shell to ${fish}"
fi

# [ -L "/etc/pacman.conf" ] && echo "it's a link"

linkWithBackup "pacman.conf" "/etc/pacman.conf"
linkWithBackup "greetd.config.toml" "/etc/greetd/config.toml"
