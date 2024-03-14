#!/usr/bin/env sh

username=$(whoami)
case "${username}" in
    chode) 
        machine="personal"
        ;;
    pszigeti)
        machine="work"
        ;;
    *)
        echo "Unknown username, no machine assigned"
        exit 1
        ;;
esac

scriptdir=$(dirname $0)
for f in ${scriptdir}/machines/${machine}/*; do
    filename=$(basename $f)
    path=$(realpath $f)
    sudo ln -s "${path}" "/etc/nixos/${filename}" 
    ln_result=$?
done

# Don't bother managing Neovim packages with Nix
mkdir -p "/home/${username}/.config/"
sudo ln -s "${scriptdir}/modules/neovim" "/home/${username}/.config/nvim"

if [ $ln_result -ne 0 ]; then
    echo "Configuration linking failed with code: ${ln_result}"
    exit 1
fi

echo "rebuilding..."
sudo nixos-rebuild switch
