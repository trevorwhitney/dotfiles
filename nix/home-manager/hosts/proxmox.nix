{ pkgs, home-manager, username, ... }: {
  "twhitney@proxmox" = home-manager.lib.homeManagerConfiguration rec {
    inherit pkgs;
    home = {
      inherit username;
      homeDirectory = "/home/${username}";
      stateVersion = "21.11";
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      XDG_CACHE_HOME = "${home.homeDirectory}/.cache";
      XDG_CONFIG_HOME = "${home.homeDirectory}/.config";
      XDG_DATA_HOME = "${home.homeDirectory}/.local/share";
      XDG_STATE_HOME = "${home.homeDirectory}/.local/state";
    };

    imports = [
      ../modules/bash.nix
      ../modules/git.nix
      ../modules/zsh.nix
    ];

    home.packages = [
      (pkgs.neovim {
        withLspSupport = false;
      })
    ];
    programs = {
      direnv = {
        enable = true;
        nix-direnv = { enable = true; };
      };
    };
  };
}
