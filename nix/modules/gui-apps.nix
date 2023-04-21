{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    _1password-gui
    audacity
    davinci-resolve
    freecad
    gimp
    google-chrome-beta
    insomnia
    kdenlive
    librecad
    qcad
    slack
    spotify
    vlc

    # fix ODAFileConverter for wayland
    (pkgs.writeShellScriptBin "ODAFileConverter" ''
      #!${pkgs.stdenv.shell}
      QT_QPA_PLATFORM=wayland "${pkgs.odafileconverter}/bin/ODAFileConverter" "$@"
    '')

    zoom-us
  ];
}
