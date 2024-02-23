{ agenix
, home-manager
, pkgs
, system
, ...
}:
let
  config = {
    programs.git = {
      includes =
        [{ path = "${pkgs.secrets}/git"; }];
    };

    age = {
      secrets = {
        openApiKey.file = ../secrets/openApiKey.age;
      };
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
      home-manager
      imports
      pkgs
      system;
    username = "twhitney";
    cfg = config;
  };
in
(import ./hosts/penguin.nix defaults) // (import ./hosts/fiction.nix defaults)
