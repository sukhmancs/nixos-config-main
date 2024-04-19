#
#  Network Shares
#

{ vars, ... }:

{
  services = {
    samba = {
      enable = true;
      shares = {
        # Set Password: $ smbpasswd -a <user>
        share = {
          "path" = "/home/${vars.user}/share";
          "guest ok" = "yes";
          "read only" = "no";
        };
      };
      openFirewall = true;
    };
  };
}
