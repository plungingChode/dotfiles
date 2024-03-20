{
  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
    };
  };

  home.sessionVariables = {
    MANPAGER = "bat --plain";
  };
}
