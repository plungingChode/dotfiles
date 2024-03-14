# Setup a custom Nix package: https://discourse.nixos.org/t/28969
# Obtaining package hashes: https://github.com/NixOS/nixpkgs/issues/191128

{
  stdenvNoCC,
  fetchFromGitHub,
  gtk-engine-murrine,
}:

# TODO: move to home manager?
stdenvNoCC.mkDerivation {
  pname = "nordic-gtk-theme";
  version = "unstable-2024-03-13";
  propagatedUserEnvPkgs = [gtk-engine-murrine];
  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "Nordic";
    rev = "1c272811098266ab7a865039c59113068c0dcf9f";
    hash = "sha256-pwG/p2L5snbqnC7YHtDAJqdWdxKwdhIP44uBcBVRP/8=";
  };
  installPhase = ''
    mkdir -p $out/share/themes/
    cp --archive . $out/share/themes/nordic-gtk-theme
  '';
}
