{
  description = "Grafana Loki";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    loki.url = "github:grafana/loki";
    loki.inputs.flake-utils.follows = "flake-utils";

    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=6ec3e905533937564c02bba29917e91ca6c31c7b";
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
            gox
            helm-docs
            mixtool
            nettools
            nixpkgs-fmt
            revive
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
          '';
        };

        apps = {
          loki = {
            type = "app";
            program = "${pkgs.loki.overrideAttrs(old: rec { doCheck = false; })}/bin/loki";
          };
          promtail = {
            type = "app";
            program = "${pkgs.promtail.overrideAttrs(old: rec { doCheck = false; })}/bin/promtail";
          };
          logcli = {
            type = "app";
            program = "${pkgs.logcli.overrideAttrs(old: rec { doCheck = false; })}/bin/logcli";
          };
          loki-canary = {
            type = "app";
            program = "${pkgs.loki-canary.overrideAttrs(old: rec { doCheck = false; })}/bin/loki-canary";
          };
        };
      });
}
