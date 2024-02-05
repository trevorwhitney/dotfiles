{ pkgs, system, home-manager, ... }:
let
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
      pkgs
      system;
    username = "twhitney";
  };
in
(import ./hosts/penguin.nix defaults ) // (import ./hosts/fiction.nix defaults)
