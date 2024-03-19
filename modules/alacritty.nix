{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      # shell.program = "${pkgs.fish}/bin/fish";
      window.padding = {
        y = 5;
      };
      keyboard.bindings = [
        { action = "Last"; key = 5; mode = "Vi|~Search"; mods = "Shift"; }
        { action = "First"; key = 7; mode = "Vi|~Search"; mods = "Shift"; }
        { action = "SpawnNewInstance"; key = "Return"; mods = "Shift"; } # TODO doesn't work w/ hyprland
        { chars = "\u001B[15;4~"; key = "F5"; mods = "Shift"; } # TODO check
        { chars = "\u001B[15;6;5~"; key = "F5"; mods = "Control|Shift"; } # TODO check
      ];
      font = {
        size = 11;
        normal.family = "FiraCode Nerd Font";
      };
      colors = {
        cursor = {
          cursor = "#d8dee9";
          text = "#2e3440";
        };
        bright = {
          black = "#4c566a";
          blue = "#81a1c1";
          cyan = "#8fbcbb";
          green = "#a3be8c";
          magenta = "#b48ead";
          red = "#bf616a";
          white = "#eceff4";
          yellow = "#ebcb8b";
        };
        dim = {
          black = "#373e4d";
          blue = "#68809a";
          cyan = "#6d96a5";
          green = "#809575";
          magenta = "#8c738c";
          red = "#94545d";
          white = "#aeb3bb";
          yellow = "#b29e75";
        };
        normal = {
          black = "#1E2127";
          blue = "#81a1c1";
          cyan = "#88c0d0";
          green = "#a3be8c";
          magenta = "#b48ead";
          red = "#bf616a";
          white = "#e5e9f0";
          yellow = "#ebcb8b";
        };
        primary = {
          background = "#1E2127";
          dim_foreground = "#a5abb6";
          foreground = "#d8dee9";
        };
        search.matches = {
          background = "#88c0d0";
          foreground = "CellBackground";
        };
        selection = {
          background = "#4c566a";
          text = "CellForeground";
        };
        vi_mode_cursor = {
          cursor = "#d8dee9";
          text = "#2e3440";
        };
      };
    };
  };
}
