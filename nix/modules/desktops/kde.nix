{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    xkbOptions = "ctrl:nocaps,caps:ctrl_modifier";

    displayManager = {
      sddm = {
        enable = true;
      };
      defaultSession = "plasmawayland";
    };

    desktopManager = {
      plasma5 = {
        enable = true;
      };
    };
  };

  console.useXkbConfig = true;

  environment.systemPackages = with pkgs; [
    kalendar
    kgpg
    ksshaskpass
    libsForQt5.polkit-kde-agent
    polkit
  ];

  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  security.polkit.enable = true;

  security.pam.services.kwallet = {
    name = "KDE Wallet";
    enableKwallet = true;
  };

  programs.dconf.enable = true;
  programs.kdeconnect.enable = true;

  environment.sessionVariables.SSH_ASKPASS = "${pkgs.ksshaskpass}/bin/ksshaskpass";
}
