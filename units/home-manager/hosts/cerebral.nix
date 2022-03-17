{ config, pkgs, lib, ... }: {
  imports = [
    ../nixpkgs/modules/common.nix
    ../nixpkgs/modules/bash.nix
    ../nixpkgs/modules/git.nix
    ../nixpkgs/modules/neovim.nix
    ../nixpkgs/modules/tmux.nix
    ../nixpkgs/modules/zsh.nix

    # cerebral specific
    ../nixpkgs/modules/media.nix
    ../nixpkgs/modules/spotify.nix
  ];
}
