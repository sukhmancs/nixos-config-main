#
# Linux Pluggable Authentication Modules (PAM)
#

{ pkgs, vars, ... }:

{
  security.pam.services = {
    su = { # allow only users in the group wheel to login using su
      requireWheel = true;
    };
  };
}
