#
# SETUP ME
#
# A discord customizer to install custom themes and plugins to discord. (even if u don't have discord nitro)
#
# You must install betterdiscord using betterdiscordctl before using this module:
#
# nix run nixpkgs#betterdiscordctl install
#

{ vars, ... }:

{
  home-manager.users.${vars.user} = {
    home.file.".config/BetterDiscord" = {
      source = ./BetterDiscord;
      recursive = true;
    };
  };
}
