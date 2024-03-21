{ pkgs, ... }:

{
  xdg.desktopEntries = {
    firefox-developer-edition-work-profile = {
      name = "Firefox DevEdition (Work)";
      genericName = "Web browser";
      exec = ''/usr/bin/env sh -c "${pkgs.firefox-devedition-bin}/bin/firefox-developer-edition --profile \\$HOME/.mozilla/firefox/work"'';
      terminal = false;
      categories = [ "Network" "WebBrowser" ];
    };
  };
}
