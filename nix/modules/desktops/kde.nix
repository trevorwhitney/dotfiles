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
  # TODO: this was added with the hope of preventing the need for supplying
  # the ssh key passphrase with git operations. Does it work?
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = "${pkgs.ksshaskpass}/bin/ksshaskpass";
  };

  #programs.gnupg.agent.pinentryFlavor = "qt";

  environment.sessionVariables.SSH_ASKPASS = "${pkgs.ksshaskpass}/bin/ksshaskpass";
  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
