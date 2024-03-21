{ specialArgs, ... }:

{
  programs.fzf = {
    enable = true;
    package = specialArgs.unstable.fzf; 
    enableFishIntegration = false;
    # TODO colors
  };
}
