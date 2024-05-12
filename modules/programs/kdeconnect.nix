{
  lib,
  config,
  host,
  ...
}:
with host; let
  inherit (lib) mkOption types;
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

  services.kdeconnect = lib.mkIf cfg.kdeconnect {
    enable = true;
    indicator = cfg.indicator;
  };
}
