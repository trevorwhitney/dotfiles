{ config, pkgs, lib, ... }: {
  gtk = {
    enable = true;
    font = {
      package = pkgs.roboto;
      name = "Roboto Regular";
      size = 12;
    };
    theme = {
      name = "NumixSolarizedLightBlue";
      package = pkgs.numix-solarized-gtk-theme;
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
        "Iosevka"
        "JetBrainsMono"
        "Noto"
        "Terminus"
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
        text-scaling-factor = "1.25";
      };
    };
  };
}
