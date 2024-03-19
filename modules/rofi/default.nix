{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = ./nord_theme.rasi;
    font = "FiraCode Nerd Font 12";
  };
}
