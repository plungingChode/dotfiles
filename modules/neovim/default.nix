{ config, home, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  xdg.configFile.nvim.source = 
    config.lib.file.mkOutOfStoreSymlink "/home/${home.username}/.config/home-manager/modules/neovim";
}
