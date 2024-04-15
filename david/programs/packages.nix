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
    glib # C library
    easyeffects # Limiter, compressor, equalizer, auto valume for pipewire applications
    taisei # taisei project game
    # rofi-pass-wayland # rofi-pass replacement for wayland

    #### System hardening
    #chkrootkit # Scan for any rootkits
    vulnix # NixOS vulnerability scanner
    lynis # Security auditing tool
  ];
}
