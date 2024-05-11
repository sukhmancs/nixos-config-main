{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
  cfg = config.modules.programs.kdeconnect;
in {
  options.modules.programs = {
    kdeconnect = {
      enable = mkEnableOption "Enable kdeconnect";
      indicator.enable = mkEnableOption "Enable kdeconnect indicator";
    };
  };

  services.kdeconnect = lib.mkIf cfg.enable {
    enable = true;
    indicator = cfg.indicator.enable;
  };
}
