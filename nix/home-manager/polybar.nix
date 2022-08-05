{ config, pkgs, lib, ... }:
let
  inherit (pkgs) dotfiles;
  cfg = config.polybar;
in
{
  options = with lib; {
    polybar = {
      hostConfig = mkOption {
        description = "path to host specific polybar config file";
        type = types.path;
      };

      includeSecondary = mkOption {
        description = "whether or not to include bar on secondary monitor";
        type = types.bool;
        default = true;
      };
    };
  };

  config = {
    home.file.".local/share/fonts/fantasque_sans_mono.ttf".source =
      "${dotfiles}/polybar-fonts/fantasque_sans_mono.ttf";
    home.file.".local/share/fonts/feather.ttf".source =
      "${dotfiles}/polybar-fonts/feather.ttf";
    home.file.".local/share/fonts/iosevka_nerd_font.ttf".source =
      "${dotfiles}/polybar-fonts/iosevka_nerd_font.ttf";
    home.file.".local/share/fonts/material_design_iconic_font.ttf".source =
      "${dotfiles}/polybar-fonts/material_design_iconic_font.ttf";
    home.file.".local/share/fonts/panels".source =
      "${dotfiles}/polybar-fonts/panels";
    home.file.".local/share/fonts/terminus".source =
      "${dotfiles}/polybar-fonts/terminus";
    home.file.".local/share/fonts/waffle.bdf".source =
      "${dotfiles}/polybar-fonts/waffle.bdf";

    xdg.configFile."polybar/config".source =
      "${dotfiles}/config/polybar/config";
    xdg.configFile."polybar/scripts".source =
      "${dotfiles}/config/polybar/scripts";

    xdg.configFile."polybar/launch.sh".text = with pkgs;
      with lib; (mkMerge [
        ''
          #!${bash}/bin/bash

          dir="$HOME/.config/polybar"

          # Terminate already running bar instances
          pkill polybar
          # Wait until the processes have been shut down
          while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

          ${polybarFull}/bin/polybar -q top -c "$dir/config/config.ini" &
          ${polybarFull}/bin/polybar -q bottom -c "$dir/config/config.ini" &
        ''
        (mkIf cfg.includeSecondary ''
          ${polybarFull}/bin/polybar -q secondary -c "$dir/config/config.ini" &
        '')
      ]);
    xdg.configFile."polybar/launch.sh".executable = true;

    xdg.configFile."polybar/host.ini".source = "${cfg.hostConfig}";

    home.packages = with pkgs; [ polybarFull ];
  };
}
