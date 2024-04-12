#
# GnuPG Agent
#

{ config, pkgs, ... }:

{
  # Enable the GnuPG module
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
#    pinentryPackage = pkgs.pinentry-gnome3; # provides better security for password entries

    settings = {
      default-cache-ttl = 32400; # 9 hours (32400 seconds) # use "gpgconf --reload gpg-agent" to clear the cache
      max-cache-ttl = 32400; # 9 hours (32400 seconds)
      debug-level = 4; # Advanced      
    };
  };
}
