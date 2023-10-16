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
    (slack.overrideAttrs (old: {
      # https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/applications/networking/instant-messengers/slack/default.nix#L151
      postInstall = ''
        substituteInPlace $out/share/applications/slack.desktop \
          --replace "bin/slack -s" "bin/slack --disable-gpu-driver-bug-workarounds -s"
      '';
    }))
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
