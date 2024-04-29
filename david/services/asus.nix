#
# Setup for Asus laptop. Enabled power management, power profiles using power-profiles-daemon, and rog-control-center. Also enables supergfxd for GPU switching. Added some scripts to control power profiles and GPU switching. eg, asusrog-gosilent, asusrog-gosave, asusrog-gonormal, asusrog-goboost, asusrog-dgpu-enable, asusrog-dgpu-disable, asusrog-monitor-mhz, powerprofilesctl-cycle. Also added a systemd service to set the battery threshold to 60% to protect the battery life.
# Run these scripts using following commands:
#     asusrog-gosilent - set power profile to power-saver
#     asusrog-gosave - set power profile to power-saver and set CPU governor to conservative
#     asusrog-gonormal - set power profile to balanced
#     asusrog-goboost - set power profile to performance and set CPU governor to ondemand
#     asusrog-dgpu-enable - enable discrete GPU
#     asusrog-dgpu-disable - disable discrete GPU
#     asusrog-monitor-mhz - monitor CPU frequency
#     powerprofilesctl-cycle - cycle through power profiles
#
{
  config,
  pkgs,
  ...
}: {
  # power management
  systemd.services.batterThreshold = {
    script = ''
      echo 60 | tee /sys/class/power_supply/BAT0/charge_control_end_threshold
    '';
    wantedBy = ["multi-user.target"];
    description = "Set the charge threshold to protect battery life";
    serviceConfig = {
      Restart = "on-failure";
    };
  };

  powerManagement.powertop.enable = true;
  # The amount of time the system spends in suspend mode before the system is automatically put into hibernate mode.
  systemd.sleep.extraConfig = "HibernateDelaySec=5min";
  services.auto-cpufreq.enable = true;
  services.thermald.enable = true; # temperature management daemon
  services.supergfxd = {
    enable = true;
    settings = {
      # mode = "Integrated";
      vfio_enable = true;
      vfio_save = false;
      always_reboot = false;
      no_logind = false;
      logout_timeout_s = 20;
      hotplug_type = "Asus";
    };
  };
  systemd.services.supergfxd.path = [pkgs.kmod pkgs.pciutils];
  environment.systemPackages = with pkgs; [
    radeontop
    powertop
    config.boot.kernelPackages.turbostat
    config.boot.kernelPackages.cpupower
    # pkgs.cudatoolkit # TODO: Maybe add this again when there is more internet
    ryzenadj
    # pkgs.cudaPackages.cuda-samples
    pciutils
    (writeShellScriptBin "powerprofilesctl-cycle" ''
      case $(powerprofilesctl get) in
        power-saver)
          notify-send -a \"changepowerprofile\" -u low -i /etc/nixos/xmonad/icon/powerprofilesctl-balanced.png \"powerprofile: balanced\"
          powerprofilesctl set balanced;;
        balanced)
          notify-send -a \"changepowerprofile\" -u low -i /etc/nixos/xmonad/icon/powerprofilesctl-performance.png \"powerprofile: performance\"
          powerprofilesctl set performance;;
        performance)
          notify-send -a \"changepowerprofile\" -u low -i /etc/nixos/xmonad/icon/powerprofilesctl-power-saver.png \"powerprofile: power-saver\"
          powerprofilesctl set power-saver;;
      esac
    '')
    (writeShellScriptBin "asusrog-dgpu-disable" ''
      echo 1 |sudo tee /sys/devices/platform/asus-nb-wmi/dgpu_disable
      echo 0 |sudo tee /sys/bus/pci/rescan
      echo 1 |sudo tee /sys/devices/platform/asus-nb-wmi/dgpu_disable
      echo "please logout and login again to use integrated graphics"
    '')
    (writeShellScriptBin "asusrog-dgpu-enable" ''
      echo 0 |sudo tee /sys/devices/platform/asus-nb-wmi/dgpu_disable
      echo 1 |sudo tee /sys/bus/pci/rescan
      echo 0 |sudo tee /sys/devices/platform/asus-nb-wmi/dgpu_disable
      echo "please logout and login again to use discrete graphics"
    '')
    (writeShellScriptBin "asusrog-goboost" ''
      (set -x; powerprofilesctl set performance; sudo cpupower frequency-set -g ondemand >&/dev/null;)
    '')
    (writeShellScriptBin "asusrog-gonormal" ''
      (set -x; powerprofilesctl set balanced; sudo cpupower frequency-set -g schedutil >&/dev/null;)
    '')
    (writeShellScriptBin "asusrog-gosilent" ''
      (set -x; powerprofilesctl set power-saver; sudo cpupower frequency-set -g schedutil >&/dev/null;)
    '')
    (writeShellScriptBin "asusrog-gosave" ''
      (set -x; sudo ryzenadj --power-saving >&/dev/null; powerprofilesctl set power-saver; sudo cpupower frequency-set -g conservative >&/dev/null;)
    '')
    (writeShellScriptBin "asusrog-monitor-mhz" ''
      watch -n.1 "grep \"^[c]pu MHz\" /proc/cpuinfo"
    '')
  ];
  programs.rog-control-center.enable = true;
  services.asusd = {
    enable = true;
    enableUserService = true;
    # fanCurvesConfig = builtins.readFile ../config/fan_curves.ron;
  };
  services.power-profiles-daemon.enable = true;
}
