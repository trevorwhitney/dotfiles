{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    xkbOptions = "ctrl:nocaps,caps:ctrl_modifier";

    displayManager = {
      autoLogin = {
        enable = true;
        user = "twhitney";
      };
      sddm = {
        enable = true;
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

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-kde
      ];
    };
  };

  console.useXkbConfig = true;

  environment.systemPackages = with pkgs; [
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

  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  security.polkit.enable = true;

  security.pam.services.kde = {
    enableKwallet = true;
  };

  programs.dconf.enable = true;
  programs.kdeconnect.enable = true;

  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
  };

  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "force";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
