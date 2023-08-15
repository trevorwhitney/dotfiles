{
  description = "A general purpose development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        env = pkgs.writers.writeBash "env.sh" ''
          export NODE_PATH="${pkgs.nodejs}/lib/node_modules:$NODE_PATH"
          export NPM_CONFIG_PREFIX="${pkgs.nodejs}"
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # General
            bashInteractive
            gnumake

            # Golang
            delve
            go
            gotools
            golangci-lint
            faillint
            mage

            # NodeJS
            nodejs
            (yarn.override {
              inherit nodejs;
            })
            nodePackages.typescript
            nodePackages.typescript-language-server
          ];

          shellHook = ''
            source "${env}"
          '';
        };
      });
}
