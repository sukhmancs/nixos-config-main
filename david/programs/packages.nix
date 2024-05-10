{pkgs, ...}: {
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
    discord # chat
    betterdiscordctl # discord customizer
    pipes-rs # pipes screensaver in rust
    nasm # assembler to convert assembly to machine code for x86
    lm_sensors # tools for reading hardware sensors
    libqalculate # calculator library for rofi-calc
    qalculate-gtk # calculator gui
    unityhub # game development
    gifsicle # optimize gifs (i.e. decrease the size of gif etc.)
    rm-improved # rip: alternative to rm
    tor-browser # privacy focused browser
    vesktop # alternative to Discord with Vencord built-in
    exercism
    git-extras # Provides useful commands like git-summary

    #### System hardening
    #chkrootkit # Scan for any rootkits
    vulnix # NixOS vulnerability scanner
    lynis # Security auditing tool

    # Convert mkv to gif and then optimize this gif to be of smaller size
    # run it like this: convert-to-gif input.mkv output.gif
    (writeShellScriptBin "convert-to-gif" ''
      ffmpeg -i "$1" -vf "fps=10,scale=320:-1:flags=lanczos" -c:v pam -f image2pipe - | convert -delay 10 -loop 0 - gif:- | gifsicle --optimize=3 --colors 256 > "$2"
    '')
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
