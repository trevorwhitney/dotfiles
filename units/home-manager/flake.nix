{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }: {
    homeConfigurations = {
      cerebral = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/twhitney";
        username = "twhitney";
        stateVersion = "21.11";
        configuration = { config, pkgs, ... }:
          let
            overlay-unstable = final: prev: {
              unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
            };
            overlay-neovim = import (builtins.fetchTarball {
              url =
                "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
            });
          in {
            nixpkgs.overlays = [ overlay-unstable overlay-neovim ];
            nixpkgs.config = {
              allowUnfree = true;
              allowBroken = true;
            };

            imports = [
              ../nixpkgs/modules/common.nix
              ../nixpkgs/modules/bash.nix
              ../nixpkgs/modules/git.nix
              ../nixpkgs/modules/tmux.nix
              ../nixpkgs/modules/zsh.nix

              # cerebral specific
              ../nixpkgs/modules/media.nix
              ../nixpkgs/modules/spotify.nix
              (import ../nixpkgs/modules/neovim.nix {
                inherit config pkgs lib;
                withLspSupport = true;
              })
            ];
          };
      };
    };
    cerebral = self.homeConfigurations.mudrii.activationPackage;
    defaultPackage.x86_64-linux = self.cerebral;
  };
}
