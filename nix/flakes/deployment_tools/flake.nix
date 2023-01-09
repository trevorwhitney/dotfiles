{
  description = "Flake for working with Grafana deployment_tools repo";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import ../../overlays/kubectl.nix { inherit system; })
            # rt
            (final: prev: {
              scripts = prev.stdenv.mkDerivation {
                name = "scripts";
                pname = "scripts";

                src = /home/twhitney/workspace/deployment_tools;

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
            export GRAFANA_TEAM="loki"
          '';
        };
      });
}
