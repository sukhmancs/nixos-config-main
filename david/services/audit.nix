#
# Enable Linux Audit System
#

{ pkgs, vars, ... }:

{
    security.audit = {
      enable = true;
      rules = [
        "-w /etc/passwd -p rwxa"                 # log read, write, execute, attribute change access to this file
        "-w /etc/security/"                      # log any access to this file
        "-a exit,always -F arch=b64 -S execve"   # detect file ownership changes
      ];
    };
    security.auditd.enable = true;

    environment.etc."audit/auditd.conf" = {
      source = pkgs.writeText "auditd.conf" (builtins.replaceStrings ["\n  "] ["\n"] ''
      log_group = audit
    '');                                        # this just replaces new line character followed by 2 whitespaces with only a new line character
    };

    # start up aa-notify service
    systemd.services.aa-notify = {
      description = "AppArmor notify service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "/run/current-system/sw/bin/aa-notify -p -s 1 -w 60 -f /var/log/audit/audit.log";
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = "HOME=/home/${vars.user}";
        User = "${vars.user}";
      };
    };
}
