{
  pkgs ? import <nixpkgs> { },
  system ? pkgs.stdenv.hostPlatform.system,
}:
let
  mkZen =
    name: entry:
    let
      variant = (builtins.fromJSON (builtins.readFile ./sources.json)).${entry}.${system};
    in
    pkgs.callPackage ./package.nix {
      inherit name variant;
    };
in
rec {
  beta-unwrapped = mkZen "beta" "beta";
  twilight-unwrapped = mkZen "twilight" "twilight";
  twilight-official-unwrapped = mkZen "twilight" "twilight-official";

  beta = pkgs.wrapFirefox.override { libcanberra-gtk3 = pkgs.libcanberra-gtk2; } beta-unwrapped {
    icon = "zen-browser";
  };
  twilight = pkgs.wrapFirefox.override {
    libcanberra-gtk3 = pkgs.libcanberra-gtk2;
  } twilight-unwrapped { };
  twilight-official = pkgs.wrapFirefox.override {
    libcanberra-gtk3 = pkgs.libcanberra-gtk2;
  } twilight-official-unwrapped { };

  default = beta;
}
