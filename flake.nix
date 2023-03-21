{
  description = "NixOS and Home Manager System Configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";

    # Want certain packages from the bleeding-edge, but not the whole system.
    # These get pulled out via an overlay.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    neovim.inputs.flake-utils.follows = "flake-utils";

    #TODO: replace with https://github.com/ryantm/agenix
    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=817364ca6919c2dd1462f1a316998c735d30d625";

    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";

    # For running OpenGL apps outside of NixOS
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.inputs.flake-utils.follows = "flake-utils";

    # Hardware specific configs
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Firefox nightly
    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";

    # For creating nixos images for various platforms
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix User Repository
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    { self
    , flake-utils
    , home-manager
    , neovim
    , nixgl
    , nixos-generators
    , nixos-hardware
    , nixpkgs
    , nixpkgs-mozilla
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
              #TODO: what needs python 2.7?
              #Is it Davinci-resolve?
              permittedInsecurePackages = [
                "python-2.7.18.6"
              ];
            };
          };
        })

        (import "${self}/nix/overlays/dotfiles.nix")
        (import "${self}/nix/overlays/i3-gnome-flashback.nix")

        #TODO: required until possible to upgrade home-manager (> 22.05)
        # after going to nixos-unstable
        (import "${self}/nix/overlays/kitty-themes.nix")

        neovim.overlay
        nixgl.overlay
        nixpkgs-mozilla.overlays.firefox
        nixpkgs-mozilla.overlays.rust
        secrets.overlay
      ];

      pkgs = import nixpkgs {
        inherit overlays;
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
          #TODO: what needs python 2.7?
          #Is it Davinci-resolve?
          permittedInsecurePackages = [
            "python-2.7.18.6"
          ];
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
