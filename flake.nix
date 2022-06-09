# nixos-rebuild swith --flake .#
# nix flake update --recreate-lock-file
{
  description = "Stem NixOS System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/releasse-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;

      config = nixkpkgs.config;

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
            (import "${home-mananger}/nixos")
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
