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
    };
  };
}
