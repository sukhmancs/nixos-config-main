###
### Nix-index provides a "command-not-found" script. 
### 
### Run following command to download the database 
### without any database command-not-found will not work:
###  
###   $ nix run github:nix-community/nix-index#nix-index 
###
### Example output: 
### $ blender
###  The program 'blender' is currently not installed. You can install it
###  by typing:
###    nix-env -iA nixpkgs.blender.out
###  
###  Or run it once with:
###    nix-shell -p blender.out --run ...
###

{ config, lib, pkgs, ... }:

{  
  # use "command-not-found" script provided by nix-shell
  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  # for home-manager, use programs.bash.initExtra instead
  #  programs.zsh.interactiveShellInit =
  #  ''
  #    source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
  #  '';
}
