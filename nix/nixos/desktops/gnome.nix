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
        # Was only able to get flashback to work using this
        # https://github.com/regolith-linux/i3-gnome-flashback
        # TODO: compare nixos version with this and patch what's needed
        flashback = {
          enableMetacity = false;
          customSessions = [{
            wmName = "i3";
            wmLabel = "i3";
            wmCommand = "${pkgs.i3-gaps}/bin/i3";
            enableGnomePanel = false;
          }];
        };
        extraGSettingsOverrides = ''
          [org.gnome.gnome-flashback]
          desktop-false
          [org.gnome.gnome-flashback.desktop.icons]
          show-home=false
          show-trash=false
        '';
      };
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ i3status i3lock-color ];
    };
  };

  environment.systemPackages = with pkgs; [
    gnome3.gnome-tweaks
    gnome.pomodoro
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
}
