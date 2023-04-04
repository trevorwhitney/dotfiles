{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    xkbOptions = "ctrl:nocaps,caps:ctrl_modifier";

    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

  console.useXkbConfig = true;

  environment.systemPackages = with pkgs; [
    gnome.dconf-editor
    gnome.gnome-screenshot
    gnome.gnome-session
    gnome.gnome-tweaks
    gnome.pomodoro

    gnomeExtensions.appindicator

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

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

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
