{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";

    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
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

  security.pam.services.gdm.enableGnomeKeyring = true;

  services.gnome.gnome-keyring.enable = true;

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-wlr
        #TODO: causes a collision
        /* xdg-desktop-portal-gtk */
      ];
    };
  };
}
