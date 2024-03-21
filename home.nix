{ pkgs, lib, ... }:

let 
  modules = builtins.readDir ./modules;

  toModuleDefinition = (file: type: 
    if type == "directory" then
      ./modules/${file}/default.nix
    else
      ./modules/${file}
  );

  astrojs-language-server = "@astrojs/language-server";
in
rec {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "chode";
  home.homeDirectory = "/home/chode";
  # TODO move to common (somehow)
  systemd.user.settings.Manager.DefaultEnvironment = {
    CUSTOM_SCRIPTS_DIR = "${home.homeDirectory}/.config/home-manager/scripts";
  };

  # Every .nix file from modules
  imports = lib.mapAttrsToList toModuleDefinition modules;

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    xclip # system clipboard
    xcolor # color picker

    # Development
    openconnect
    vpn-slice
    docker  
    cargo
    nodejs_18
    php81
    php81Packages.composer
    beekeeper-studio

    # Language servers
    lua-language-server
    nil
    phpactor
    nodePackages.${astrojs-language-server}
  ];
}
