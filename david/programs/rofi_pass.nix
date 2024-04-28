#
# rofi-pass - A simple rofi frontend for pass
#
{
  pkgs,
  vars,
  ...
}: {
  config = {
    home-manager.users.${vars.user} = {
      programs = {
        rofi = {
          # rofi-pass
          pass = {
            enable = true;
            package = pkgs.rofi-pass-wayland;
          };
        };
      };

      home.file.".config/rofi-pass" = {
        source = ./rofi-pass;
        recursive = true;
      };
    };
  };
}
