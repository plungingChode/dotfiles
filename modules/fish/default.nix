{ specialArgs, ... }:

{
  #home.sessionVariables = with specialArgs; {
  #  BEMENU_OPTS = attrsToCliArgs bemenuDefaults;
  #};
  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ./interactive.fish;
    shellAbbrs = {
      docc = "docker compose";
      hmrs = "home-manager switch";
      nixrs = "sudo nixos-rebuild switch";
      homecfg = ''
        cd ~/.config/home-manager 
        if not test $TMUX
          tmux new -s home-configuration "vim ."
        else
          vim .
        end
      '';
    };
  };
}
