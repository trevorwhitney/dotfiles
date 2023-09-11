{
  description = "Grafana Loki";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    loki.url = "github:grafana/loki";
    loki.inputs.flake-utils.follows = "flake-utils";

    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=b67cb614ab1dcefc005c8afa859a282a90d1add3";
    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, loki, secrets }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              loki.overlays.default
              /* loki.overlays.golangci-lint */
              secrets.overlay
              (import ../../overlays/kubectl.nix { inherit system; })
              (import ../../overlays/faillint.nix)
              (import ../../overlays/chart-testing.nix { inherit system; })
            ] ++ (import ./overlays);
            config = { allowUnfree = true; };
          };
        in
        {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              chart-releaser
              chart-testing-3_8_0
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
              trivy
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
