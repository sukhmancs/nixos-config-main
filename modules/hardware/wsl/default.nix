#
# Run NixOS on Windows Subsystem for Linux (WSL, WSL2)
#
{
  inputs,
  lib,
  vars,
  ...
}: let
  inherit (lib) mkForce;
in {
  imports = [inputs.nixos-wsl.nixosModules.wsl];
  config = {
    wsl = {
      enable = true;
      defaultUser = "${vars.user}";
      startMenuLaunchers = true;
    };

    services = {
      smartd.enable = mkForce false; # Unavailable - device lacks SMART capability.
      xserver.enable = mkForce false;
    };

    networking.tcpcrypt.enable = mkForce false;
  };
}
