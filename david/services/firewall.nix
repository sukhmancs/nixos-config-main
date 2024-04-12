#
# nftables configuration 
# 
# use the following command to get rev, hash, and other details about the repository
# nix-prefetch-git https://github.com/<username>/<repo>
#

{ pkgs, vars, ... }:

let 
  # configurationPath = pkgs.fetchurl {
  #   url = "https://raw.githubusercontent.com/sukhmancs/nixos-config/main/modules/services/firewall/nftables.conf";
  #   sha256 = "073k9rnpk380vygy4i7dw0ryfpsb7hwmis0w19y7wns6bhbsi2pa";
  # };
  
  rev = "9ce0685c54430defac174a90febf985428e8116e";  
  hash = "sha256-Aqd0a6Yx8FZdF5rvT12XhxPtNPau7qxZt7+qsKpQILE=";
  configurationPath = pkgs.fetchFromGitHub {
    owner = "sukhmancs";
    repo = "nixos-config";    
    rev = rev;
    hash = hash;
  };
  
  filePath = "${configurationPath}/modules/services/firewall/nftables.conf";
in 
{
  networking = {
    nftables = {
      enable = true;  
      # read content from the configurationPath
      ruleset = builtins.readFile filePath;        
    };
  };
}

