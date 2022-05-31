{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main";
    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";

    mosh.url = "./flakes/mosh";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    jsonnet-language-server.url = "./flakes/jsonnet-language-server";
    jsonnet-language-server.inputs.nixpkgs.follows = "nixpkgs";
    jsonnet-language-server.inputs.flake-utils.follows = "flake-utils";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , flake-utils
    , secrets
    , mosh
    , neovim-nightly-overlay
    , jsonnet-language-server
    , ...
    }: {
      homeConfigurations =
        let
          commonConfig = system: {
            inherit system;
            homeDirectory = "/home/twhitney";
            username = "twhitney";
          };

          commonImports = { system, config, pkgs, lib }: [
            ./nixpkgs/modules/common.nix
            ./nixpkgs/modules/bash.nix
            ./nixpkgs/modules/git.nix
            (import ./nixpkgs/modules/tmux.nix {
              inherit config pkgs lib;
              nixpkgs = import nixpkgs { inherit system; };
            })
            ./nixpkgs/modules/zsh.nix
          ];

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
          "twhitney@cerebral" =
            let system = "x86_64-linux";
            in
            home-manager.lib.homeManagerConfiguration (commonConfig system // {
              configuration = { config, pkgs, lib, ... }: {
                nixpkgs.overlays = overlays system;
                nixpkgs.config = {
                  allowUnfree = true;
                  allowBroken = true;
                };

                imports = [
                  ./nixpkgs/modules/media.nix
                  ./nixpkgs/modules/spotify.nix
                  (import ./nixpkgs/modules/neovim.nix {
                    inherit config lib pkgs;
                    withLspSupport = true;
                  })
                ] ++ commonImports { inherit config pkgs lib system; };

                # home.packages = commonPackages system;

                programs.git.includes =
                  [{ path = "${secrets.defaultPackage.${system}}/git"; }];

                programs.zsh.sessionVariables = { GPG_TTY = "$(tty)"; };
              };
            });

          "twhitney@penguin" =
            let system = "x86_64-linux";
            in
            home-manager.lib.homeManagerConfiguration (commonConfig system // {
              configuration = { config, pkgs, lib, ... }: {
                nixpkgs.overlays = overlays system;
                nixpkgs.config = {
                  allowUnfree = true;
                  allowBroken = true;
                };

                imports = [
                  (import ./nixpkgs/modules/neovim.nix {
                    inherit config pkgs lib;
                    withLspSupport = false;
                  })
                ] ++ commonImports { inherit config pkgs lib system; };

                programs.git.includes =
                  [{ path = "${secrets.defaultPackage.${system}}/git"; }];

                programs.zsh.sessionVariables = { GPG_TTY = "$(tty)"; };
              };
            });
        };
    };
}
