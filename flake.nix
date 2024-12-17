{
  description = "NixOS and Home Manager System Configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";

    # Currently only used for neovim, see below
    # Once I can run that on 24.11, I can remove this
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # my vim just the way I like it
    # neovim.url = "path:/home/twhitney/workspace/tw-vim-lib";
    # neovim.url = "path:/Users/twhitney/workspace/tw-vim-lib";
    neovim.url = "github:trevorwhitney/tw-vim-lib";
    # needs bleeding edge for CoreFoundation update, until https://github.com/NixOS/nixpkgs/pull/358321 is merged
    # to test, rebuild with new dependency, and then try to run a go test and debug a go test
    # the error will happen about linking clang, if the test passes then I can safely swtich back to the stable
    neovim.inputs.nixpkgs.follows = "nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
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
    # jsonnet-language-server.url = "github:grafana/jsonnet-language-server?dir=nix&ref=update-license";
    jsonnet-language-server.url = "github:grafana/jsonnet-language-server?dir=nix";

    # for remotely deploying nixos to machines
    deploy-rs.url = "github:serokell/deploy-rs";

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
    , nix-darwin
    , nixos-hardware
    , nixos-unstable
    , nixpkgs
    , secrets
    , ...
    }:
    let
      inherit (nixpkgs) lib;

      overlay = import ./nix/overlays;

      overlays = system: [
        (import "${self}/nix/overlays/nix-alien.nix" {
          inherit nix-alien system;
        })

        deploy-rs.overlay

        overlay
        secrets.overlay
      ];

      systems = [ "x86_64-linux" "aarch64-darwin" ];

      # as far as I can tell, overlays make packages to home-manager, 
      # while definitions here don't. though that's not true for neovim,
      # but is for deployment-tools?
      additionalPackages = (pkgs: system: {
        jsonnet-language-server = jsonnet-language-server.defaultPackage."${system}";
        neovim = neovim.neovim.${system};
        faillint = pkgs.callPackage ./nix/packages/faillint { };
        kubectl = pkgs.callPackage ./nix/packages/kubectl/1-25.nix { };
        deployment-tools = pkgs.callPackage ./nix/packages/deployment-tools {
          inherit (pkgs) stdenv lib;
          pkgs = pkgs // {
            inherit (loki.packages.${system}) loki logcli promtail;
          };
        };
      });

      packages = lib.genAttrs systems
        (system:
          let
            pkgs = import nixpkgs
              {
                inherit system;
                overlays = overlays system;
                config = {
                  allowUnfree = true;
                };
              };
          in
          pkgs // additionalPackages pkgs system);

      unstablePackages = lib.genAttrs systems
        (system:
          let
            pkgs = import nixos-unstable
              {
                inherit system;
                overlays = overlays system;
                config = {
                  allowUnfree = true;
                };
              };
          in
          pkgs // additionalPackages pkgs system);

      modulesPath = "${nixpkgs}/nixos/modules";
    in
    {
      nixosConfigurations = {
        cerebral = lib.nixosSystem {
          system = "x86_64-linux";
          modules = import ./nix/hosts/cerebral {
            inherit self secrets lib modulesPath home-manager nixos-hardware agenix;
            pkgs = packages.x86_64-linux;
          };
        };
      };

      darwinConfigurations = {
        fiction = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = import ./nix/hosts/fiction {
            inherit self secrets lib modulesPath home-manager nixos-hardware agenix;
            pkgs = unstablePackages.aarch64-darwin;
          };
        };
      };

      inherit overlay;
      # TODO: there is duplication here from ./nix/overlays/default.nix
      overlays = {
        golang-perf = import "${self}/nix/overlays/golang-perf.nix";
        chart-testing = import "${self}/nix/overlays/chart-testing.nix";
        dotfiles = import "${self}/nix/overlays/dotfiles.nix";
        mixtool = import "${self}/nix/overlays/mixtool.nix";
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    } // (flake-utils.lib.eachSystem systems (system:
    {
      devShells = import ./nix/shells {
        inherit loki secrets;
        pkgs = unstablePackages.${system};
      };

      apps = import ./nix/apps {
        inherit loki secrets;
        pkgs = unstablePackages.${system};
      };

      packages = {
        homeConfigurations = import ./nix/home-manager {
          inherit agenix home-manager system;

          pkgs = unstablePackages.${system};
        };
      };
    }));
}
