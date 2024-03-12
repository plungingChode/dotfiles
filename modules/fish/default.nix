{
  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ./interactive.fish; 
    shellAbbrs = {
      docc = "docker compose";
    };
  };
}
