{
  description = "NixOS and Home Manager System Configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    # my vim just the way I like it
    # neovim.url = "path:/Users/twhitney/workspace/tw-vim-lib";
    neovim.url = "github:trevorwhitney/tw-vim-lib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    neovim.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # run the latest jsonnet-language-server
    # jsonnet-language-server.url = "github:grafana/jsonnet-language-server?dir=nix&ref=update-license";
    jsonnet-language-server.url = "github:grafana/jsonnet-language-server?dir=nix";

    # for remotely deploying nixos to machines
    deploy-rs.url = "github:serokell/deploy-rs";

    # for Loki shell
    loki.url = "github:grafana/loki";

    # for secret management
    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    { self
    , agenix
    , deploy-rs
    , determinate
    , flake-utils
    , home-manager
    , jsonnet-language-server
    , loki
    , neovim
    , nix-darwin
    , nixpkgs
    , nixpkgs-unstable
    , ...
    }:
    let
      inherit (nixpkgs) lib;

      systems = [ "x86_64-linux" "aarch64-darwin" ];

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
                config = {
                  allowUnfree = true;
                };
              };
          in
          base // {
            inherit (unstablePackages) aider-chat delve golangci-lint jujutsu lazyjj claude-code go;
            inherit (loki.packages.${system}) loki logcli promtail;

            go_1_24 = base.go;
            delve_1_24 = base.delve;
            golangci-lint_1_24 = base.golangci-lint;

            jsonnet-language-server = jsonnet-language-server.defaultPackage."${system}";
            neovim = neovim.neovim.${system};
            faillint = base.callPackage ./nix/packages/faillint { };
            
            # Migrated from overlays
            change-background = base.callPackage ./nix/packages/change-background { };
            golang-perf = base.callPackage ./nix/packages/golang-perf { };
            i3-gnome-flashback = base.callPackage ./nix/packages/i3-gnome-flashback { };
            inshellisense = base.callPackage ./nix/packages/inshellisense { };
            jdtls = base.callPackage ./nix/packages/jdtls { };
            pex = base.callPackage ./nix/packages/pex { };
            chart-testing-3_8_0 = base.callPackage ./nix/packages/chart-testing { };
            
            # Migrated from dotfiles.nix overlay
            tw-tmux-lib = (base.callPackage ./nix/packages/tmux-plugins { nixpkgs = base; }).tw-tmux-lib;
            dotfiles = base.callPackage ./nix/packages/dotfiles { };
            git-template = base.callPackage ./nix/packages/git-template { };
            kns-ktx = base.callPackage ./nix/packages/kns-ktx { };
            oh-my-zsh-custom = base.callPackage ./nix/packages/oh-my-zsh-custom { };
            gocomplete = base.callPackage ./nix/packages/gocomplete { };
            jsonnet-lint = base.callPackage ./nix/packages/jsonnet-lint { };
            mixtool = base.callPackage ./nix/packages/mixtool { };
            protoc-gen-gogofast = base.callPackage ./nix/packages/protoc-gen-gogofast { };
            protoc-gen-gogoslick = base.callPackage ./nix/packages/protoc-gen-gogoslick { };
            xk6 = base.callPackage ./nix/packages/xk6 { };
            stylua = base.callPackage ./nix/packages/stylua { };
          });
    in
    {
      nixosConfigurations = {
      };

      darwinConfigurations = {
        fiction = import ./nix/hosts/fiction {
          inherit self home-manager agenix loki nix-darwin determinate;
          pkgs = packages.aarch64-darwin;
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    } // (flake-utils.lib.eachSystem systems (system:
    {
      devShells = import ./nix/shells {
        inherit loki deploy-rs;
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
