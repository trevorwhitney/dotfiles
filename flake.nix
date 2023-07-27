{
  description = "NixOS and Home Manager System Configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";

    # Want certain packages from the bleeding-edge, but not the whole system.
    # These get pulled in via an overlay.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    #TODO: replace with https://github.com/ryantm/agenix
    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=85198bd9335dc4f4593c40f3635ecedf85e53592";

    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";

    # For running OpenGL apps outside of NixOS
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.inputs.flake-utils.follows = "flake-utils";

    # Hardware specific configs
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";

    # nix-alien allows running of programs with hardcoded link loaders
    # requires programs.nix-ld to be enabled
    # see: https://github.com/thiagokokada/nix-alien
    nix-alien.url = "github:thiagokokada/nix-alien";

    # run the latest jsonnet-language-server
    jsonnet-language-server.url = "github:grafana/jsonnet-language-server?dir=nix&rev=69230fe700d4bad6debcc2c11ed91cf1b035a892";
  };

  outputs =
    { self
    , flake-utils
    , home-manager
    , jsonnet-language-server
    , nix-alien
    , nixgl
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

        # Keep virtualbox on 6.x
        # since not all my images work on 7.x
        (import "${self}/nix/overlays/virtualbox.nix" {
          system = "x86_64-linux";
        })

        (import "${self}/nix/overlays/nix-alien.nix" {
          inherit nix-alien;
          system = "x86_64-linux";
        })

        (import "${self}/nix/overlays/kubectl.nix" {
          system = "x86_64-linux";
        })


        nixgl.overlay
        secrets.overlay
        jsonnet-language-server.overlay
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
      packages = {
        inherit (pkgs) i3-gnome-flashback;
      };
    }));
}
