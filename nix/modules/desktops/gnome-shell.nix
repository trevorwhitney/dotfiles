{ config, pkgs, ... }: {
  imports = [ ./gnome-base.nix ];

  services.xserver = {
    displayManager = {
      defaultSession = "gnome";
    };

    desktopManager = {
      gnome = {
        enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.system-monitor-2
    gnomeExtensions.unite
    gnomeExtensions.dash-to-panel
    gnomeExtensions.clipboard-history
    gnomeExtensions.user-themes
  ];

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
