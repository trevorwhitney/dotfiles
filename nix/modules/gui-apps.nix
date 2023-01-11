{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    _1password-gui
    audacity
    davinci-resolve
    gimp
    google-chrome-beta
    insomnia
    kdenlive
    slack
    spotify
    vlc

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
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
