{
  description = "Flake for working with Grafana deployment_tools repo";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=353ab08da814bc1402912ea9c41a22b1c3c06105";
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
          ];
        };
      in
      {
        defaultPackage = pkgs.kubectl-1-22-15;
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = with pkgs; [
            shellcheck
            kubectl-1-22-15
          ];

          shellHook = ''
            source ${pkgs.secrets}/grafana/deployment-tools.sh
            alias k="${pkgs.kubectl-1-22-15}/bin/kubectl"
          '';
        };
      });
}
