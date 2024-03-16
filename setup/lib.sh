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

function changeShell() {
    username=$1
    newShell=$2
    if [ ! -e "$newShell" ]; then
        logErr "Selected shell is not installed! ('${newShell}' doesn't exist)"
        exit 1
    fi

    # Get current (login) shell
    loginShell=$(getent passwd "${username}"  | cut -d: -f7)
    if [ "${loginShell}" != "${newShell}" ]; then
        logInfo "Changing shell to ${newShell}"
        sudo chsh -s /usr/bin/fish "${username}"
        checkErr "Failed to change shell to ${newShell}"
    fi
}

