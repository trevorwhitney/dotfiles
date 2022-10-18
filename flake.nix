{
  description = "Stem NixOS System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    neovim.inputs.flake-utils.follows = "flake-utils";

    #TODO: replace with https://github.com/ryantm/agenix
    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=904bba480a24103cb49b89a3cb78bf2e01143b17";
    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";

    dotfiles.url = "./nix/flakes/dotfiles";
    dotfiles.inputs.nixpkgs.follows = "nixpkgs";
    dotfiles.inputs.flake-utils.follows = "flake-utils";

    i3-gnome-flashback.url = "./nix/flakes/i3-gnome-flashback";
    i3-gnome-flashback.inputs.nixpkgs.follows = "nixpkgs";
    i3-gnome-flashback.inputs.flake-utils.follows = "flake-utils";

    # For running OpenGL apps outside of NixOS
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.inputs.flake-utils.follows = "flake-utils";

    # Firefox nightly
    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
  };

  outputs =
    { self
    , deploy-rs
    , dotfiles
    , flake-utils
    , home-manager
    , i3-gnome-flashback
    , neovim
    , nixgl
    , nixos-generators
    , nixpkgs
    , nixpkgs-mozilla
    , secrets
    , ...
    }:
    let
      inherit (nixpkgs) lib;
      overlays = [
        deploy-rs.overlay
        dotfiles.overlay
        i3-gnome-flashback.overlay
        neovim.overlay
        nixgl.overlay
        nixpkgs-mozilla.overlays.firefox
        secrets.overlay
      ];

      pkgs = import nixpkgs {
        inherit overlays;
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
        };
      };

      nix = import ./nix {
        inherit self secrets pkgs lib flake-utils home-manager;
        modulesPath = "${nixpkgs}/nixos/modules";
      };
    in
    {
      inherit (nix) nixosConfigurations;
      # deploy .#monterey
      deploy.nodes.monterey = {
        hostname = "monterey";
        sshUser = "twhitney";
        user = "root";
        profiles = {
          system = {
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."monterey";
          };
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
      homeConfigurations = {
        "twhitney@cerebral" = nix.homeConfigurations.x86_64-linux."twhitney@cerebral";
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
        monterey-vm = nixos-generators.nixosGenerate {
          inherit system;
          format = "virtualbox";
          modules = [
            ./nix/nixos/virtualbox.nix
            ./nix/hosts/monterey/root.nix
            ./nix/hosts/monterey/twhitney.nix
            {
              nixpkgs = {
                inherit pkgs;
                hostPlatform = "x86_64-linux";
              };
              virtualbox = {
                baseImageSize = 50 * 1024;
                memorySize = 2048;
                vmDerivationName = "monterey";
                vmName = "monterey";
                vmFileName = "monterey.ova";
                params = {
                  audio = "alsa";
                  usb = "on";
                };
              };
            }
          ];
        };
      };
    }));
}
