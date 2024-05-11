{host, ...}:
with host; {
  # remove stupid sites that i just don't want to see
  networking.stevenblack = {
    enable = hostName == "beelink" || hostName == "work"; # do not enable it for server or vm.
    block = [
      "fakenews"
      "gambling"
    ];
  };
}
