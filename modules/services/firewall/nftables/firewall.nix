#
# nftables configuration
#
# use the following command to get rev, hash, and other details about the repository
# nix-prefetch-git https://github.com/<username>/<repo>
#
{pkgs, ...}: let
  # configurationPath = pkgs.fetchurl {
  #   url = "https://raw.githubusercontent.com/sukhmancs/nixos-config/main/modules/services/firewall/nftables.conf";
  #   sha256 = "073k9rnpk380vygy4i7dw0ryfpsb7hwmis0w19y7wns6bhbsi2pa";
  # };
  rev = "acf3184da576324fa6e9b7d85d1bf909feb39d45";
  hash = "sha256-/hBV4r4761fg208o93vE4pJAhlXpNCzeI3TFpIDt6Dc=";
  configurationPath = pkgs.fetchFromGitHub {
    owner = "sukhmancs";
    repo = "nixos-config-main";
    rev = rev;
    hash = hash;
  };

  filePath = "${configurationPath}/david/services/firewall/nftables.conf";
in {
  networking = {
    nftables = {
      enable = true;
      # read content from the configurationPath
      ruleset = builtins.readFile filePath;
    };
  };
}
