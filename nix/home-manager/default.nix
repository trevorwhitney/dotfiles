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
        [{ path = "${config.age.secrets.git.path}"; }];
    };

    age = {
      secrets = {
        openAiKey.file = ../secrets/openAiKey.age;
        git.file = ../secrets/git.age;
      };
      identityPaths = [ "${config.home.homeDirectory}/.config/agenix/id_ed25519" ];
      secretsDir = "${config.home.homeDirectory}/.agenix/secrets";
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

  username = "twhitney";
  defaults = {
    inherit
      agenix
      cfg
      home-manager
      imports
      pkgs
      system
      username;
  };
in
(import ./hosts/penguin.nix defaults) //
(import ./hosts/newImage.nix defaults) //
(import ./hosts/proxmox.nix { inherit pkgs home-manager username; })
