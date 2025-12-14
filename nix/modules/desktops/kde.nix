{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    layout = "us";
    xkb = {
      variant = "";
      options = "ctrl:nocaps,caps:ctrl_modifier";
    };

    displayManager = {
      autoLogin = {
        enable = true;
        user = "twhitney";
      };
      sddm = {
        enable = false;
        enableHidpi = true;
        autoLogin = {
          minimumUid = 1000;
        };
      };
      defaultSession = "plasmawayland";
    };

    desktopManager = {
      plasma5 = {
        enable = true;
        useQtScaling = true;
      };
    };
  };

  # workaround to fix auto-login issue
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  console.useXkbConfig = true;

  environment = {
    systemPackages = with pkgs; [
      emote
      peek
      plasma-browser-integration
      polkit
      qalculate-qt
      xorg.xfd
    ] ++ (with pkgs.plasma5Packages; [
      ark
      kscreenlocker
      ksshaskpass
      kwalletcli
      polkit-kde-agent
    ]);

    pathsToLink =
      [ "/libexec" ];

    sessionVariables.NIXOS_OZONE_WL = "1";
  }; # links /libexec from derivations to /run/current-system/sw

  security.polkit.enable = true;

  security.pam.services.kde = {
    enableKwallet = true;
  };

  programs.dconf.enable = true;
  programs.kdeconnect.enable = true;
}
