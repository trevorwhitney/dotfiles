{ config, pkgs, ... }: {
  services.xserver = {
    displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
      };
      defaultSession = "xfce"; # TODO: does this need to be xfce+i3?
    };

    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ i3status i3lock-color i3blocks-gaps ];
    };
  };

  services.dbus.packages = with pkgs; [ xfce.xfconf ];

  services.redshift = {
    enable = true;
    brightness = {
      day = "0.85";
      night = "0.75";
    };
    temperature = {
      day = 3810;
      night = 2800;
    };
  };

  # Needed for redshift
  location = {
    provider = "manual";
    # lat/lon provided via secrets
    # need to include this in module imports
    # "${pkgs.secrets}/hosts/stem/secrets.nix"
  };
}
