{
  description = "Grafana Loki";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    loki.url = "github:grafana/loki";
    loki.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, loki }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            loki.overlays.default
            loki.overlays.golangci-lint
            (import ../../overlays/kubectl.nix { inherit system; })
          ];
          config = { allowUnfree = true; };
        };
      in
      {
        defaultPackage = pkgs.loki;
        packages = with pkgs; {
          inherit loki;
        };

        devShell = loki.devShell.${system}.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ (with pkgs; [
            kubectl-1-22-15
          ]);
        });
      });
}
