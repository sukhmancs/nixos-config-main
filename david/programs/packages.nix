{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam-run # Run commands in the same FHS environment
    nix-prefetch-git # Fetch source hashes for git repository
    heimdall
    mono
    bleachbit # A program to free up disk space
    neofetch # System info
    tldr # Quick command summary
    arandr
    joplin-desktop # Open source note taking app
    gimp # Art
    calibre # Book reading app
    # telegram-desktop # Chat app
    xwinwrap
    mailutils
    tesseract4
    virtiofsd # for qemu
    glib # C library
    easyeffects # Limiter, compressor, equalizer, auto valume for pipewire applications
    taisei # taisei project game
    rofi # application launcher
    (pkgs.discord.override {
      # remove any overrides that you don't want
      withOpenASAR = true;
      withVencord = true;
    })
    betterdiscordctl # discord customizer
    # rofi-pass-wayland # rofi-pass replacement for wayland

    #### System hardening
    #chkrootkit # Scan for any rootkits
    vulnix # NixOS vulnerability scanner
    lynis # Security auditing tool
  ];

  nixpkgs.overlays = [
    (final: prev: {
      discord = prev.discord.overrideAttrs (
        _: {
          src = builtins.fetchTarball {
            url = "https://discord.com/api/download?platform=linux&format=tar.gz";
            sha256 = "0hvgzn8zfg6wqhsjcg9icd9y7vcd5h4ffckmc0ga51iv6ic35nyz";
          };
        }
      );
    })
  ];
}
