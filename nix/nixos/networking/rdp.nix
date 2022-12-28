{ config, pkgs, ... }: {
  services.xrdp = {
    enable = true;
    openFirewall = true;
    defaultWindowManager = "gnome-session";
  };
}
