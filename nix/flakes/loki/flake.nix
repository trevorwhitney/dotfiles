{
  description = "Grafana Loki";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    loki.url = "github:grafana/loki";
    loki.inputs.flake-utils.follows = "flake-utils";

    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=817364ca6919c2dd1462f1a316998c735d30d625";
    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, loki, secrets }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            loki.overlays.default
            /* loki.overlays.golangci-lint */
            secrets.overlay
            (import ../../overlays/kubectl.nix { inherit system; })
          ] ++ (import ./overlays);
          config = { allowUnfree = true; };
        };
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            chart-releaser
            chart-testing
            delve
            envsubst
            faillint
            gcc
            go
            golangci-lint
            gotools
            gotools
            gox
            helm-docs
            kubectl-1-22-15
            mixtool
            nettools
            nixpkgs-fmt
            statix
            systemd
            yamllint

            # Typescript for GitHub Actions
            nodejs
            (yarn.override {
              inherit nodejs;
            })
            nodePackages.typescript
            nodePackages.typescript-language-server
          ];

          shellHook = ''
            source ${pkgs.secrets}/grafana/deployment-tools.sh
            alias k="${pkgs.kubectl-1-22-15}/bin/kubectl"
          '';
        };
      });
}
