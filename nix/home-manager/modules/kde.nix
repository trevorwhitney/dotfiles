{ config, pkgs, lib, ... }: {
  programs.firefox =
    {
      package = pkgs.wrapFirefox pkgs.firefox-beta-bin.unwrapped {
        cfg = {
          enableTridactylNative = true;
          enablePlasmaBrowserIntegration = true;
        };

        icon = "firefox";
        wmClass = "firefox";
      };
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
          "x-scheme-handler/mailto" = "google-chrome.desktop;";
          "x-scheme-handler/slack" = "Slack.desktop";
          "x-scheme-handler/ssh" = "google-chrome-beta.desktop";
          "x-scheme-handler/tel" = "org.kde.kdeconnect.handler.desktop;";
          "x-scheme-handler/web+ssh" = "google-chrome-beta.desktop";
          "x-scheme-handler/webcal" = "thunderbird.desktop";
          "x-scheme-handler/webcals" = "thunderbird.desktop";
        };
      };
      defaultApplications = {
        "application/x-extension-htm" = "firefox.desktop;";
        "application/x-extension-html" = "firefox.desktop;";
        "application/x-extension-ics" = "thunderbird.desktop";
        "application/x-extension-shtml" = "firefox.desktop;";
        "application/x-extension-xht" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop;";
        "application/xhtml+xml" = "firefox.desktop;";
        "inode/directory" = "org.kde.dolphin.desktop;";
        "text/calendar" = "thunderbird.desktop";
        "text/html" = "google-chrome.desktop;";
        "text/plain" = "kitty-open.desktop;";
        "video/mp4" = "vlc.desktop;";
        "video/x-matroska" = "vlc.desktop;";
        "x-scheme-handler/about" = "google-chrome.desktop;";
        "x-scheme-handler/chrome" = "google-chrome.desktop;";
        "x-scheme-handler/ftp" = "firefox.desktop;";
        "x-scheme-handler/geo" = "openstreetmap-geo-handler.desktop;";
        "x-scheme-handler/http" = "google-chrome.desktop;";
        "x-scheme-handler/https" = "google-chrome.desktop;";
        "x-scheme-handler/insomnia" = "insomnia.desktop;";
        "x-scheme-handler/mailto" = "google-chrome.desktop;";
        "x-scheme-handler/slack" = "slack.desktop";
        "x-scheme-handler/tel" = "org.kde.kdeconnect.handler.desktop;";
        "x-scheme-handler/unknown" = "google-chrome.desktop;";
        "x-scheme-handler/webcal" = "thunderbird.desktop;";
        "x-scheme-handler/webcals" = "thunderbird.desktop";
      };
    };
  };
}
