{
  description = "A general purpose development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.loki.url = "github:grafana/loki";
  inputs.loki.inputs.flake-utils.follows = "flake-utils";

  outputs = { self, nixpkgs, flake-utils, loki }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            loki.overlays.default
            loki.overlays.golangci-lint
          ];
          config = { allowUnfree = true; };
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
