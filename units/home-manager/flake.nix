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
    , ...
    }: {
      homeConfigurations =
        let
          overlay-unstable = final: prev: {
            unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
          };

          overlay-neovim = neovim-nightly-overlay.overlay;
          commonConfig = system: {
            inherit system;
            # TODO: can you use builtins here?
            homeDirectory = "/home/twhitney";
            username = "twhitney";
          };

          commonImports = { system, config, pkgs, lib }: [
            ./nixpkgs/modules/common.nix
            ./nixpkgs/modules/bash.nix
            ./nixpkgs/modules/git.nix
            (import ./nixpkgs/modules/tmux.nix {
              inherit config pkgs lib;
              # TODO: is there a way to use a builtin to get the current system
              nixpkgs = import nixpkgs { inherit system; };
            })
            ./nixpkgs/modules/zsh.nix
          ];

          commonPackages = [ mosh.defaultPackage.x86_64-linux ];
        in
        {
          "twhitney@cerebral" =
            let system = "x86_64-linux";
            in
            self.inputs.home-manager.lib.homeManagerConfiguration
              (commonConfig system // {
                configuration = { config, pkgs, lib, ... }: {
                  nixpkgs.overlays = [ overlay-unstable overlay-neovim ];
                  nixpkgs.config = {
                    allowUnfree = true;
                    allowBroken = true;
                  };

                  imports = [
                    ./nixpkgs/modules/media.nix
                    ./nixpkgs/modules/spotify.nix
                    (import ./nixpkgs/modules/neovim.nix {
                      inherit config pkgs lib;
                      withLspSupport = true;
                    })
                  ] ++ commonImports { inherit config pkgs lib system; };

                  home.packages = commonPackages;

                  programs.git.includes =
                    [{ path = "${inputs.secrets.defaultPackage.${system}}/git"; }];

                  programs.zsh.sessionVariables = {
                    GPG_TTY = "$(tty)";
                  };
                };
              });

          "twhitney@penguin" =
            let system = "x86_64-linux";
            in
            self.inputs.home-manager.lib.homeManagerConfiguration
              (commonConfig system // {
                configuration = { config, pkgs, lib, ... }: {
                  nixpkgs.overlays = [ overlay-unstable overlay-neovim ];
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

                  home.packages = commonPackages;

                  programs.git.includes =
                    [{ path = "${inputs.secrets.defaultPackage.${system}}/git"; }];

                  programs.zsh.sessionVariables = {
                    GPG_TTY = "$(tty)";
                  };
                };
              });
        };
    };
}
