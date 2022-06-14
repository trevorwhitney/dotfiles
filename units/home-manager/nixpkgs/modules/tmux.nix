{ nixpkgs, config, pkgs, lib, ... }: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    prefix = "C-q";
    terminal = "screen-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    baseIndex = 1;
    clock24 = true;
    historyLimit = 5000;
    escapeTime = 10;
    plugins = with pkgs; [
      tw-tmux-lib
      tmuxPlugins.resurrect
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
        '';
      }
      tmuxPlugins.sessionist
      {
        plugin = tmux-cpu;
        extraConfig = "set -g @cpu_temp_unit 'F'";
      }
    ];
  };
}
