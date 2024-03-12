{ config, pkgs, lib, ... }:

let 
  modules = builtins.readDir ./modules;

  toModuleDefinition = (file: type: 
    if type == "directory" then
      ./modules/${file}/default.nix
    else
      ./modules/${file}
  );

in
{

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "chode";
  home.homeDirectory = "/home/chode";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; 
  home.enableNixpkgsReleaseCheck = false; # TODO disable after downgrading home-manager to 23.11

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Every .nix file from modules
  imports = lib.mapAttrsToList toModuleDefinition modules;

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    bc
    bemenu # wayland clone of dmenu
    brightnessctl
    btop
    cargo
    du-dust
    fd
    firefox-devedition-bin
    hyprpaper
    just
    libreoffice
    obsidian
    sd
  ];

  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {};

  services.easyeffects.enable = true;

  programs.fzf.enable = true;
  programs.home-manager.enable = true;
  programs.ripgrep.enable = true;
  programs.tmux.enable = true;
  programs.zathura.enable = true;
}
