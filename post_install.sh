#!/usr/bin/env sh

yay -S \
    extra/fish \
    extra/fisher \
    extra/alacritty \
    extra/neovim \
    extra/tmux \
    extra/starship \
    extra/ttf-firacode-nerd \
    extra/eza \
    extra/docker-compose \
    extra/docker \
    extra/zathura \
    extra/firefox-developer-edition \
    extra/go \
    extra/composer \
    extra/btop \
    extra/fzf \
    extra/sd \
    extra/jq \
    extra/ripgrep \
    extra/bat \
    extra/inotify-tools \
    extra/vlc \
    extra/qalculate-gtk \
    extra/stow \
    extra/jre-openjdk \
    extra/dbeaver \
    extra/brightnessctl \
    aur/nordic-theme

yay -R \
    xterm \
    endeavouros-xfce4-terminal-colors \
    xfce4-terminal

# Node version manager
fisher install jorgebucaran/nvm.fish

# Grub: save last selected entry
sudo sed -i "s/GRUB_DEFAULT=.*/GRUB_DEFAULT=saved/" /etc/default/grub
sudo sed -i "s/#GRUB_SAVEDEFAULT/GRUB_SAVEDEFAULT/" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Enble/start docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker
