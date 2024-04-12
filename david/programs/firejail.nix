#
#  Firejail - Sandbox programs to give them restricted permissions
#

{ config, pkgs, lib, vars, ... }:

with lib;

let
  cfg = config.firejail;

  fetchProfiles = pkgs.fetchFromGitHub {
    owner = cfg.profilesGitHub.owner;
    repo = cfg.profilesGitHub.repo;
    rev = cfg.profilesGitHub.rev;
    sha256 = cfg.profilesGitHub.sha256;
    fetchSubmodules = true;
  };
 in
{
  options.firejail = {
    enable = mkEnableOption "Firejail";

    profilesGitHub = {
      owner = mkOption {
        type = types.str;
        description = "GitHub repository owner for custom profiles";
      };

      repo = mkOption {
        type = types.str;
        description = "GitHub repository name for custom profiles";
      };

      rev = mkOption {
        type = types.str;
        default = "main";
        description = "Git revision to fetch (can be a branch or tag)";
      };

      sha256 = mkOption {
        type = types.str;
        description = "Expected SHA-256 hash of the fetched data";
      };
    };
  };
  
  config = mkIf config.firejail.enable {
    # enable firejail
    programs.firejail.enable = true;

    home-manager.users.${vars.user} = {
      home.file.".config/firejail/common.inc" = {
        source = "${fetchProfiles}/common.inc";
      };
    };

    # custom google-chrome firejail profile
    environment.etc."firejail/google-chrome.profile" = {
      source = "${fetchProfiles}/google-chrome.profile";
    };

    # create system-wide executables firefox and chromium
    # that will wrap the real binaries so everything
    # work out of the box.
    programs.firejail.wrappedBinaries = { 
#      google-chrome = {
#        executable = "${pkgs.lib.getBin pkgs.google-chrome}/bin/google-chrome";
#        profile = "/etc/firejail/google-chrome.profile";
#        extraArgs = [
#          # sandbox Xorg to restrict keyloggers
#          "--x11=xephyr"
#        ];
#      };
      firefox = {
        executable = "${pkgs.lib.getBin pkgs.firefox}/bin/firefox";
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
        extraArgs = [
          # Required for U2F USB stick
          "--ignore=private-dev"
          # Enforce dark mode
          "--env=GTK_THEME=Adwaita:dark"
          # Enable system notifications
          "--dbus-user.talk=org.freedesktop.Notifications"
        ];
      };
    }; 
  };
}
