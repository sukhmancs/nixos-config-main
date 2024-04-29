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
        package = pkgs.rofi.override {plugins = [pkgs.rofi-calc];};
      };
    };

    home.file.".config/rofi" = {
      source = ./rofi;
      recursive = true;
    };
  };
}
