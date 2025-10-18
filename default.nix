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
  wrapper =
    if pkgs.stdenv.hostPlatform.isDarwin then
      pkgs.wrapFirefox.override { libcanberra-gtk3 = pkgs.libcanberra-gtk2; }
    else
      pkgs.wrapFirefox;
in
rec {
  beta-unwrapped = mkZen "beta" "beta";
  twilight-unwrapped = mkZen "twilight" "twilight";
  twilight-official-unwrapped = mkZen "twilight" "twilight-official";

  beta = wrapper beta-unwrapped {
    icon = "zen-browser";
  };
  twilight = wrapper twilight-unwrapped { };
  twilight-official = wrapper twilight-official-unwrapped { };

  default = beta;
}
