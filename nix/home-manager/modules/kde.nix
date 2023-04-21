{ config, pkgs, lib, ... }: {
  programs.firefox =
    {
      package = pkgs.wrapFirefox pkgs.latest.firefox-nightly-bin.unwrapped {
        cfg = {
          enableTridactylNative = true;
          enablePlasmaBrowserIntegration = true;
        };

        icon = "firefox-nightly";
        wmClass = "firefox";
      };
    };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    xorg.xfd
    xdg-desktop-portal
    xdg-desktop-portal-kde

    emote
    kalendar
    peek
    plasma-browser-integration
    qalculate-qt

    # Fonts
    dejavu_fonts
    fontconfig
    roboto
    siji
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
  ] ++ (with pkgs.plasma5Packages; [
    ark
  ]);

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


  # Use kwallet for gpg-agent pinentry
  home.file.".gnupg/gpg-agent.conf".text = ''
    default-cache-ttl 60480000
    max-cache-ttl 60480000

    pinentry-program ${pkgs.kwalletcli}/bin/pinentry-kwallet
  '';

  xdg = {
    mimeApps = {
      enable = true;
      associations = {
        added = {
          "application/octet-stream" = "kitty-open.desktop;";
          "application/text" = "kitty-open.desktop;gvim.desktop;vim.desktop;";
          "application/x-extension-htm" = "firefox.desktop;";
          "application/x-extension-html" = "firefox.desktop;";
          "application/x-extension-shtml" = "firefox.desktop;";
          "application/x-extension-xht" = "firefox.desktop;";
          "application/x-extension-xhtml" = "firefox.desktop;";
          "application/xhtml+xml" = "firefox.desktop";
          "audio/mpeg" = "org.audacityteam.Audacity.desktop;";
          "image/jpeg" = "org.gimp.GIMP.desktop;display-im6.q16.desktop;";
          "inode/directory" = "org.kde.dolphin.desktop;";
          "text/html" = "firefox.desktop'";
          "text/plain" = "kitty-open.desktop;nvim.desktop;gvim.desktop";
          "video/mp4" = "vlc.desktop;";
          "video/x-matroska" = "vlc.desktop;";
          "x-scheme-handler/chrome" = "google-chrome.desktop;firefox.desktop";
          "x-scheme-handler/ftp" = "firefox.desktop;";
          "x-scheme-handler/geo" = "openstreetmap-geo-handler.desktop;";
          "x-scheme-handler/http" = "firefox.desktop;";
          "x-scheme-handler/https" = "firefox.desktop;";
          "x-scheme-handler/insomnia" = "insomnia.desktop;";
          "x-scheme-handler/mailto" = "google-chrome-beta.desktop;";
          "x-scheme-handler/slack" = "slack.desktop";
          "x-scheme-handler/tel" = "org.kde.kdeconnect.handler.desktop;";
        };
      };
      defaultApplications = {
        "application/x-extension-htm" = "firefox.desktop;";
        "application/x-extension-html" = "firefox.desktop;";
        "application/x-extension-shtml" = "firefox.desktop;";
        "application/x-extension-xht" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop;";
        "application/xhtml+xml" = "firefox.desktop;";
        "inode/directory" = "org.kde.dolphin.desktop;";
        "text/html" = "firefox.desktop;";
        "text/plain" = "kitty-open.desktop;";
        "video/mp4" = "vlc.desktop;";
        "video/x-matroska" = "vlc.desktop;";
        "x-scheme-handler/about" = "google-chrome.desktop;";
        "x-scheme-handler/chrome" = "google-chrome.desktop;";
        "x-scheme-handler/ftp" = "firefox.desktop;";
        "x-scheme-handler/geo" = "openstreetmap-geo-handler.desktop;";
        "x-scheme-handler/http" = "firefox.desktop;";
        "x-scheme-handler/https" = "firefox.desktop;";
        "x-scheme-handler/insomnia" = "insomnia.desktop;";
        "x-scheme-handler/slack" = "slack.desktop";
        "x-scheme-handler/tel" = "org.kde.kdeconnect.handler.desktop;";
        "x-scheme-handler/unknown" = "google-chrome.desktop;";
        "x-scheme-handler/webcal" = "google-chrome.desktop;";
      };
    };
  };
}
