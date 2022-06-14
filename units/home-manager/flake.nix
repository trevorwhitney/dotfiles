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

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    dotfiles.url = "./flakes/dotfiles";
    dotfiles.inputs.nixpkgs.follows = "nixpkgs";
    dotfiles.inputs.flake-utils.follows = "flake-utils";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-unstable
    , dotfiles
    , home-manager
    , flake-utils
    , secrets
    , neovim-nightly-overlay
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
            { programs.git.gpgPath = "/usr/bin/gpg"; }
            ./nixpkgs/modules/tmux.nix
            ./nixpkgs/modules/zsh.nix
          ];

          overlays = system: [
            neovim-nightly-overlay.overlay
            dotfiles.overlay
            (final: prev: {
              unstable = nixpkgs-unstable.legacyPackages."${system}";
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
                  ./nixpkgs/modules/neovim.nix
                  {
                    programs.neovim = {
                      withLspSupport = true;
                      package = pkgs.neovim-nightly;
                    };
                  }
                ] ++ commonImports { inherit config pkgs lib system; };

                # home.packages = commonPackages system;

                programs.git.includes =
                  [{ path = "${secrets.defaultPackage.${system}}/git"; }];
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
                  ./nixpkgs/modules/neovim.nix
                  {
                    programs.neovim = {
                      withLspSupport = false;
                      package = pkgs.neovim-nightly;
                    };
                  }
                ] ++ commonImports { inherit config pkgs lib system; };

                programs.git.includes =
                  [{ path = "${secrets.defaultPackage.${system}}/git"; }];

                programs.zsh.sessionVariables = { GPG_TTY = "$(tty)"; };
              };
            });
        };
    };
}
