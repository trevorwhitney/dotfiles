{ config, pkgs, lib, ... }:
let
  inherit (config.programs.firefox) nurPkgs;
in
{
  options = {
    programs.firefox.nurPkgs = lib.mkOption
      {
        type = lib.types.attrs;
      };
  };
  config = {
    programs.firefox = {
      enable = true;
      extensions = with nurPkgs.repos.rycee.firefox-addons; [
        auto-tab-discard
        cookie-autodelete
        ghostery
        gnome-shell-integration
        multi-account-containers
        /* okta-browser-plugin */
        onepassword-password-manager
        privacy-badger
        privacy-possum
        tree-style-tab
        tridactyl
        ublock-origin
      ];
      profiles.default = {
        name = "default";
        isDefault = true;
        userChrome = ''
          #sidebar-header {
            display: none !important;
          }

          #navigator-toolbox:not(:hover):not(:focus-within) #toolbar-menubar > * {
            background-color: rgb(232, 232, 231);
          }

          #main-window[sizemode="maximized"] #content-deck {
            padding-top: 8px;
          }

          :root:not([customizing]) #navigator-toolbox:not(:hover):not(:focus-within) #TabsToolbar {
            visibility: collapse;
          }

          tabs {
            counter-reset: tab-counter;
          }

          .tab-label::before {
            counter-increment: tab-counter;
            content: counter(tab-counter) " - ";
          }

          #TabsToolbar {
            visibility: collapse;
          }

          statuspanel[type="overLink"],
          #statuspanel[type="overLink"] {
            right: 0;
            display: inline;
          }
        '';
      };
    };
  };
}
