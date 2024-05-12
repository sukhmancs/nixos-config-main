{
  lib,
  config,
  ...
}: let
  inherit (lib) mkMerge concatStringsSep mkForce;
in {
  services.fail2ban = {
    enable = true;
    maxretry = 5; # Observe 5 violations before banning an IP
    ignoreIP = [
      # Whitelisting some subnets:
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
      "10.0.0.248/24"
      "2607:fea8:ab62:4200::635f/128"
    ];
    bantime = "1h"; # Set bantime to one day
    jails = mkMerge [
      {
        # sshd jail
        sshd = mkForce ''
          enabled = true
          port = ${concatStringsSep "," (map toString config.services.openssh.ports)}
          mode = aggressive
        '';
      }
      {
        apache-nohome-iptables = ''
          # Block an IP address if it accesses a non-existent
          # home directory more than 5 times in 10 minutes,
          # since that indicates that it's scanning.
          filter = apache-nohome
          action = iptables-multiport[name=HTTP, port="http,https"]
          logpath = /var/log/httpd/error_log*
          backend = auto
          findtime = 600
          bantime  = 600
          maxretry = 5
        '';
      }
    ];
    bantime-increment = {
      enable = true;
      rndtime = "12m";
      overalljails = true;
      multipliers = "4 8 16 32 64 128 256 512 1024 2048";
      maxtime = "192h";
    };
  };
}
