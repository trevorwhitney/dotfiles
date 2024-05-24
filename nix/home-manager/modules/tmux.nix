{ config, pkgs, lib, ... }:
let
  cfg = config.programs.tmux;
in
{

  options = {
    programs.tmux = {
      theme = lib.mkOption {
        type = lib.types.str;
        default = "solarized";
        description =
          "which tmux theme to use";
      };
    };
  };

  config =
    let
      inherit (cfg) theme;
    in
    {
      programs = {
        tmux = {
          enable = true;
          keyMode = "vi";
          prefix = "C-q";
          terminal = "tmux-256color";
          shell = "${pkgs.zsh}/bin/zsh";
          baseIndex = 1;
          clock24 = true;
          historyLimit = 5000;
          escapeTime = 10;
          plugins = with pkgs; [
            tw-tmux-lib
            tmuxPlugins.sessionist
          ];
        };

        zsh.sessionVariables.TMUX_THEME = theme;
        bash.sessionVariables.TMUX_THEME = theme;
      };
    };
}
