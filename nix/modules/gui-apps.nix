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

    # fix needed for screensharing
    # make sure to set enableWaylandShare = true
    # in ~/.config/zoomus.conf
    (zoom-us.overrideAttrs (old: {
      postFixup = old.postFixup + ''
        wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE
      '';
    }))
  ];
}
