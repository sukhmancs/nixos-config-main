#
# Xdg - setup custom directories
#
{
  pkgs,
  vars,
  ...
}: {
  home-manager.users.${vars.user} = {
    xdg = {
      enable = true;
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
