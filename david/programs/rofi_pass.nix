#
# rofi-pass - A simple rofi frontend for pass
#
{
  config,
  lib,
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

