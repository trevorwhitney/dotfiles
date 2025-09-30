{pkgs, ...}: {
  config = {
    programs = {
      tmux = {
        extraConfig = ''
          set -g default-command "reattach-to-user-namespace -l ${pkgs.zsh}/bin/zsh"
        '';
      };
      zsh.enable = true;
    };

    system = {
      defaults = {
        NSGlobalDomain = {
          InitialKeyRepeat = 15;
          KeyRepeat = 2;
          ApplePressAndHoldEnabled = false;
        };
      };
    };
  };
}
