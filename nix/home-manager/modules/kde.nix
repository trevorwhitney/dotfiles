{ config, pkgs, lib, ... }: {
  programs.firefox =
    {
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        cfg = {
          enableTridactylNative = true;
          enablePlasmaBrowserIntegration = true;
        };
      };

    };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    xorg.xfd
    xdg-desktop-portal

    dejavu_fonts
    emote
    fontconfig
    roboto
    siji

    qalculate-qt

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

  xdg.configFile."plasma-workspace/env/ssh-agent-startup.sh" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      export SSH_ASKPASS="${pkgs.ksshaskpass}/bin/ksshaskpass"

      if ! pgrep -u $USER ssh-agent > /dev/null; then
          ssh-agent > ~/.ssh-agent-info
      fi
      if [[ "$SSH_AGENT_PID" == "" ]]; then
          eval $(<~/.ssh-agent-info)
      fi
    '';
  };

  xdg.configFile."plasma-workspace/env/ssh-agent-shutdown.sh" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      [ -z "$SSH_AGENT_PID" ] || eval "$(ssh-agent -k)"
    '';
  };


  xdg = {
    mimeApps = {
      enable = true;
      associations = {
        added = {
          "application/octet-stream" = "kitty-open.desktop";
          "application/text" = "kitty-open.desktop;gvim.desktop;vim.desktop";
          "application/x-extension-htm" = "firefox.desktop";
          "application/x-extension-html" = "firefox.desktop";
          "application/x-extension-shtml" = "firefox.desktop";
          "application/x-extension-xht" = "firefox.desktop";
          "application/x-extension-xhtml" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";
          "audio/mpeg" = "org.audacityteam.Audacity.desktop;";
          "image/jpeg" = "org.gimp.GIMP.desktop;display-im6.q16.desktop";
          "inode/directory" = "org.kde.dolphin.desktop";
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
          "x-scheme-handler/tel" = "org.kde.kdeconnect.handler.desktop";
        };
      };
      defaultApplications = {
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "inode/directory" = "org.kde.dolphin.desktop";
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
        "x-scheme-handler/tel" = "org.kde.kdeconnect.handler.desktop";
        "x-scheme-handler/unknown" = "google-chrome.desktop";
        "x-scheme-handler/webcal" = "google-chrome.desktop";
      };
    };
  };
}
