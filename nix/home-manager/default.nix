{ pkgs, system, home-manager, nur, ... }:
let
  imports = [
    ./modules/bash.nix
    ./modules/common.nix
    ./modules/fonts.nix
    ./modules/git.nix
    ./modules/neovim.nix
    ./modules/tmux.nix
    ./modules/xdg.nix
    ./modules/zsh.nix
  ];

  config = {
    programs.git = {
      includes =
        [{ path = "${pkgs.secrets}/git"; }];
    };
  };

  defaults = {
    inherit
      config
      home-manager
      imports
      pkgs
      nur
      system;
    username = "twhitney";
  };
in
(import ./hosts/penguin.nix defaults) // (import ./hosts/kolide.nix defaults)
