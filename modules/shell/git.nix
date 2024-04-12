#
#  Git
#

{ pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      config = {
        credential = {
          helper = "${pkgs.pass-git-helper}/bin/pass-git-helper";
        };
      };
    };
  };
}
