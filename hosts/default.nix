#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix
#   └─ ./hosts
#       ├─ default.nix *
#       ├─ configuration.nix
#       └─ ./<host>.nix
#           └─ default.nix
#
{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  nixos-hardware,
  home-manager,
  nur,
  nixvim,
  doom-emacs,
  hyprland,
  hyprlock,
  hypridle,
  hyprspace,
  plasma-manager,
  agenix,
  catppuccin,
  izrss,
  vars,
  ...
}: let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in {
  # Desktop Profile
  beelink = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system unstable hyprland hyprlock hypridle hyprspace vars;
      host = {
        hostName = "beelink";
        mainMonitor = "HDMI-A-1";
        secondMonitor = "HDMI-A-2";
      };
    };
    modules = [
      nur.nixosModules.nur
      nixvim.nixosModules.nixvim
      ./beelink
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  # Work Profile
  work = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system unstable hyprland hyprlock hypridle hyprspace catppuccin izrss agenix vars;
      host = {
        hostName = "work";
        mainMonitor = "eDP-1";
        secondMonitor = "DP-4";
        thirdMonitor = "DP-5";
      };
    };
    modules = [
      nixvim.nixosModules.nixvim
      catppuccin.nixosModules.catppuccin
      ./work
      ./configuration.nix
      agenix.nixosModules.default

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  # Work Profile
  xps = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system unstable hyprland hyprlock hypridle hyprspace vars;
      host = {
        hostName = "xps";
        mainMonitor = "eDP-1";
        secondMonitor = "DP-4";
      };
    };
    modules = [
      nixos-hardware.nixosModules.dell-xps-15-9500-nvidia
      nixvim.nixosModules.nixvim
      ./xps
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  # VM Profile
  vm = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs unstable vars;
      host = {
        hostName = "vm";
        mainMonitor = "Virtual-1";
        secondMonitor = "";
      };
    };
    modules = [
      nixvim.nixosModules.nixvim
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };

  # DEPRECATED Desktop Profile
  h310m = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system unstable hyprland hyprlock hypridle hyprspace vars;
      host = {
        hostName = "h310m";
        mainMonitor = "HDMI-A-1";
        secondMonitor = "HDMI-A-2";
      };
    };
    modules = [
      nur.nixosModules.nur
      nixvim.nixosModules.nixvim
      ./h310m
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${vars.user}.imports = [
          nixvim.homeManagerModules.nixvim
        ];
      }
    ];
  };

  # DEPRECATED HP Probook Laptop Profile
  probook = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs unstable vars;
      host = {
        hostName = "probook";
        mainMonitor = "eDP-1";
        secondMonitor = "";
      };
    };
    modules = [
      nixvim.nixosModules.nixvim
      ./probook
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
