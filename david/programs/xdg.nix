#
# Xdg - setup custom directories and xdg-portal to help open application interact with desktop
#
{
  pkgs,
  vars,
  ...
}: {
  home-manager.users.${vars.user} = {
    xdg = {
      enable = true;
      portal = with pkgs; {
        enable = true;
        configPackages = [xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-desktop-portal];
        extraPortals = [xdg-desktop-portal-gtk xdg-desktop-portal];
        xdgOpenUsePortal = true;
      };
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "$HOME/Desktop";
        publicShare = "$HOME/.local/public";
        templates = "$HOME/.local/templates";
      };
    };
  };
}
