{
  description = "Stem NixOS System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim.url = "github:neovim/neovim?dir=contrib";

    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main";
    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";

    dotfiles.url = "./units/home-manager/flakes/dotfiles";
    dotfiles.inputs.nixpkgs.follows = "nixpkgs";
    dotfiles.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    dotfiles.inputs.flake-utils.follows = "flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , flake-utils
    , home-manager
    , neovim
    , secrets
    , dotfiles
    , ...
    }:
    let
      system = "x86_64-linux";
      overlays = [
        (final: prev: {
          jsonnet-language-server =
            dotfiles.packages."${system}";
          unstable = nixpkgs-unstable.legacyPackages."${system}";
          mosh = dotfiles.packages."${system}";
          neovim = neovim.defaultPackage."${system}";
        })
      ];

      pkgs = import nixpkgs {
        inherit system;
        overlays = overlays;

        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;
      config = nixpkgs.config; # TODO: is this used?
    in
    {
      nixosConfigurations = {
        stem = lib.nixosSystem {
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
                  ./units/home-manager/nixpkgs/modules/common.nix
                  ./units/home-manager/nixpkgs/modules/bash.nix
                  ./units/home-manager/nixpkgs/modules/git.nix
                  { programs.git.gpgPath = with pkgs; "${gnupg}/bin/gpg"; }
                  ./units/home-manager/nixpkgs/modules/tmux.nix
                  ./units/home-manager/nixpkgs/modules/zsh.nix
                  ./units/home-manager/nixpkgs/modules/neovim.nix
                  {
                    programs.neovim = {
                      withLspSupport = true;
                      package = pkgs.neovim;
                    };
                  }
                ];

                programs.git.includes =
                  [{ path = "${secrets.defaultPackage.${system}}/git"; }];

                # TODO: this was an attempt to fix tree-sitter grammars on stem,
                # currently not working
                programs.zsh.sessionVariables = {
                  LD_LIBRARY_PATH =
                    "${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
                };
              };
            }
          ];
        };
      };
    };
}
