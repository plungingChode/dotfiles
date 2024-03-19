{ pkgs, lib, specialArgs, ... }:

let 
  modules = builtins.readDir ./modules;

  toModuleDefinition = (file: type: 
    if type == "directory" then
      ./modules/${file}/default.nix
    else
      ./modules/${file}
  );

  firaCode = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
  astrojsLanguageServer = "@astrojs/language-server";
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

  # myLib.mkConfigSymlink = strPath:
  #   config.lib.file.mkOutOfStoreSymlink  "${config.xdg.configHome}/home-manager/${strPath}";

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Every .nix file from modules
  imports = lib.mapAttrsToList toModuleDefinition modules;

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    bc
    # bemenu # wayland clone of dmenu
    brightnessctl
    btop
    cargo
    du-dust
    fd
    firaCode 
    firefox-devedition-bin
    gcolor3
    # grim # screenshot tool
    # hyprpaper
    just
    # libreoffice
    lua
    lua52Packages.luarocks
    nodejs_18
    obsidian
    # php81
    # php81Packages.composer
    # qbittorrent
    sd
    xclip
    # slurp # screenshot tool
    # viewnior

    # Language servers
    lua-language-server
    nil
    nodePackages.${astrojsLanguageServer}
  ];

  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {};

  services.easyeffects.enable = true;

  programs.fzf.enable = true;
  programs.home-manager.enable = true;
  programs.ripgrep.enable = true;
  programs.tmux.enable = true;
  programs.zathura.enable = true;

  # Changing GTK theme on Wayland: https://www.reddit.com/r/NixOS/comments/nxnswt
  # Custom CSS for applications: https://forum.xfce.org/viewtopic.php?id=13322
  gtk = with specialArgs; {
    enable = true;
    font.name = "Open Sans";
    font.size = 9;
    font.package = pkgs.open-sans;
    # TODO reference package here, instead of in configuration.nix
    theme.name = "nordic-gtk-theme";
    iconTheme.name = "Papirus-Dark-Maia";
    iconTheme.package = unstable.papirus-maia-icon-theme;
    cursorTheme.name = "capitaine-cursors";
    cursorTheme.package = pkgs.capitaine-cursors;
    cursorTheme.size = 32;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors";
    size = 32;
  };
}
