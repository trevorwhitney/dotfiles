{ config, pkgs, username, home-manager, ... }:
let
  imports = [
    ../modules/bash.nix
    ../modules/change-background.nix
    ../modules/darwin.nix
    ../modules/git.nix
    ../modules/k9s.nix
    ../modules/kubernetes.nix
    ../modules/neovim.nix
    ../modules/tmux.nix
    ../modules/zsh.nix
  ];

  baseConfig = {
    home = {
      inherit username;
      homeDirectory = "/Users/${username}";
      stateVersion = "23.11";
    };
  };
in
{
  "twhitney@fiction" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      baseConfig
      config
      {
        # Currently broken: https://github.com/NixOS/nixpkgs/issues/196651
        # manual.manpages.enable = false;
        targets.darwin = {
          defaults = { };
          search = "Google";
        };

        programs = {
          git = {
            includes =
              [{ path = "${pkgs.secrets}/git"; }];
          };

          neovim = {
            # default installation disables LSP
            # enable via .envrc in folders with code
            withLspSupport = false;
          };

          gh = {
            enable = true;
          };

          kubectl = {
            enable = true;
            package = pkgs.kubectl-1-25;
          };

          tmux = {
            theme = "everforest";
          };
        };
      }
    ] ++ imports;
  };
}
