{ agenix
, home-manager
, pkgs
, system
, ...
}:
let
  cfg = { config, pkgs, ... }: {
    programs.git = {
      includes =
        [{ path = "${pkgs.secrets}/git"; }];
    };

    age = {
      secrets = {
        openApiKey.file = ../secrets/openApiKey.age;
      };
      identityPaths = [ "${config.home.homeDirectory}/.config/agenix/id_ed25519" ];
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      NIX_LOG_DIR = "/nix/var/log/nix";
      NIX_STATE_DIR = "/nix/var/nix";
      NIX_STORE_DIR = "/nix/store";
      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
    };

  };

  imports = [
    agenix.homeManagerModules.default
    {
      home.packages = [
        agenix.packages."${system}".default
      ];
    }
  ];

  defaults = {
    inherit
      agenix
      cfg
      home-manager
      imports
      pkgs
      system;
    username = "twhitney";
  };
in
(import ./hosts/penguin.nix defaults) // (import ./hosts/fiction.nix defaults)
