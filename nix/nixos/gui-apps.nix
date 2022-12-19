{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    _1password-gui
    audacity
    davinci-resolve
    gimp
    google-chrome-beta
    insomnia
    kdenlive
    spotify
    vlc

    #TODO: fix slack on wayland
    # fix for wayland, should be merged upstream soon
    # https://github.com/NixOS/nixpkgs/pull/206808
    (slack.overrideAttrs (old: {
      rpath = old.rpath + lib.makeLibraryPath [
        wayland
      ];
    }))

    # fix needed for screensharing
    # make sure to set enableWaylandShare = true
    # in ~/.config/zoomus.conf
    (zoom-us.overrideAttrs (old: {
      postFixup = old.postFixup + ''
        wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE
      '';
    }))
  ];

  # needed for slack on wayland
  # TODO: not currently working
  # Try again after using package from https://github.com/NixOS/nixpkgs/pull/206808
  /* environment.sessionVariables.NIXOS_OZONE_WL = "1"; */
}
