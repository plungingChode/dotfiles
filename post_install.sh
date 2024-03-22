#!/usr/bin/env sh

source ./setup/lib.sh

# Change shell to fish
changeShell $(whoami) "/usr/bin/fish"

# Setup symlinks to /etc configuration files
linkWithBackup "pacman.conf"        "/etc/pacman.conf"
linkWithBackup "vconsole.conf"      "/etc/vconsole.conf"
# linkWithBackup "greetd.config.toml" "/etc/greetd/config.toml"
