{ config, pkgs, ... }: {
  imports = [ ./gnome-base.nix ];
  services.xserver = {
    displayManager = {
      /* defaultSession = "gnome-flashback-i3"; */
    };

    desktopManager.gnome = {
      enable = true;
      flashback = {
        enableMetacity = true;
        /* customSessions = [{ */
        /*   wmName = "i3-gnome"; */
        /*   wmLabel = "i3"; */
        /*   wmCommand = "${pkgs.i3-gnome-flashback}/bin/i3-gnome-flashback"; */
        /*   enableGnomePanel = false; */
        /* }]; */
      };
    };

    /* windowManager.i3 = { */
    /*   enable = true; */
    /*   package = pkgs.i3-gaps; */
    /*   extraPackages = with pkgs; [ i3status i3lock-color ]; */
    /* }; */
  };
}
