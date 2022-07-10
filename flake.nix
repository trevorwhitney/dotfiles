{
  description = "Stem NixOS System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main";
    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";

    dotfiles.url = "./nix/flakes/dotfiles";
    dotfiles.inputs.nixpkgs.follows = "nixpkgs";
    dotfiles.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    dotfiles.inputs.flake-utils.follows = "flake-utils";
  };

  outputs =
    { self
    , dotfiles
    , flake-utils
    , home-manager
    , neovim-nightly-overlay
    , nixpkgs
    , nixpkgs-unstable
    , secrets
    , ...
    }:
    let
      system = "x86_64-linux";
      unstable = nixpkgs-unstable.legacyPackages."${system}";
      overlays = [
        neovim-nightly-overlay.overlay
        dotfiles.overlay
        (final: prev: {
          inherit unstable;
          #Packages to override from unstable
          inherit (unstable) gopls gotools jsonnet;
        })
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config = { allowUnfree = true; };
      };
    in
    {
      nixosConfigurations = {
        stem = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            { nixpkgs.pkgs = pkgs; }
            "${self}/hosts/stem/configuration.nix"
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.twhitney = {
                imports = [
                  ./nix/home-manager/common.nix
                  ./nix/home-manager/bash.nix
                  ./nix/home-manager/git.nix
                  { programs.git.gpgPath = with pkgs; "${gnupg}/bin/gpg"; }
                  ./nix/home-manager/i3.nix
                  ./nix/home-manager/tmux.nix
                  ./nix/home-manager/zsh.nix
                  ./nix/home-manager/neovim.nix
                  { programs.neovim = { withLspSupport = true; }; }
                ];

                programs.git.includes =
                  [{ path = "${secrets.defaultPackage.${system}}/git"; }];

                programs.zsh.sessionVariables = {
                  LD_LIBRARY_PATH =
                    "${pkgs.unstable.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
                };
              };
            }
          ];
        };
      };

      homeConfigurations =
        let
          username = "twhitney";
          homeDirectory = "/home/${username}";
          baseConfig = { inherit username homeDirectory pkgs; };

          sharedConfig = {
            programs.git.includes =
              [{ path = "${secrets.defaultPackage.${system}}/git"; }];
          };

          sharedImports = [
            ./nix/home-manager/common.nix
            ./nix/home-manager/bash.nix
            ./nix/home-manager/git.nix
            { programs.git.gpgPath = "/usr/bin/gpg"; }
            ./nix/home-manager/neovim.nix
            ./nix/home-manager/tmux.nix
            ./nix/home-manager/zsh.nix
          ];

        in
        {
          "twhitney@cerebral" = home-manager.lib.homeManagerConfiguration
            (baseConfig // {
              system = "x86_64-linux";

              configuration = sharedConfig // {
                imports = [
                  ./nix/home-manager/spotify.nix
                  {
                    programs.neovim = {
                      withLspSupport = true;
                      package = pkgs.neovim-nightly;
                    };
                  }
                ] ++ sharedImports;
              };
            });

          "twhitney@penguin" = home-manager.lib.homeManagerConfiguration
            (baseConfig // {
              system = "x86_64-linux";
              configuration = sharedConfig // {
                imports = [{
                  programs.neovim = {
                    withLspSupport = false;
                    package = pkgs.neovim-nightly;
                  };
                }] ++ sharedImports;

                programs.zsh.sessionVariables = { GPG_TTY = "$(tty)"; };
              };
            });
        };
    };
}
