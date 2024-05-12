#
#  Services
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./services
#           └─ default.nix *
#               └─ ...
#
[
  ./firewall
  ./avahi.nix
  # ./dunst.nix
  ./flameshot.nix
  ./picom.nix
  ./polybar.nix
  ./samba.nix
  ./swaync.nix
  ./sxhkd.nix
  ./udiskie.nix
  ./tailscale.nix
  ./optimise.nix
  ./blocker.nix
  ./ssh.nix
  ./tcpcrypt.nix
  ./apparmor.nix
  ./selinux.nix
  ./kernel.nix
  ./pam.nix
  ./sudo.nix
  ./virtualization.nix
  ./networkmanager.nix
]
