{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ./interactive.fish;
    plugins = with pkgs; [
      { name = "fzf-fish";  src = fishPlugins.fzf-fish.src; }
    ];
    shellAbbrs = {
      docc = "docker compose";

      # Configuration
      hmrs = "home-manager switch";
      # Make /etc/hosts dynamic. Required for some VPN clients.
      nixrs = ''
        sudo nixos-rebuild switch && \
        sudo mv /etc/hosts /etc/hosts.bak && \
        sudo cp /etc/hosts.bak /etc/hosts && \
        sudo chmod u+w /etc/hosts
      '';
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
