#
# Configurable inbound and outbound firewall
#

{ config, pkgs, vars, lib, ... }:

with lib;
{
  options.opensnitch = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Configurable inbound and outbound firewall
      '';
    };
  };

  config = mkIf config.opensnitch.enable {
    services.opensnitch = {
      enable = true;
      rules = {
        systemd-timesyncd = {
          name = "systemd-timesyncd";
          enabled = true;
          action = "allow";
          duration = "always";
          operator = {
            type ="simple";
            sensitive = false;
            operand = "process.path";
            data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-timesyncd";
          };
        };
        systemd-resolved = {
          name = "systemd-resolved";
          enabled = true;
          action = "allow";
          duration = "always";
          operator = {
            type ="simple";
            sensitive = false;
            operand = "process.path";
            data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-resolved";
          };
        };
      };
    };
  
  
    home-manager.users.${vars.user} = {
      services.opensnitch-ui.enable = true;
    };    
  };
}
