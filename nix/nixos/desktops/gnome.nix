{ config, pkgs, ... }: {
  services.xserver = {
    displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
      };
      defaultSession = "gnome-flashback-i3";
    };

    desktopManager = {
      xterm.enable = false;
      gnome = {
        enable = true;
        flashback = {
          enableMetacity = false;
          customSessions = [{
            wmName = "i3";
            wmLabel = "i3";
            wmCommand = "${pkgs.i3-gnome-flashback}/bin/i3-gnome-flashback";
            enableGnomePanel = false;
          }];
        };
      };
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ i3status i3lock-color ];
    };
  };

  environment.systemPackages = with pkgs; [
    gnome.dconf-editor
    gnome.pomodoro
    gnome3.gnome-tweaks
    gnomeExtensions.appindicator
    
    # TODO: how to logout with nix? do I need this
    # currently polybar is broken
    gnome.gnome-session
  ];
  environment.gnome.excludePackages = (with pkgs; [ gnome-photos gnome-tour ])
    ++ (with pkgs.gnome; [
    atomix # puzzle game
    epiphany # web browser
    evince # document viewer
    geary # email reader
    gnome-music # music player
    hitori # sudoku game
    iagno # go game
    tali # poker game
    totem # video player
  ]);

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
}
