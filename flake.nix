{
  description = "NixOS and Home Manager System Configs";

  inputs = {
    # TODO: pinned because build go module broken on error -> apple-framework-CoreFoundation-11.0.0: used as improper sort of dependency
    nixpkgs.url = "github:NixOS/nixpkgs/01885a071465e223f8f68971f864b15829988504";

    # Want certain packages from the bleeding-edge, but not the whole system.
    # These get pulled in via an overlay.
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    secrets = {
      #TODO: replace with https://github.com/ryantm/agenix
      url =
        "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=85b2b445e9e0a7f2996a5f7964e6f7ad8072f675";

      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Hardware specific configs
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # nix-alien allows running of programs with hardcoded link loaders
    # requires programs.nix-ld to be enabled
    # see: https://github.com/thiagokokada/nix-alien
    nix-alien.url = "github:thiagokokada/nix-alien";

    # run the latest jsonnet-language-server
    jsonnet-language-server.url = "github:grafana/jsonnet-language-server?dir=nix";

    # for remotely deploying nixos to machines
    deploy-rs.url = "github:serokell/deploy-rs";

    # my vim just the way I like it
    # neovim.url = "path:/home/twhitney/workspace/tw-vim-lib";
    # neovim.url = "path:/Users/twhitney/workspace/tw-vim-lib";
    neovim.url = "github:trevorwhitney/tw-vim-lib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";

    # for Loki shell
    loki.url = "github:grafana/loki";

    # for secrete management
    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    { self
    , agenix
    , deploy-rs
    , flake-utils
    , home-manager
    , jsonnet-language-server
    , loki
    , neovim
    , nix-alien
    , nixos-hardware
    , nixpkgs
    , nixos-unstable
    , secrets
    , ...
    }:
    let
      inherit (nixpkgs) lib;

      overlay = import ./nix/overlays;

      overlays = system: [
        (import "${self}/nix/overlays/nixpkgs-unstable.nix" {
          pkgs = import nixos-unstable {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
        })

        (import "${self}/nix/overlays/nix-alien.nix" {
          inherit nix-alien system;
        })

        (import "${self}/nix/overlays/deployment-tools.nix" {
          inherit secrets;
        })

        deploy-rs.overlay
        jsonnet-language-server.overlay
        neovim.overlay

        overlay
        secrets.overlay
      ];

      systems = [ "x86_64-linux" "aarch64-darwin" ];

      packages = lib.genAttrs systems (system:
        import nixpkgs {
          inherit system;
          overlays = overlays system;
          config = {
            allowUnfree = true;
          };
        }
      );

      modulesPath = "${nixpkgs}/nixos/modules";
    in
    {
      nixosConfigurations = {
        cerebral = lib.nixosSystem {
          system = "x86_64-linux";
          modules = import ./nix/hosts/cerebral {
            inherit self secrets lib modulesPath home-manager nixos-hardware;
            pkgs = packages.x86_64-linux;
          };
        };
      };

      inherit overlay;
      # TODO: there is duplication here from ./nix/overlays/default.nix
      overlays = {
        golang-perf = import "${self}/nix/overlays/golang-perf.nix";
        chart-testing = import "${self}/nix/overlays/chart-testing.nix";
        dotfiles = import "${self}/nix/overlays/dotfiles.nix";
        faillint = import "${self}/nix/overlays/faillint.nix";
        kubectl = import "${self}/nix/overlays/kubectl.nix";
        mixtool = import "${self}/nix/overlays/mixtool.nix";
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    } // (flake-utils.lib.eachSystem systems (system:
    {
      devShells = import ./nix/shells {
        inherit loki secrets;
        pkgs = packages.${system};
      };

      apps = import ./nix/apps {
        inherit loki secrets;
        pkgs = packages.${system};
      };

      packages = {
        homeConfigurations = import ./nix/home-manager {
          inherit agenix home-manager system;

          pkgs = packages.${system};
        };
      };
    }));
}
