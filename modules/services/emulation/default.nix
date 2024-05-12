#
# Emulation - run binary compiled for AArch64 (ARM architechture) or i686 (x86) in specific version of qemu
# For example, run some binary through command line: ./somebinary
# the kernal will automatically detect the emulator for it and launch the qemu.
#
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.modules.system;
in {
  options.modules.system.emulation = {
    # should we enable emulation for additional architechtures?
    # enabling this option will make it so that you can build for, e.g.
    # aarch64 on x86_&4 and vice verse - not recommended on weaker machines
    enable = mkEnableOption ''
      emulation of additional arcitechtures via binfmt. enabling this option will make it so that the system can build for
      addiitonal systems such as aarc64 on x86_64 and vice versa.
    '';

    systems = mkOption {
      type = with types; listOf str;
      default = builtins.filter (system: system != pkgs.system) ["aarch64-linux" "i686-linux"];
      description = ''
        the systems to enable emulation for
      '';
    };
  };

  config = mkIf cfg.emulation.enable {
    nix.settings.extra-sandbox-paths = ["/run/binfmt" "${pkgs.qemu}"];

    boot.binfmt = {
      emulatedSystems = cfg.emulation.systems;
      registrations = {
        # aarch64 interpreter
        aarch64-linux = {
          interpreter = "${pkgs.qemu}/bin/qemu-aarch64";
        };

        # i686 interpreter
        i686-linux = {
          interpreter = "${pkgs.qemu}/bin/qemu-i686";
        };
      };
    };
  };
}
