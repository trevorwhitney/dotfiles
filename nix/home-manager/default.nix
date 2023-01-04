{ pkgs, system, home-manager, nur, ... }:
let
  imports = [
    ./modules/common.nix
    ./modules/bash.nix
    ./modules/git.nix
    ./modules/neovim.nix
    ./modules/tmux.nix
    ./modules/xdg.nix
    ./modules/zsh.nix
  ];

  config = {
    programs.git = {
      gpgPath = "/usr/bin/gpg";
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
(import ./penguin.nix defaults) // (import ./newImage.nix defaults)
