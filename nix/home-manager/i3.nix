{ config, pkgs, lib, ... }:
let
  inherit (pkgs) dotfiles secrets;
  cfg = config.i3;
in
{

  options = with lib; {
    i3.hostConfig = mkOption {
      description = "path to host specific i3 config file";
      type = types.path;
    };
  };

  config = {
    xdg.configFile."i3/config".source = "${dotfiles}/config/i3/config";
    xdg.configFile."i3/scripts".source = "${dotfiles}/config/i3/scripts";

    xdg.configFile."i3/host.conf".source = "${cfg.hostConfig}";

    # i3 config assumes dropbox and nm-applet are on path
    home.packages = with pkgs; [ dropbox networkmanagerapplet rofi i3-gaps ];

    dconf = {
      enable = true;
      settings = {
        "org/gnome/gnome-flashback" = {
          desktop = false;
          root-background = true;
        };
        "org/gnome/gnome-flashback/desktop/icons" = {
          show-home = false;
          show-trash = false;
        };
      };
    };
  };
}
