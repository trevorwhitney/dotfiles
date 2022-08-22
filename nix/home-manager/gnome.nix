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
    parcellite
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
    # `gsettings list-recursively` to find settings
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        monospace-font-name = "JetBrainsMono Nerd Font Mono 12";
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
      # at some point the default for this included <Control>period
      # which is too commony used by other apps
      "desktop/ibus/panel/emoji" = { hotkey = [ "<Control>semicolon" ]; };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/emote" =
        {
          binding = "<Primary><Alt>e";
          command = "${pkgs.emote}/bin/emote";
          name = "Emote";
        };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/parcellite" =
        {
          binding = "<Primary><Alt>h";
          command = "${pkgs.parcellite}/bin/parcellite";
          name = "Emote";
        };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        "custom-keybinding" = [
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/emote"
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/parcellite"
        ];
        # disable <Super>l as default lock/screensaver
        "screensaver" = [];
      };
    };
  };

  xdg.configFile."autostart/parcellite-startup.desktop".source =
    "${pkgs.parcellite}/etc/xdg/autostart/parcellite-startup.desktop";
}
