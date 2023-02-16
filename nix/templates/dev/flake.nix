{
  description = "A general purpose development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nodejs = pkgs.nodejs-16_x;
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # General
            bashInteractive
            gnumake

            # Golang
            go
            gotools
            golangci-lint
            mage

            # NodeJS
            nodejs
            (yarn.override {
              inherit nodejs;
            })
          ];
        };
      });
}
