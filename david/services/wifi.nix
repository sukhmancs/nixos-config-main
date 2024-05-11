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

  services.fail2ban = {
    enable = true;
    maxretry = 5; # Observe 5 violations before banning an IP
    ignoreIP = [
      # Whitelisting some subnets:
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
      "10.0.0.248/24"
      "2607:fea8:ab62:4200::635f/128"
    ];
    bantime = "1h"; # Set bantime to one day
    jails = {
      apache-nohome-iptables = ''
        # Block an IP address if it accesses a non-existent
        # home directory more than 5 times in 10 minutes,
        # since that indicates that it's scanning.
        filter = apache-nohome
        action = iptables-multiport[name=HTTP, port="http,https"]
        logpath = /var/log/httpd/error_log*
        backend = auto
        findtime = 600
        bantime  = 600
        maxretry = 5
      '';
    };
  };
}
