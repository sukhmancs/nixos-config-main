#
#  NVIDIA drivers so that the laptop video card can get offloaded to specific applications.
#  Either start the desktop or packages using nvidia-offload.
#  For example: $ nvidia-offload kdenlive
#  Currently only used with work laptop using NVIDIA MX330
#

{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  environment.systemPackages = [ nvidia-offload ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    opengl.enable = true;
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.production;
      prime = {
        offload.enable = true;
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      modesetting.enable = true;
      # powerManagement.enable = true;
      powerManagement.finegrained = true;
    };
  };
}
