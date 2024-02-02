{ config, pkgs, lib, ... }: {
  programs.firefox =
    {
      package = pkgs.wrapFirefox pkgs.firefox-beta-bin.unwrapped {
        cfg = {
          nativeMessagingHosts.packages = [
            pkgs.tridactyl-native
            pkgs.plasma-browser-integration
          ];
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
          "application/x-extension-htm" = "google-chrome.desktop;";
          "application/x-extension-html" = "google-chrome.desktop;";
          "application/x-extension-shtml" = "google-chrome.desktop;";
          "application/x-extension-xht" = "google-chrome.desktop;";
          "application/x-extension-xhtml" = "google-chrome.desktop;";
          "application/xhtml+xml" = "google-chrome.desktop;";
          "audio/mpeg" = "org.audacityteam.Audacity.desktop;";
          "image/jpeg" = "org.gimp.GIMP.desktop;display-im6.q16.desktop;";
          "inode/directory" = "org.kde.dolphin.desktop;";
          "text/html" = "google-chrome.desktop'";
          "text/plain" = "kitty-open.desktop;nvim.desktop;gvim.desktop";
          "video/mp4" = "vlc.desktop;";
          "video/x-matroska" = "vlc.desktop;";
          "x-scheme-handler/chrome" = "google-chrome.desktop;google-chrome.desktop;";
          "x-scheme-handler/ftp" = "google-chrome.desktop;";
          "x-scheme-handler/geo" = "openstreetmap-geo-handler.desktop;";
          "x-scheme-handler/http" = "google-chrome.desktop;";
          "x-scheme-handler/https" = "google-chrome.desktop;";
          "x-scheme-handler/insomnia" = "insomnia.desktop;";
          "x-scheme-handler/mailto" = "google-chrome.desktop;";
          "x-scheme-handler/slack" = "Slack.desktop";
          "x-scheme-handler/ssh" = "google-chrome.desktop;";
          "x-scheme-handler/tel" = "org.kde.kdeconnect.handler.desktop;";
          "x-scheme-handler/web+ssh" = "google-chrome.desktop;";
          "x-scheme-handler/webcal" = "google-chrome.desktop;";
          "x-scheme-handler/webcals" = "google-chrome.desktop;";
        };
      };
      defaultApplications = {
        "application/x-extension-htm" = "google-chrome.desktop;";
        "application/x-extension-html" = "google-chrome.desktop;";
        "application/x-extension-ics" = "google-chrome.desktop";
        "application/x-extension-shtml" = "google-chrome.desktop;";
        "application/x-extension-xht" = "google-chrome.desktop";
        "application/x-extension-xhtml" = "google-chrome.desktop;";
        "application/xhtml+xml" = "google-chrome.desktop;";
        "inode/directory" = "org.kde.dolphin.desktop;";
        "text/calendar" = "google-chrome.desktop";
        "text/html" = "google-chrome.desktop;";
        "text/plain" = "kitty-open.desktop;";
        "video/mp4" = "vlc.desktop;";
        "video/x-matroska" = "vlc.desktop;";
        "x-scheme-handler/about" = "google-chrome.desktop;";
        "x-scheme-handler/chrome" = "google-chrome.desktop;";
        "x-scheme-handler/ftp" = "google-chrome.desktop;";
        "x-scheme-handler/geo" = "openstreetmap-geo-handler.desktop;";
        "x-scheme-handler/http" = "google-chrome.desktop;";
        "x-scheme-handler/https" = "google-chrome.desktop;";
        "x-scheme-handler/insomnia" = "insomnia.desktop;";
        "x-scheme-handler/mailto" = "google-chrome.desktop;";
        "x-scheme-handler/slack" = "slack.desktop";
        "x-scheme-handler/tel" = "org.kde.kdeconnect.handler.desktop;";
        "x-scheme-handler/unknown" = "google-chrome.desktop;";
        "x-scheme-handler/webcal" = "google-chrome.desktop;";
        "x-scheme-handler/webcals" = "google-chrome.desktop";
      };
    };
  };
}
