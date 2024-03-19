{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };
  # xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
}
