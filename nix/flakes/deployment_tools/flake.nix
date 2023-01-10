{
  description = "Flake for working with Grafana deployment_tools repo";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    #TODO: replace with https://github.com/ryantm/agenix
    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=f30db379c7b2621ade6ff8a3114f924d65514751";
    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, secrets }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            secrets.overlay
            (import ../../overlays/kubectl.nix { inherit system; })
            # rt
            (final: prev: {
              scripts = prev.stdenv.mkDerivation {
                name = "scripts";
                pname = "scripts";

                buildInputs = [ prev.openssh ];

                src = builtins.fetchGit {
                  # use ssh for private repo
                  url = "ssh://git@github.com/grafana/deployment_tools";
                  rev = "f6a4c18b00f86256f4b00780caf02b49ee2044c3";
                };

                configurePhase = "patchShebangs scripts";

                installPhase = ''
                  mkdir -p $out/bin
                  install -m755 scripts/cortex/rt.sh $out/bin/rt
                  install -m755 scripts/flux/ignore.sh $out/bin/flux-ignore
                  install -m755 scripts/vault/vault-token $out/bin/vault-token
                  install -m755 scripts/tanka/tk $out/bin/tk
                '';
              };
            })
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = with pkgs; [
            shellcheck
            kubectl-1-22-15

            scripts
          ];

          shellHook = ''
            source ${pkgs.secrets}/grafana/deployment-tools.sh
          '';
        };
      });
}
