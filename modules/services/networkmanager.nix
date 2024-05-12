# Wifi - Setup Network manager with dnscrypt-proxy client. I have also configured fail to ban
#
{
  pkgs,
  host,
  ...
}:
with host; let
  inherit (lib) mkIf;
in {
  # enable wireless database, it helps keeping wifi speedy
  hardware.wirelessRegulatoryDatabase = true;

  networking = {
    nameservers = ["127.0.0.1" "::1"];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager = {
      enable = true;
      unmanaged = [
        "interface-name:tailscale*"
        "interface-name:br-*"
        "interface-name:rndis*"
        "interface-name:docker*"
        "interface-name:virbr*"
        "interface-name:vboxnet*"
        "interface-name:waydroid*"
        "type:bridge"
      ];
      wifi = {
        backend = "iwd";

        # macAddress = "random"; # use a random mac address on every boot, this can scew with static ip
        powersave = true;
        scanRandMacAddress = true; # MAC address randomization of a Wi-Fi device during scanning
      };

      ethernet.macAddress = mkIf (hostName != "server") "random"; # causes server to be unreachable over SSH

      dns = "none"; # dnscrypt-proxy2 will handle dns
      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-openconnect
      ];
    };
  };

  programs = {
    nm-applet = {
      enable = true;
    };
  };

  # networking.firewall.enable = false;

  # Setup DNS proxy client
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      cache = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      sources.relays = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md"
          "https://download.dnscrypt.info/resolvers-list/v3/relays.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/relays.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        refresh_delay = 72;
        # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        # server_names = [ ... ];
      };

      # anonymized_dns = {
      #   skip_incompatible = true;
      #   routes = [
      #     {
      #       server_name = "*";
      #       via = ["*"];
      #     }
      #   ];
      # };
    };
  };
  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };
}
