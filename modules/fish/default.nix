{ specialArgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ./interactive.fish;
    shellAbbrs = {
      docc = "docker compose";

      # Configuration
      hmrs = "home-manager switch";
      nixrs = "sudo nixos-rebuild switch";
      nixsh = "nix-shell --command fish -p";
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
