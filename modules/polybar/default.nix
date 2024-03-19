{ pkgs, ... }:

{
  services.polybar = {
    enable = true;
    # TODO custom compile with i3 only
    package = pkgs.polybarFull;
    script = "polybar &";
    config = ./config.ini;
  };
  home.sessionVariables = {
    POLYBAR_SCRIPTS_DIR = "$XDG_CONFIG_HOME/polybar";
  };
  # TODO start it manually from i3 config?
  # By default it's wanted by `tray.target`. Correct it to use
  # `graphical-session.target`.
  systemd.user.services.polybar = {
    Install.WantedBy = [ "graphical-session.target" ]; 
  };
}
