{ config, pkgs, ... }: {

  services.xserver = {
    desktopManager.xterm.enable = false;
    displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    gnome.dconf-editor
    gnome.gnome-screenshot
    gnome.pomodoro
    gnome.gnome-tweaks
    gnomeExtensions.appindicator

    gnome.gnome-session

    polkit
    polkit_gnome
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

  security.polkit.enable = true;
}
