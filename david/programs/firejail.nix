#
#  Firejail - Sandbox programs to give them restricted permissions
#

{ pkgs, vars, ... }:

let

  fetchProfiles = pkgs.fetchFromGitHub {
    owner = "chiraag-nataraj";
    repo = "firejail-profiles";
    rev = "fcd08dd32874f9fb5c856375659c434c922f156a";
    sha256 = "1w2j7bispzs0c8k8ic45m9bx6vlwddak7y829rg1j8ycqy6wazc3";
    fetchSubmodules = true;
  };
in
{
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
}
