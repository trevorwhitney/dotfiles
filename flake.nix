{
  description = "NixOS and Home Manager System Configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

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

    nixgl = {
      # For running OpenGL apps outside of NixOS
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Hardware specific configs
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    # nix-alien allows running of programs with hardcoded link loaders
    # requires programs.nix-ld to be enabled
    # see: https://github.com/thiagokokada/nix-alien
    nix-alien.url = "github:thiagokokada/nix-alien";

    # run the latest jsonnet-language-server
    jsonnet-language-server.url = "github:grafana/jsonnet-language-server?dir=nix&ref=update-flake";

    devenv.url = "github:cachix/devenv";

    nixos-generators.url = "github:nix-community/nixos-generators";
    deploy-rs.url = "github:serokell/deploy-rs";

    neovim.url = "path:/home/twhitney/workspace/tw-vim-lib";
    neovim.inputs.nixpkgs.follows = "nixos-unstable";

    loki.url = "github:grafana/loki";
  };

  outputs =
    { self
    , deploy-rs
    , devenv
    , flake-utils
    , home-manager
    , jsonnet-language-server
    , loki
    , neovim
    , nix-alien
    , nixgl
    , nixos-generators
    , nixos-hardware
    , nixpkgs
    , nixos-unstable
    , nur
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

        (final: prev:
          let
            devenvPkgs = devenv.packages.${system};
          in
          {
            inherit (devenvPkgs) devenv;
          })


        deploy-rs.overlay
        jsonnet-language-server.overlay
        neovim.overlay
        nixgl.overlay
        overlay
        secrets.overlay
      ];

      systems = [ "x86_64-linux" ];

      packages = lib.genAttrs systems (system:
        import nixpkgs {
          inherit system;
          overlays = overlays system;
          config = {
            allowUnfree = true;
          };
        }
      );

      nix = import ./nix {
        inherit
          flake-utils
          home-manager
          lib
          nur nixos-hardware
          packages
          secrets
          self
          systems;

        modulesPath = "${nixpkgs}/nixos/modules";
      };
    in
    {
      inherit (nix) nixosConfigurations;

      homeConfigurations = {
        inherit (nix.homeConfigurations.x86_64-linux) "twhitney@cerebral" "twhitney@penguin" "twhitney@kolide";
      };

      templates = rec {
        dev = {
          path = "${self}/nix/templates/dev";
          description = "My Basic Development Environment";
        };
        default = dev;
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

      # TODO: this is not working because the vagrant box doesn't have the proper config
      # to allow me to sign packages I'm copying over
      deploy.nodes.dev-box = {
        hostname = "localhost";
        sshUser = "vagrant";
        user = "root";
        sshOpts = [ "-p" "2200" ]; # uses NAT interface on VM
        profiles = {
          system = {
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."dev-box";
          };
        };
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

      packages =
        let
          overlays = [
            (import "${self}/nix/overlays/dotfiles.nix")
            (import "${self}/nix/overlays/kubectl.nix")
            (import "${self}/nix/overlays/containers.nix" {
              inherit self nixos-generators;
            })

            jsonnet-language-server.overlay
          ];

          pkgs = import nixos-unstable {
            inherit overlays;
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
            };
          };
        in
        {
          inherit (pkgs) nvim-container dev-container;
        };
    }));
}
