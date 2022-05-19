{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main";
    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , flake-utils
    , secrets
    , ...
    }: {
      homeConfigurations =
        let
          overlay-unstable = final: prev: {
            unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
          };

          overlay-neovim = import (builtins.fetchTarball {
            url =
              "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
          });

          commonConfig = {
            system = "x86_64-linux";
            homeDirectory = "/home/twhitney";
            username = "twhitney";
          };

          commonImports = [
            ./nixpkgs/modules/common.nix
            ./nixpkgs/modules/bash.nix
            ./nixpkgs/modules/git.nix
            ./nixpkgs/modules/tmux.nix
            ./nixpkgs/modules/zsh.nix
          ];
        in
        {
          "twhitney@cerebral" =
            self.inputs.home-manager.lib.homeManagerConfiguration (commonConfig
              // {
              configuration = { config, pkgs, lib, ... }: {
                nixpkgs.overlays = [ overlay-unstable overlay-neovim ];
                nixpkgs.config = {
                  allowUnfree = true;
                  allowBroken = true;
                };

                imports = [
                  ./nixpkgs/modules/media.nix
                  ./nixpkgs/modules/spotify.nix
                  (import ./nixpkgs/modules/neovim.nix {
                    inherit config pkgs lib;
                    withLspSupport = true;
                  })
                ] ++ commonImports;

                programs.git.includes = [{
                  path = "${inputs.secrets.defaultPackage.x86_64-linux}/git";
                }];
              };
            });

          "twhitney@crostini" =
            self.inputs.home-manager.lib.homeManagerConfiguration (commonConfig
              // {
              configuration = { config, pkgs, lib, ... }: {
                nixpkgs.overlays = [ overlay-unstable overlay-neovim ];
                nixpkgs.config = {
                  allowUnfree = true;
                  allowBroken = true;
                };

                imports = [
                  (import ./nixpkgs/modules/neovim.nix {
                    inherit config pkgs lib;
                    withLspSupport = false;
                  })
                ] ++ commonImports;

                programs.git.includes = [{
                  path = "${inputs.secrets.defaultPackage.x86_64-linux}/git";
                }];

                programs.zsh.sessionVariables = { GPG_TTY = "$(tty)"; };
              };
            });
        };
    };
}
