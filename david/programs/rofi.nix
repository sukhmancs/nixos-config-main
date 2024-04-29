#
#  System Menu
#
{
  pkgs,
  vars,
  ...
}: {
  home-manager.users.${vars.user} = {
    programs = {
      rofi = {
        enable = true;
      };
    };

    home.file.".config/rofi" = {
      source = ./rofi;
      recursive = true;
    };
  };
}
