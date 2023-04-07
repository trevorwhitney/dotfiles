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

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-kde
      ];
    };
  };

  console.useXkbConfig = true;

  environment.systemPackages = with pkgs; [
    polkit
  ] ++ (with pkgs.plasma5Packages; [
    kscreenlocker
    ksshaskpass
    kwalletcli
    polkit-kde-agent
  ]);

  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  security.polkit.enable = true;

  security.pam.services.kwallet = {
    name = "kdewallet";
    enableKwallet = true;
  };

  programs.dconf.enable = true;
  programs.kdeconnect.enable = true;

  environment.sessionVariables.SSH_ASKPASS = "${pkgs.ksshaskpass}/bin/ksshaskpass";

  # TODO: Is this still needed for slack on wayland?
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
