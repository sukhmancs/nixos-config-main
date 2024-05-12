{
  lib,
  config,
  host,
  vars,
  ...
}:
with host; let
  inherit (lib) mkIf mkOption types;
  cfg = config.modules.programs;
in {
  options.modules.programs = {
    kdeconnect = mkOption {
      type = types.bool;
      default = hostName != "server" && hostName != "vm";
      description = ''
        Enable kdeconnect for laptop and desktop
      '';
    };
    indicator = mkOption {
      type = types.bool;
      default = hostName != "server" && hostName != "vm";
      description = ''
        Enable indicator for kdeconnect
      '';
    };
  };

  config = mkIf cfg.kdeconnect {
    home-manager.users.${vars.user} = {
      services.kdeconnect = {
        enable = true;
        indicator = cfg.indicator;
      };
    };
  };
}
