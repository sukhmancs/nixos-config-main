#
#  ClamAv - Antivirus
#
{ config, lib, pkgs, ... }:

{  
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    pkgs.clamav
  ];

  services = {
    clamav = {
      daemon = {
        enable = true;
      };
      updater = {
        enable = true;
      };
    };
  };
}
