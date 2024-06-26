#
#  Apps
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./programs
#           ├─ default.nix *
#           └─ ...
#
[
  ./alacritty.nix
  ./accounts.nix
  ./eww.nix
  ./flatpak.nix
  ./kitty.nix
  ./obs.nix
  ./rofi.nix
  ./waybar.nix
  ./wofi.nix
  ./kdeconnect.nix
  # ./nh.nix # this is only available on nixos-unstable
  # ./games.nix
]
