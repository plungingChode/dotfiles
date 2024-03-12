{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    # disableConfirmationPrompt = true;
    keyMode = "vi";
    mouse = true;
    prefix = "C-k";
    terminal = "alacritty";
    shell = "${pkgs.fish}/bin/fish";
  };
}
