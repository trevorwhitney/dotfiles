{ config, pkgs, lib, ... }: {
  imports = [
    ../nixpkgs/modules/common.nix
    ../nixpkgs/modules/bash.nix
    ../nixpkgs/modules/git.nix
    ../nixpkgs/modules/tmux.nix
    ../nixpkgs/modules/zsh.nix

    # crostini specific
    (import ../nixpkgs/modules/neovim.nix {
      inherit config pkgs lib;
      withLspSupport = false;
    })
  ];
}
