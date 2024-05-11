{
  config,
  lib,
  host,
  ...
}:
with host; let
  inherit (lib) mkIf mkOption types;
  cfg = config.tcpcrypt;
in {
  options.tcpcrypt = mkOption {
    type = types.bool;
    default = hostName == "work" || hostName == "beelink";
    description = ''
      Enable tcpcrypt for hostnames "work" and "beelink"
    '';
  };

  # enable opportunistic TCP encryption
  # this is NOT a pancea, however, if the receiver supports encryption and the attacker is passive
  # privacy will be more plausible (but not guaranteed, unlike what the option docs suggest)
  config = mkIf cfg {
    networking.tcpcrypt.enable = true;

    users = {
      groups.tcpcryptd = {};
      users.tcpcryptd = {
        group = "tcpcryptd";
        isSystemUser = true;
      };
    };
  };
}
