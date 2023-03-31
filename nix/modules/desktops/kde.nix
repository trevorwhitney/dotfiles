{ config, pkgs, ... }: {
  imports = [ ./kde-base.nix ];

  services.xserver = {
    displayManager = {
      defaultSession = "plasmawayland";
    };

    desktopManager = {
      plasma5 = {
        enable = true;
      };
    };
  };

  programs.dconf.enable = true;
  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs.plasma5Packages; [
    kalendar
    kgpg #TODO: created config in ~/.gnupg/gpg.conf, move to home-manager
    ksshaskpass
  ];
}
