{
  description = "Standard development envrionment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    jsonnet-language-server.url = "github:grafana/jsonnet-language-server?dir=nix&ref=v0.13.1";
    neovim.url = "path:/home/twhitney/workspace/tw-vim-lib";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self
    , flake-utils
    , jsonnet-language-server
    , neovim
    , nixpkgs
    }:
    (flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            neovim.overlay
            jsonnet-language-server.overlay

            (import ../../overlays/faillint.nix)
          ];
          config = { allowUnfree = true; };
        };

        nodejs = pkgs.nodejs_18;
        goPkg = pkgs.go_1_21;

        env = pkgs.writers.writeBash "env.sh" ''
          export NODE_PATH="${nodejs}/lib/node_modules:$NODE_PATH"
          export NPM_CONFIG_PREFIX="${nodejs}"
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # General
            bashInteractive
            gnumake
            zip

            # Golang
            delve
            go_1_21
            gotools
            golangci-lint
            faillint
            mage

            # NodeJS
            nodejs
            (yarn.override {
              inherit nodejs;
            })

            (pkgs.neovim.override {
              inherit goPkg;
              nodeJsPkg = nodejs;
              withLspSupport = true;
            })

            # python with extra packages needed for scripts
            (
              let
                extra-python-packages = python-packages:
                  with python-packages; [
                    gyp
                  ];
                python-with-packages = python311.withPackages
                  extra-python-packages;
              in
              python-with-packages
            )
          ];

          shellHook = ''
            source "${env}"
          '';
        };
      }));
}
