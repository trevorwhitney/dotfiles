{
  description = "A general purpose development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    loki.url = "github:grafana/loki";
    loki.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, loki }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import ../../overlays/faillint.nix)
          ];
          config = { allowUnfree = true; };
        };
        nodejs = pkgs.nodejs_18;
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
            mage

            # NodeJS
            nodejs
            (yarn.override {
              inherit nodejs;
            })

            # Loki specific
            gcc
            golangci-lint
            faillint
            systemd
            yamllint
            yamllint
          ];
        };
      });
}
