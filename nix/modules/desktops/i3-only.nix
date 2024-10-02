{config, pkgs, ...}: {
  services.xserver = {
    enable = true;
    layout = "us";
    xkb = {
      variant = "";
      options = "ctrl:nocaps";
    };
    libinput.mouse.naturalScrolling = true;

    desktopManager.xterm.enable = false;
    displayManager = {
      gdm = {
        enable = true;
      };
    };
  };
  windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [ i3status i3lock-color ];
  };
}
