###
### Run unpatched binaries on Nix/NixOS
###

{ ... }:

let
  nix-alien-pkgs = import (
    builtins.fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master"
  ) { };
in
{
  environment.systemPackages = with nix-alien-pkgs; [
    nix-alien
  ];
}
