{
  description = "Flake for working with Grafana deployment_tools repo";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    dotfiles.url = "path:../../../";

    neovim.url = "path:/home/twhitney/workspace/tw-vim-lib";

    secrets.url =
      # "git+ssh://git@github.com/trevorwhitney/home-manager-secrets.git?ref=main&rev=85b2b445e9e0a7f2996a5f7964e6f7ad8072f675";
      "path:/home/twhitney/workspace/home-manager-secrets";
    secrets.inputs.nixpkgs.follows = "nixpkgs";
    secrets.inputs.flake-utils.follows = "flake-utils";

    # run the latest jsonnet-language-server
    jsonnet-language-server.url = "github:grafana/jsonnet-language-server?dir=nix&ref=v0.13.1";
  };


  outputs =
    { self
    , dotfiles
    , flake-utils
    , jsonnet-language-server
    , neovim
    , nixpkgs
    , secrets
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          secrets.overlay
          jsonnet-language-server.overlay
          neovim.overlay

          (import "${dotfiles}/nix/overlays/kubectl.nix")
        ];
      };

    in
    {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [ pkgs.bashInteractive ];
        buildInputs = with pkgs; [
          shellcheck
        ];

        packages = with pkgs; [
          argo
          shellcheck

          (neovim.override {
            withLspSupport = true;
            goPkg = go_1_21;
          })
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

          gcom-ops = {
            type = "app";
            program = with pkgs; "${
                (writeShellScriptBin "gcom-ops.sh" ''
                  source ${pkgs.secrets}/grafana/deployment-tools.sh
                  mkdir -p ''${XDG_CACHE_HOME}/gcom
                  GCOM_TOKEN="''${GCOM_OPS_TOKEN}" ${deploymentTools}/scripts/gcom/gcom-ops "$@"
                '')
              }/bin/gcom-ops.sh";
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
