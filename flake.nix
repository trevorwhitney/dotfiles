# nixos-rebuild swith --flake .#
# nix flake update --recreate-lock-file
{
  description = "Stem NixOS System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    jsonnet-language-server.url = "./units/home-manager/flakes/jsonnet-language-server";
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
    { nixpkgs
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
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;

      config = nixpkgs.config;

      overlays = system: [
        neovim-nightly-overlay.overlay
        (final: prev: {
          jsonnet-language-server =
            jsonnet-language-server.defaultPackage."${system}";
          unstable = nixpkgs-unstable.legacyPackages."${system}";
          mosh = mosh.defaultPackage."${system}";
        })
      ];
    in
    {
      nixosConfigurations = {
        stem = lib.nixosSystem {
          inherit system;

          modules = [
            "./hosts/stem/configuration.nix"
            (import "${home-manager}/nixos")
          ];
        };
      };

      # nix build .#homeManagerConfigurations.twhitney@stem.activationPackage
      # ./result/activate
      home-manager.users = {
        "twhitney@stem" = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          homeDirectory = "/home/twhitney";
          username = "twhitney";

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
}
