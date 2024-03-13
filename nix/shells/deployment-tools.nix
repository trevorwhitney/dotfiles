{ pkgs, secrets, ... }:
let
  packages = pkgs.extend secrets.overlay;
  deploymentTools = builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "deployment-tools";
    url = "https://github.com/grafana/deployment_tools";
    ref = "master";
  };
in
packages.mkShell {
  nativeBuildInputs = [ packages.bashInteractive ];

  packages = with packages; [
    argo
    jsonnet
    shellcheck
    kns-ktx

    (pkgs.neovim {
      withLspSupport = true;
      goPkg = go_1_21;
    })


    (writeShellScriptBin "gcom" ''
      source ${packages.secrets}/grafana/deployment-tools.sh
      ${deploymentTools}/scripts/gcom/gcom "$@"
    '')
    (writeShellScriptBin "gcom-ops" ''
      source ${packages.secrets}/grafana/deployment-tools.sh
      GCOM_TOKEN="''${GCOM_OPS_TOKEN}" ${deploymentTools}/scripts/gcom/gcom-ops "$@"
    '')
    (writeShellScriptBin "gcom-dev" ''
      source ${packages.secrets}/grafana/deployment-tools.sh
      GCOM_TOKEN="''${GCOM_DEV_TOKEN}" ${deploymentTools}/scripts/gcom/gcom-dev "$@"
    '')

    (writeShellScriptBin "flux-ignore" ''
      source ${packages.secrets}/grafana/deployment-tools.sh
      ${deploymentTools}/scripts/flux/ignore.sh "$@"
    '')

    (writeShellScriptBin "rt.sh" ''
      source ${packages.secrets}/grafana/deployment-tools.sh
      ${deploymentTools}/scripts/cortex/rt.sh "$@"
    '')
  ];

  shellHook = ''
    source ${packages.secrets}/grafana/deployment-tools.sh
  '';
}
