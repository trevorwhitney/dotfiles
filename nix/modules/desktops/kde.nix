{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    xkbOptions = "ctrl:nocaps,caps:ctrl_modifier";

    displayManager = {
      sddm = {
        enable = true;
        enableHidpi = true;
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
