#
# rofi-pass - A simple rofi frontend for pass
#

{ config, lib, pkgs, vars, ... }:

{
  config = lib.mkIf (config.x11wm.enable) {
    home-manager.users.${vars.user} = {
      programs = { 
        rofi = {   # rofi-pass
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