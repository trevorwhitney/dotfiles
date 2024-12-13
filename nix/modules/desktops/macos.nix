{pkgs, ...}: {
  config = {
    programs = {
      tmux = {
        defaultCommand = "reattach-to-user-namespace -l ${pkgs.zsh}/bin/zsh";
      };
    };

    system = {
      defaults = {
        NSGlobalDomain = {
          InitialKeyRepeat = 15;
          KeyRepeat = 1;
        };
      };
    };
  };
}
