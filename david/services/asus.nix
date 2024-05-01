#
# Setup for Asus laptop. Enabled power management, power profiles using power-profiles-daemon, and rog-control-center. Also enables supergfx for GPU switching. Added some scripts to control power profiles and GPU switching. eg, asusrog-gosilent, asusrog-gosave, asusrog-gonormal, asusrog-goboost, asusrog-dgpu-enable, asusrog-dgpu-disable, asusrog-monitor-mhz, powerprofilesctl-cycle. Also added a systemd service to set the battery threshold to 60% to protect the battery life.
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
      echo 80 | tee /sys/class/power_supply/BAT0/charge_control_end_threshold
    '';
    wantedBy = ["multi-user.target"];
    description = "Set the charge threshold to protect battery life";
    serviceConfig = {
      Restart = "on-failure";
    };
  };

  # powerManagement.powertop.enable = true; #  powertop enables USB auto-suspend by default.
  # The amount of time the system spends in suspend mode before the system is automatically put into hibernate mode.
  systemd.sleep.extraConfig = "HibernateDelaySec=5min";
  services.auto-cpufreq.enable = true; # auto-cpufreq is a CPU speed and power optimizer for Linux.
  services.thermald.enable = true; # temperature management for intel processors
  # supergfxd for GPU switching
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
    radeontop # monitor GPU usage
    powertop # monitor power usage
    config.boot.kernelPackages.turbostat # monitor CPU frequency
    config.boot.kernelPackages.cpupower # monitor CPU frequency
    # pkgs.cudatoolkit # TODO: Maybe add this again when there is more internet
    ryzenadj # adjust power settings for ryzen processors
    libnotify # for notifications (notify-send)
    # pkgs.cudaPackages.cuda-samples
    pciutils # for lspci command
    # this scripts will control power profiles and GPU switching
    # I do not know how exactly powerprofiles-daemon works, but based on their gitlab descriptions, it sets up some profiles that will probably update the CPU governors and update the Scaling drivers to act accordingly. It also depends on p-state scaling drivers such as amd_pstate. So because my AMD cpu does not suppert p-state drivers (i.e. default to using acpi_cpufreq), 'performance' profile will not be available or will not work.
    (writeShellScriptBin "powerprofilesctl-cycle" ''
      case $(powerprofilesctl get) in
        power-saver)
          notify-send -a \"changepowerprofile\" -u low \"powerprofile: balanced\"
          powerprofilesctl set balanced;;
        balanced)
          notify-send -a \"changepowerprofile\" -u low \"powerprofile: performance\"
          powerprofilesctl set performance;;
        performance)
          notify-send -a \"changepowerprofile\" -u low \"powerprofile: power-saver\"
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
    # these scripts will set the given power profile and CPU governor. Cpu governors are set of algorithms that will tell the Scaling driver (in our case it is acpi_cpufreq) to set the frequency of the CPU. The available governors are:
    # ondemand: Dynamically changes the frequency depending on CPU load
    # conservative: Similar to ondemand, but more conservative
    # schedutil: Modern replacement for ondemand
    # powersave: Keeps the CPU at the lowest frequency
    # performance: Keeps the CPU at the highest frequency
    # To learn more about CPU governors, visit https://wiki.archlinux.org/title/CPU_frequency_scaling
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
  # asusctl
  services.asusd = {
    enable = true;
    enableUserService = true;
    # fanCurvesConfig = builtins.readFile ../config/fan_curves.ron;
  };
  # power-profiles-daemon
  services.power-profiles-daemon.enable = true;
  services.acpid.enable = true; # acpid is needed for rog-control-center
}
