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

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.system-monitor
    gnomeExtensions.unite
    gnomeExtensions.dash-to-panel
    gnomeExtensions.clipboard-history
    gnomeExtensions.user-themes
    gnomeExtensions.useless-gaps
  ];

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
