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
            wmCommand = "${pkgs.i3-gaps}/bin/i3";
            enableGnomePanel = false;
          }];
        };
      };
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ i3status i3lock-color i3blocks-gaps ];
    };
  };

  environment.systemPackages = with pkgs; [ gnome3.gnome-tweaks ];

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
}
