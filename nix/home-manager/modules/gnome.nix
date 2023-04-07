{ config, pkgs, lib, ... }: {

  programs.firefox = {
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      cfg = {
        enableTridactylNative = true;
        enableGnomeExtensions = true;
      };
    };
  };

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

  # gpg-agent config without custom pinentry needed on KDE
  home.file.".gnupg/gpg-agent.conf".text = ''
    default-cache-ttl 60480000
    max-cache-ttl 60480000
  '';

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


  xdg = {
    mimeApps = {
      associations = {
        added = {
          "application/octet-stream" = "kitty-open.desktop";
          "application/text" = "kitty-open.desktop;gvim.desktop;vim.desktop";
          "application/vnd.debian.binary-package" = "com.github.donadigo.eddy.desktop;";
          "application/x-extension-htm" = "firefox.desktop";
          "application/x-extension-html" = "firefox.desktop";
          "application/x-extension-shtml" = "firefox.desktop";
          "application/x-extension-xht" = "firefox.desktop";
          "application/x-extension-xhtml" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";
          "audio/mpeg" = "org.audacityteam.Audacity.desktop;";
          "image/jpeg" = "org.gimp.GIMP.desktop;display-im6.q16.desktop";
          "text/html" = "firefox.desktop";
          "text/plain" = "kitty-open.desktop;nvim.desktop;gvim.desktop";
          "video/mp4" = "vlc.desktop;";
          "video/x-matroska" = "vlc.desktop;";
          "x-scheme-handler/chrome" = "google-chrome.desktop;firefox.desktop";
          "x-scheme-handler/ftp" = "firefox.desktop;";
          "x-scheme-handler/geo" = "openstreetmap-geo-handler.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/mailto" = "google-chrome-beta.desktop";
        };
      };
      defaultApplications = {
        "application/vnd.debian.binary-package" = "com.github.donadigo.eddy.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "text/calendar" = "org.gnome.Calendar.desktop";
        "text/html" = "firefox.desktop";
        "text/plain" = "kitty-open.desktop";
        "video/mp4" = "vlc.desktop;";
        "video/x-matroska" = "vlc.desktop;";
        "x-scheme-handler/about" = "google-chrome.desktop";
        "x-scheme-handler/chrome" = "google-chrome.desktop";
        "x-scheme-handler/ftp" = "firefox.desktop";
        "x-scheme-handler/geo" = "openstreetmap-geo-handler.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/unknown" = "google-chrome.desktop";
        "x-scheme-handler/webcal" = "google-chrome.desktop";
      };
    };
  };
}
