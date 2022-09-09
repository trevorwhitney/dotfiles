{ config, pkgs, lib, ... }:
{
  xdg = {
    enable = true;

    mimeApps = {
      enable = true;
      associations = {
        added = {
          #TODO: replace with kitty-open?
          "application/octet-stream" = "gvim.desktop";
          "application/text" = "kitty-open.desktop;gvim.desktop;vim.desktop";
          "application/x-extension-htm" = "firefox.desktop";
          "application/x-extension-html" = "firefox.desktop";
          "application/x-extension-shtml" = "firefox.desktop";
          "application/x-extension-xht" = "firefox.desktop";
          "application/x-extension-xhtml" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";

          "audio/mpeg" = "org.audacityteam.Audacity.desktop;";

          "image/jpeg" = "org.gimp.GIMP.desktop;display-im6.q16.desktop";
          #TODO: how do I get annotator?
          "image/png" = "com.github.phase1geo.annotator.desktop;firefox.desktop;org.gimp.GIMP.desktop";

          "text/html" = "firefox.desktop";
          "text/plain" = "kitty-open.desktop;nvim.desktop;gvim.desktop";

          "video/x-matroska" = "vlc_vlc.desktop;";

          "x-scheme-handler/chrome" = "google-chrome.desktop";
          "x-scheme-handler/ftp" = "firefox.desktop;";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
        };
        removed = {
          "x-scheme-handler/chrome" = "firefox.desktop";
        };
      };
      defaultApplications = {
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";

        "text/calendar" = "org.gnome.Calendar.desktop";
        "text/html" = "firefox.desktop";
        "text/plain" = "kitty-open.desktop";

        "video/x-matroska" = "vlc_vlc.desktop";

        "x-scheme-handler/about" = "google-chrome.desktop";
        "x-scheme-handler/chrome" = "google-chrome.desktop";
        "x-scheme-handler/ftp" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/unknown" = "google-chrome.desktop";
        "x-scheme-handler/webcal" = "google-chrome.desktop";
      };
    };
  };
}
