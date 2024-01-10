{
  description = "A basic flake with a shell";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    neovim.url = "path:/home/twhitney/workspace/tw-vim-lib";
    jsonnet-language-server.url = "github:grafana/jsonnet-language-server?dir=nix&ref=update-flake";
  };

  outputs = { self, nixpkgs, flake-utils, neovim, jsonnet-language-server }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            neovim.overlay
            jsonnet-language-server.overlay
          ];
          config = { allowUnfree = true; };
        };

        nodejs = pkgs.nodejs_18;
        goPkg = pkgs.go_1_21;

        env = pkgs.writers.writeBash "env.sh" ''
          export NODE_PATH="${nodejs}/lib/node_modules:$NODE_PATH"
          export NPM_CONFIG_PREFIX="${nodejs}"
        '';
        yarn = pkgs.yarn.override {
          inherit (pkgs) nodejs;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            gnumake
            zip


            # Golang
            delve
            goPkg
            gotools
            golangci-lint
            mage

            
            # NodeJS
            nodejs
            (yarn.override {
              inherit nodejs;
            })

            # python with extra packages needed for scripts
            (
              let
                extra-python-packages = python-packages:
                  with python-packages; [
                    gyp
                  ];
                python-with-packages = python311.withPackages extra-python-packages;
              in
              python-with-packages
            )

            (pkgs.writeShellScriptBin "jest" ''
              ${yarn}/bin/yarn exec jest "$@"
            '')
            (pkgs.writeShellScriptBin "eslint" ''
              ${yarn}/bin/yarn exec eslint "$@"
            '')


            (pkgs.neovim.override {
              inherit goPkg;
              nodeJsPkg = nodejs;

              withLspSupport = true;
              useEslintDaemon = false;
            })
          ];

          shellHook = ''
            source "${env}"
          '';
        };
      });
}
