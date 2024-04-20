#
#  Specific system configuration settings for work
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ ./work
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       ├─ ./desktops
#       │   ├─ hyprland.nix
#       │   └─ ./virtualisation
#       │       └─ default.nix
#       └─ ./hardware
#           └─ ./work
#               └─ default.nix
#

{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ] ++
    (import ../../modules/desktops/virtualisation) ++
    (import ../../modules/hardware/work) ++
    (import ../../david/programs) ++
    (import ../../david/services);

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 2;
        default = 2;
        theme = pkgs.stdenv.mkDerivation {
          pname = "Grub-Themes";
          version = "3.1";
          src = pkgs.fetchFromGitHub {
            owner = "sukhmancs";
            repo = "Grub-Themes";
            rev = "9e9826a4151f66848ffa7df4f92b74be45e1921b";
            hash = "sha256-buRtbDBd6x8PmVyK7tHcj5KhJW91YDQ1B5haQEhLiZU=";
          };
          installPhase = "cp -r Anime/ $out";
        };
      };
      timeout = null;
    };
  };

  laptop.enable = true;
  hyprland.enable = true;

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      ansible # Automation
      nil # LSP
      rclone # Gdrive ($ rclone config | rclone mount --daemon gdrive: <mount> | fusermount -u <mount>)
      simple-scan # Scanning
      sshpass # Ansible dependency
      wacomtablet # Tablet
      wdisplays # Display Configurator
    ];
  };

  programs.light.enable = true;

  flatpak = {
    extraPackages = [
      "com.github.tchx84.Flatseal"
    ];
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
