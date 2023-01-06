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
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = with pkgs; [
            shellcheck
            kubectl-1-22-15
          ];

          shellHook = ''
            export GRAFANA_TEAM="loki"
          '';
        };
      });
}
