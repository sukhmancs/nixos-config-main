###
###  Run pre-compiled executables on NixOS  ### 
###  https://blog.thalheim.io/2022/12/31/nix-ld-a-clean-solution-for-issues-with-pre-compiled-executables-on-nixos/
###  https://unix.stackexchange.com/questions/522822/different-methods-to-run-a-non-nixos-executable-on-nixos 
###

{ config, lib, pkgs, inputs, ... }: 

{  
  # Enable nix ld
  programs.nix-ld.enable = true;
  programs.nix-ld.package = inputs.nix-ld-rs.packages.${pkgs.hostPlatform.system}.nix-ld-rs;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
        openssl
        xorg.libXcomposite
        xorg.libXtst
        xorg.libXrandr
        xorg.libXext
        xorg.libX11
        xorg.libXfixes
        libGL
        libva
        pipewire
        xorg.libxcb
        xorg.libXdamage
        xorg.libxshmfence
        xorg.libXxf86vm
        libelf
        
        # Required
        glib
        gtk2
        bzip2
        
        # Without these it silently fails
        xorg.libXinerama
        xorg.libXcursor
        xorg.libXrender
        xorg.libXScrnSaver
        xorg.libXi
        xorg.libSM
        xorg.libICE
        gnome2.GConf
        nspr
        nss
        cups
        libcap
        SDL2
        libusb1
        dbus-glib
        ffmpeg
        # Only libraries are needed from those two
        libudev0-shim
        
        # Verified games requirements
        xorg.libXt
        xorg.libXmu
        libogg
        libvorbis
        SDL
        SDL2_image
        glew110
        libidn
        tbb
        
        # Other things from runtime
        flac
        freeglut
        libjpeg
        libpng
        libpng12
        libsamplerate
        libmikmod
        libtheora
        libtiff
        pixman
        speex
        SDL_image
        SDL_ttf
        SDL_mixer
        SDL2_ttf
        SDL2_mixer
        libappindicator-gtk2
        libdbusmenu-gtk2
        libindicator-gtk2
        libcaca
        libcanberra
        libgcrypt
        libvpx
        librsvg
        xorg.libXft
        libvdpau
        gnome2.pango
        cairo
        atk
        gdk-pixbuf
        fontconfig
        freetype
        dbus
        alsaLib
        expat
        # Needed for electron
        libdrm
        mesa
        libxkbcommon

        ## Recently added
        alsa-lib
        xorg_sys_opengl
        at-spi2-atk
        nss_latest
        vivaldi-ffmpeg-codecs
  ];

}
