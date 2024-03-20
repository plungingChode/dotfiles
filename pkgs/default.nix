{ pkgs, ... }: 
let
  callPackage = pkgs.callPackage;
in {
  nixpkgs.overlays = [
    (final: prev: {
      myPackages = {
        nordic-gtk-theme = callPackage ./nordic-gtk-theme.nix {};
        astro-language-server = callPackage ./astro-language-server/default.nix {};
      };
    })
  ];
}


