{ config, pkgs, lib, ... }: {
  gtk = {
    enable = true;
    font = {
      name = "Ubuntu";
      size = 12;
    };
    theme = {
      name = "NumixSolarizedLightBlue";
      package = pkgs.numix-solarized-gtk-theme;
    };
    iconTheme = {
      # Pop icons
      # name = "Pop";
      # package = pkgs.pop-icon-theme;
      # Papirus Icons
      name = "Papirus-Light";
      package = pkgs.papirus-icon-theme;
    };
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    roboto
    dejavu_fonts
    (nerdfonts.override {
      fonts = [
        "DroidSansMono"
        "FantasqueSansMono"
        "Hack"
        "Iosevka"
        "JetBrainsMono"
        "Noto"
        "Terminus"
        "Ubuntu"
        "UbuntuMono"
      ];
    })
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        monospace-font-name = "JetBrainsMono Nerd Font Mono 12";
        clock-format = "24h";
        gtk-key-theme = "Emacs";
        text-scaling-factor = 1.25;
      };
    };
  };
}
