{
  description = "Flake for working with Grafana deployment_tools repo";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    secrets.url =
      "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=591a23a09549308469b1cfc59a1f5c10065dde11";
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
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = with pkgs; [
            shellcheck
          ];

          shellHook = ''
            source ${pkgs.secrets}/grafana/deployment-tools.sh
          '';
        };


        apps =
          let
            deploymentTools = builtins.fetchGit {
              # Descriptive name to make the store path easier to identify
              name = "deployment-tools";
              url = "https://github.com/grafana/deployment_tools";
              rev = "2df5edd74eacece52f7f3f3974de9285cceca1c8";
            };
          in
          {
            gcom = {
              type = "app";
              program = with pkgs; "${
                (writeShellScriptBin "gcom.sh" ''
                  source ${pkgs.secrets}/grafana/deployment-tools.sh
                  mkdir -p ''${XDG_CACHE_HOME}/gcom
                  ${deploymentTools}/scripts/gcom/gcom "$@"
                '')
              }/bin/gcom.sh";
            };

            gcom-dev = {
              type = "app";
              program = with pkgs; "${
                (writeShellScriptBin "gcom-dev.sh" ''
                  source ${pkgs.secrets}/grafana/deployment-tools.sh
                  mkdir -p ''${XDG_CACHE_HOME}/gcom
                  GCOM_TOKEN="''${GCOM_DEV_TOKEN}" ${deploymentTools}/scripts/gcom/gcom-dev "$@"
                '')
              }/bin/gcom-dev.sh";
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
