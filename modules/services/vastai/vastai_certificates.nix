#
# Install system-wide certificate for vast.ai
#
{ config, lib, pkgs, vars, ... }:

with lib;
let
  vastAICertificateFilePath = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/sukhmancs/nixos-config/main/modules/services/certificates/jvastai_root.cer?token=GHSAT0AAAAAACNNH7DGI4QLXGE6SZBIIF74ZQAMVZQ";
    sha256 = "1criip3mqn6lggdsv91s6n45gbpcpdh27gxiijvhjydwf8aclm7h";
  };
in
{
  options.certificates = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Install system-wide certificate eg, for vast.ai
      '';
    };
    certificateFile = mkOption {
      type = types.path;
      default = vastAICertificateFilePath;
      description = mdDoc ''
        Path to the certificate file.
      '';
    };
  };

  config = mkIf config.certificates.enable {
    security = {
      pki = {
        certificateFiles = [ config.certificates.certificateFile ];
      };
    };
  };
}
