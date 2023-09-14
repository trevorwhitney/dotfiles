{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    audacity
    freecad
    gimp
    google-chrome
    inkscape
    insomnia
    kdenlive
    librecad
    qcad
    slack
    spotify
    thunderbird
    vlc
    zoom-us

    # fix ODAFileConverter for wayland
    (pkgs.writeShellScriptBin "ODAFileConverter" ''
      #!${pkgs.stdenv.shell}
      QT_QPA_PLATFORM=wayland "${pkgs.odafileconverter}/bin/ODAFileConverter" "$@"
    '')
  ];
}
