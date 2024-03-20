{ pkgs, ... }:

{
  services.polybar = {
    enable = true;
    # TODO custom compile with i3 only
    package = pkgs.polybarFull;
    script = "${pkgs.writeShellScript "start-polybar" ''
      #!/usr/bin/env bash
      PATH=$PATH:/run/current-system/sw/bin polybar &
    ''}";
    config = ./config.ini;
  };
  # # By default it's wanted by `tray.target`. Correct it to use
  # # `graphical-session.target`.
  # systemd.user.services.polybar = {
  #   Install.WantedBy = [ "graphical-session.target" ]; 
  # };
}
