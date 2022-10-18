{ config, pkgs, ... }: {
  imports = [ ./gnome-base.nix ];
  services.xserver = {
    displayManager = {
      defaultSession = "gnome-flashback-i3";
      autoLogin = {
        user = "twhitney";
        enable = true;
      };
    };

    desktopManager.gnome = {
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

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ i3status i3lock-color ];
    };
  };
}
