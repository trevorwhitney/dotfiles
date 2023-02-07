{ config, pkgs, lib, ... }: {
  gtk = {
    enable = true;
    font = {
      name = "Ubuntu Nerd Font";
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
    gnome.gnome-screenshot
    xorg.xfd

    xdg-desktop-portal
    xdg-desktop-portal-gnome

    dejavu_fonts
    emote
    fontconfig
    roboto
    siji

    #TODO: move copyq to own module
    /* copyq */

    (nerdfonts.override {
      fonts = [
        "CascadiaCode"
        "DroidSansMono"
        "FantasqueSansMono"
        "FiraCode"
        "Hack"
        /* Iosevka is failing to download */
        /* "Iosevka" */
        "JetBrainsMono"
        "Noto"
        "Terminus"
        "Ubuntu"
        "UbuntuMono"
        "VictorMono"
      ];
    })
  ];

  dconf = {
    # `gsettings list-recursively` to find settings
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        monospace-font-name = "JetBrainsMono Nerd Font Mono 12";
        document-font-name = "Ubuntu Nerd Font 12";
        clock-format = "24h";
        gtk-key-theme = "Emacs";
        text-scaling-factor = 1.25;
      };
      "org/gnome/desktop/screensaver" = {
        picture-options = "none";
        picture-uri = "";
        primary-color = "#073642";
        color-shading-type = "solid";
      };
      "org/gnome/desktop/background" = {
        picture-options = "none";
        picture-uri = "";
        picture-uri-dark = "";
        primary-color = "#073642";
        color-shading-type = "solid";
      };
      "org/gnome/desktop/wm/keybindings" =
        {
          close = [ "<Super>q" ];
        };
      "org/gnome/shell" = {
        favorite-apps = [
          "org.gnome.Calendar.desktop"
          "org.gnome.Nautilus.desktop"
          "firefox.desktop"
          "kitty.desktop"
          "slack.desktop"
          "spotify.desktop"
          "1password.desktop"
        ];
      };

      # at some point the default for this included <Control>period
      # which is too commony used by other apps
      "desktop/ibus/panel/emoji" = {
        hotkey = [ "<Control>semicolon" ];
      };
    };
  };
}
