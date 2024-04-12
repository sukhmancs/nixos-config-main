#
# pcloud fix
#

{ config, lib, pkgs, ... }:

let
  patchelfFixes = pkgs.patchelfUnstable.overrideAttrs (_finalAttrs: _previousAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "Patryk27";
      repo = "patchelf";
      rev = "527926dd9d7f1468aa12f56afe6dcc976941fedb";
      sha256 = "sha256-3I089F2kgGMidR4hntxz5CKzZh5xoiUwUsUwLFUEXqE=";
    };
  });
  pcloudFixes = pkgs.pcloud.overrideAttrs (_finalAttrs:previousAttrs: {
    nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [ patchelfFixes ];
  });
in
with lib;
{
  options.pcloud = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        PCloud Storage.
      '';
    };
  };

  config = mkIf config.pcloud.enable {
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = [
      pcloudFixes
    ];
  
    systemd.user.services.pcloud = {
      description = "PCloud Storage";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "/run/current-system/sw/bin/pcloud";
    };    
  };
}
