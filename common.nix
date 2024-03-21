{ pkgs, specialArgs, ... }:

let 
  fira-code = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
in 
{
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

  programs.home-manager.enable = true;
  programs.ripgrep.enable = true;
  programs.tmux.enable = true;
  programs.zathura.enable = true;

  home.packages = with pkgs; [
    brightnessctl
    btop
    du-dust
    fd
    fira-code 
    firefox-devedition-bin
    just
    libreoffice
    lua
    lua52Packages.luarocks
    obsidian
    qbittorrent
    sd
    viewnior
  ];

  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    CUSTOM_SCRIPTS_DIR = "$XDG_CONFIG_HOME/home-manager/scripts";
  };
  # Add an empty tray.target to make polybar and flameshot work
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  # Set zoom level in X11
  # TODO remove for sway
  xresources.properties = {
    dpi = 125;
    "Xft.dpi" = 125;
  };

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

