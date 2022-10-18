{ config, pkgs, ... }: {
  imports = [ ./gnome-base.nix ];

  services.xserver = {
    displayManager = {
      defaultSession = "gnome";
      autoLogin = {
        user = "twhitney";
        enable = true;
      };
    };

    desktopManager = {
      gnome = {
        enable = true;
      };
    };
  };
}
