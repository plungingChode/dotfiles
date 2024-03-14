{ specialArgs, ... }:

{
  home.sessionVariables = with specialArgs; {
    BEMENU_OPTS = attrsToCliArgs bemenuDefaults;
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ./interactive.fish;
    shellAbbrs = {
      docc = "docker compose";
    };
  };
}
