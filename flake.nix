{
  description = "NixOS and Home Manager System Configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # my vim just the way I like it
    # neovim.url = "path:/Users/twhitney/workspace/tw-vim-lib";
    neovim.url = "github:trevorwhitney/tw-vim-lib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    neovim.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";

    # TODO: I've updated to using 24.11, and it seems to work, but I'm going to leave thie comment here for a while
    # in case it breaks again.
    # needs bleeding edge for CoreFoundation update, until https://github.com/NixOS/nixpkgs/pull/358321 is merged
    # to test, rebuild with new dependency, and then try to run a go test and debug a go test
    # the error will happen about linking clang, if the test passes then I can safely swtich back to the stable
    # neovim.inputs.nixpkgs.follows = "nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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
    , nixpkgs
    , nixpkgs-unstable
    , ...
    }:
    let
      inherit (nixpkgs) lib;

      overlay = import ./nix/overlays;

      systems = [ "x86_64-linux" "aarch64-darwin" ];

      overlays = system: [
        (import "${self}/nix/overlays/nix-alien.nix" {
          inherit nix-alien system;
        })

        deploy-rs.overlay

        overlay
      ];

      packages = lib.genAttrs systems
        (system:
          let
            # Certain packages are pulled from unstable to get the latest version
            unstablePackages = import nixpkgs-unstable
              {
                inherit system;
                config = {
                  allowUnfree = true;
                };
              };

            base = import nixpkgs
              {
                inherit system;
                overlays = overlays system;
                config = {
                  allowUnfree = true;
                };
              };
          in
          base // {
            inherit (unstablePackages) aider-chat delve golangci-lint jujutsu lazyjj;
            inherit (loki.packages.${system}) loki logcli promtail;

            go_1_23 = base.go;
            delve_1_23 = base.delve;
            golangci-lint_1_23 = base.golangci-lint;

            go = unstablePackages.go_1_24;

            jsonnet-language-server = jsonnet-language-server.defaultPackage."${system}";
            neovim = neovim.neovim.${system};
            faillint = base.callPackage ./nix/packages/faillint { };
            kubectl = base.callPackage ./nix/packages/kubectl/1-25.nix { };
          });

      modulesPath = "${nixpkgs}/nixos/modules";
    in
    {
      nixosConfigurations = {
        # TODO: This is getting pretty old, is cerebral dead?
        # cerebral = lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = import ./nix/hosts/cerebral {
        #     inherit self secrets lib modulesPath home-manager nixos-hardware agenix;
        #     pkgs = packages.x86_64-linux;
        #   };
        # };
      };

      darwinConfigurations = {
        fiction = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = import ./nix/hosts/fiction {
            inherit self lib modulesPath home-manager nixos-hardware agenix loki;
            pkgs = packages.aarch64-darwin;
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
        inherit loki;
        pkgs = packages.${system};
      };

      apps = import ./nix/apps {
        inherit loki;
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
