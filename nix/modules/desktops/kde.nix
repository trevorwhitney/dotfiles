{ config, pkgs, ... }: {
  imports = [ ./kde-base.nix ];

  services.xserver = {
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
    kgpg
    ksshaskpass
  ];
}
