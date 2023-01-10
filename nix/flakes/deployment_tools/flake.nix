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
            (import ../../overlays/deployment-tools.nix)
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = with pkgs; [
            shellcheck
            kubectl-1-22-15

            deployment-tools
          ];

          shellHook = ''
            source ${pkgs.secrets}/grafana/deployment-tools.sh
          '';
        };
      });
}
