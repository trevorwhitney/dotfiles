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
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      NIX_LOG_DIR = "/nix/var/log/nix";
      NIX_STATE_DIR = "/nix/var/nix";
      NIX_STORE_DIR = "/nix/store";
      OPENAI_API_KEY = "$(${pkgs.coreutils}/bin/cat ${config.age.secrets.openApiKey.path})";
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
