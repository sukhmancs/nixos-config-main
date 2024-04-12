#
# Enable the Profile Sync daemon
# Make sure profile-sync-daemon package is installed
#

{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    pkgs.profile-sync-daemon    # Sync Browser profiles to tmpfs (enable systemd.psd.service as well)
  ];

  services = {
    psd = {
      enable = true;
      resyncTimer = "1h";
    };
  };
}
