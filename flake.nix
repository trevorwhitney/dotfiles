{
  description = "NixOS and Home Manager System Configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";

    # Want certain packages from the bleeding-edge, but not the whole system.
    # These get pulled in via an overlay.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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
    jsonnet-language-server.url = "github:grafana/jsonnet-language-server?dir=nix&ref=v0.13.1";

    devenv.url = "github:cachix/devenv";

    nixos-generators.url = "github:nix-community/nixos-generators";
    deploy-rs.url = "github:serokell/deploy-rs";

    neovim.url = "path:/home/twhitney/workspace/tw-vim-lib";
  };

  outputs =
    { self
    , deploy-rs
    , devenv
    , flake-utils
    , home-manager
    , jsonnet-language-server
    , neovim
    , nix-alien
    , nixgl
    , nixos-generators
    , nixos-hardware
    , nixpkgs
    , nixpkgs-unstable
    , nur
    , secrets
    , ...
    }:
    let
      inherit (nixpkgs) lib;

      overlays = [
        # Selectively pick packages from nixpkgs-unstable
        (import "${self}/nix/overlays/nixpkgs-unstable.nix" {
          pkgs = import nixpkgs-unstable {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
            };
          };
        })

        (import "${self}/nix/overlays/dotfiles.nix")
        (import "${self}/nix/overlays/i3-gnome-flashback.nix")
        (import "${self}/nix/overlays/dynamic-dns-reporter.nix")
        (import "${self}/nix/overlays/kubectl.nix")
        (import "${self}/nix/overlays/pex.nix")
        (import "${self}/nix/overlays/inshellisense.nix")

        (import "${self}/nix/overlays/nix-alien.nix" {
          inherit nix-alien;
          system = "x86_64-linux";
        })

        nixgl.overlay
        secrets.overlay
        jsonnet-language-server.overlay
        deploy-rs.overlay

        # (import "${self}/nix/overlays/neovim.nix")
        neovim.overlay

        (final: prev:
          let
            devenvPkgs = devenv.packages."x86_64-linux";
          in
          {
            inherit (devenvPkgs) devenv;
          })
      ];

      pkgs = import nixpkgs {
        inherit overlays;
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
        };
      };

      nix = import ./nix {
        inherit self secrets pkgs lib flake-utils home-manager nur nixos-hardware;
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

      # TODO: compose these into the default
      overlays = {
        dotfiles = import "${self}/nix/overlays/dotfiles.nix";
        kubectl = import "${self}/nix/overlays/kubectl.nix";
        faillint = import "${self}/nix/overlays/faillint.nix";
        chart-testing = import "${self}/nix/overlays/chart-testing.nix";
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
    } // (flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
        };
      };

    in
    {
      devShells = {
        default = import ./shell.nix { inherit pkgs; };
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

          pkgs = import nixpkgs-unstable {
            inherit overlays;
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
            };
          };
        in
        {
          inherit (pkgs) nvim-container dev-container dev-box;
        };
    }));
}
