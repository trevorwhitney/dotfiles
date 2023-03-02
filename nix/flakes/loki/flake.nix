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
            loki.overlays.golangci-lint
            secrets.overlay
            (import ../../overlays/kubectl.nix { inherit system; })
          ] ++ (import ./overlays);
          config = { allowUnfree = true; };
        };
      in
      {
        defaultPackage = pkgs.loki;
        packages = with pkgs; {
          inherit loki;
        };

        apps =
          {
            diff-config =
              let
                previousVersion = "2.6.1";
                previousVersionBranch = "v${previousVersion}";
                previousSource = pkgs.fetchFromGitHub {
                  owner = "grafana";
                  repo = "loki";
                  rev = previousVersionBranch;
                  sha256 = "sha256-6g0tzI6ZW+wwbPrNTdj0t2H0/M8+M9ioJl6iPL0mAtY=";
                };

                loki-old =
                  pkgs.loki.overrideAttrs (old: rec {
                    version = previousVersion;
                    src = previousSource;
                    doCheck = false;

                    configurePhase = with pkgs; ''
                      patchShebangs tools
                      substituteInPlace Makefile \
                        --replace "SHELL = /usr/bin/env bash -o pipefail" "SHELL = ${bash}/bin/bash -o pipefail" \
                        --replace "IMAGE_TAG := \$(shell ./tools/image-tag)" "IMAGE_TAG := ${previousVersion}" \
                        --replace "GIT_REVISION := \$(shell git rev-parse --short HEAD)" "GIT_REVISION := ${previousVersionBranch}" \
                        --replace "GIT_BRANCH := \$(shell git rev-parse --abbrev-ref HEAD)" "GIT_BRANCH := ${previousVersionBranch}" \
                    '';
                  });

                loki = pkgs.loki.overrideAttrs (old: rec {
                  doCheck = false;
                });
              in
              {
                type = "app";
                program = with pkgs; "${(writeShellScriptBin "diff-config" ''
              ${diffutils}/bin/diff --color=always --side-by-side \
                <(${loki-old}/bin/loki -config.file ${previousSource}/cmd/loki/loki-local-config.yaml -print-config-stderr 2>&1 \
                | sed '/Starting Loki/q') \
                <(${loki}/bin/loki -config.file ${loki}/cmd/loki/loki-local-config.yaml -print-config-stderr 2>&1 \
                | sed '/Starting Loki/q') \
                | ${less}/bin/less -R
            '')}/bin/diff-config";
              };
          };

        devShells.default = loki.devShell.${system}.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ (with pkgs;
            [
              kubectl-1-22-15
              envsubst
              mixtool
              gotools
            ]);

          shellHook = ''
            source ${pkgs.secrets}/grafana/deployment-tools.sh
            alias k="${pkgs.kubectl-1-22-15}/bin/kubectl"
          '';
        });
      });
}
