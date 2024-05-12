#
# distrobox
#
{
  lib,
  host,
  ...
}:
with host; let
  inherit (lib) mkIf;
in {
  config = mkIf (hostName != "vm" && hostName != "server") {
    environment.systemPackages = with pkgs; [
      distrobox
    ];

    systemd.user = mkIf cfg.distrobox.enable {
      timers."distrobox-update" = {
        enable = true;
        wantedBy = ["timers.target"];
        timerConfig = {
          OnBootSec = "1h";
          OnUnitActiveSec = "1d";
          Unit = "distrobox-update.service";
        };
      };

      services."distrobox-update" = {
        enable = true;
        script = ''
          ${pkgs.distrobox}/bin/distrobox upgrade --all
        '';
        serviceConfig = {
          Type = "oneshot";
        };
      };
    };
  };
}
