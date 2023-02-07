{
  description = "Flake for working with Grafana deployment_tools repo";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=817364ca6919c2dd1462f1a316998c735d30d625";
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


        apps =
          let
            deploymentTools = builtins.fetchGit {
              # Descriptive name to make the store path easier to identify
              name = "deployment-tools";
              url = "https://github.com/grafana/deployment_tools";
              rev = "3273159b1cd58f9db6d9e3f18bf595d9181d4f04";
            };
          in
          {
            gcom = {
              type = "app";
              program = with pkgs; "${
                (writeShellScriptBin "gcom.sh" ''
                  source ${pkgs.secrets}/grafana/deployment-tools.sh
                  ${deploymentTools}/scripts/gcom/gcom "$@"
                '')
              }/bin/gcom.sh";
            };


            flux-ignore = {
              type = "app";
              program = with pkgs; "${
                (writeShellScriptBin "flux-ignore.sh" ''
                  source ${pkgs.secrets}/grafana/deployment-tools.sh
                  ${deploymentTools}/scripts/flux/ignore.sh "$@"
                '')
              }/bin/flux-ignore.sh";
            };

            rt = {
              type = "app";
              program = with pkgs; "${
                (writeShellScriptBin "rt.sh" ''
                  source ${pkgs.secrets}/grafana/deployment-tools.sh
                  ${deploymentTools}/scripts/cortex/rt.sh "$@"
                '')
              }/bin/rt.sh";
            };
          };
      });
}
