{
  description = "A general purpose development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              # golang-ci lint must be built with go 1.20 to work with go 1.20
              golangci-lint = prev.callPackage "${nixpkgs}/pkgs/development/tools/golangci-lint" {
                buildGoModule = prev.buildGo120Module;
              };
            })
            (import ../../overlays/faillint.nix)
          ];
        };
        nodejs = pkgs.nodejs-16_x;
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
          ];
        };
      });
}
