{
  description = "Stem NixOS System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    jsonnet-language-server.url =
      "./units/home-manager/flakes/jsonnet-language-server";
    jsonnet-language-server.inputs.nixpkgs.follows = "nixpkgs";
    jsonnet-language-server.inputs.flake-utils.follows = "flake-utils";

    mosh.url = "./units/home-manager/flakes/mosh";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main";
    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , flake-utils
    , home-manager
    , jsonnet-language-server
    , mosh
    , neovim-nightly-overlay
    , secrets
    , ...
    }:
    let
      inherit (builtins) attrValues;
      inherit (flake-utils.lib) eachSystemMap defaultSystems;
      eachDefaultSystemMap = eachSystemMap defaultSystems;

      system = "x86_64-linux";
      overlays = system: [
        neovim-nightly-overlay.overlay
        (final: prev: {
          jsonnet-language-server =
            jsonnet-language-server.defaultPackage."${system}";
          unstable = nixpkgs-unstable.legacyPackages."${system}";
          mosh = mosh.defaultPackage."${system}";
        })
      ];

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          overlays = overlays system;
        };
      };

      lib = nixpkgs.lib;

      config = nixpkgs.config;

    in
    {
      nixosConfigurations = {
        stem = lib.nixosSystem {
          inherit system;

          modules = [ "${self}/hosts/stem/configuration.nix" ];
        };
      };

      # nix build .#homeManagerConfigurations.twhitney@stem.activationPackage
      # ./result/activate
      homeConfigurations = {
        "twhitney@stem" = home-manager.lib.homeManagerConfiguration {
          inherit system;
          homeDirectory = "/home/twhitney";
          username = "twhitney";

          nixpkgs = pkgs;

          configuration = { config, pkgs, lib, ... }: {
            nixpkgs.overlays = overlays system;

            imports = [
              ./units/home-manager/nixpkgs/modules/common.nix
              ./units/home-manager/nixpkgs/modules/bash.nix
              ./units/home-manager/nixpkgs/modules/git.nix
              (import ./units/home-manager/nixpkgs/modules/tmux.nix {
                inherit config pkgs lib;
                nixpkgs = pkgs;
              })
              ./units/home-manager/nixpkgs/modules/zsh.nix
              (import ./units/home-manager/nixpkgs/modules/neovim.nix {
                inherit config pkgs lib;
                withLspSupport = true;
              })
            ];

            programs.git.includes =
              [{ path = "${secrets.defaultPackage.${system}}/git"; }];
          };
        };
      };
    };
}
