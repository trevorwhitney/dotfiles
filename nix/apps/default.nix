{ pkgs, loki, secrets, ... }:
let
  deploymentTools = builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "deployment-tools";
    url = "https://github.com/grafana/deployment_tools";
    rev = "2df5edd74eacece52f7f3f3974de9285cceca1c8";
  };

  # overlays needed for loki
  packages = pkgs.extend
    (self: super: with super.lib;
    (foldl' (flip extends) (_: super)
      [
        loki.overlays.default
        secrets.overlay

        (import ../overlays/kubectl.nix)
        (import ../overlays/faillint.nix)
        (import ../overlays/golang-perf.nix)
        (import ../overlays/chart-testing.nix)
      ]
      self
    ));
in
{
  gcom = {
    type = "app";
    program = with packages; "${
                (writeShellScriptBin "gcom.sh" ''
                  source ${packages.secrets}/grafana/deployment-tools.sh
                  mkdir -p ''${XDG_CACHE_HOME}/gcom
                  ${deploymentTools}/scripts/gcom/gcom "$@"
                '')
              }/bin/gcom.sh";
  };

  gcom-ops = {
    type = "app";
    program = with packages; "${
                (writeShellScriptBin "gcom-ops.sh" ''
                  source ${packages.secrets}/grafana/deployment-tools.sh
                  mkdir -p ''${XDG_CACHE_HOME}/gcom
                  GCOM_TOKEN="''${GCOM_OPS_TOKEN}" ${deploymentTools}/scripts/gcom/gcom-ops "$@"
                '')
              }/bin/gcom-ops.sh";
  };

  gcom-dev = {
    type = "app";
    program = with packages; "${
                (writeShellScriptBin "gcom-dev.sh" ''
                  source ${packages.secrets}/grafana/deployment-tools.sh
                  mkdir -p ''${XDG_CACHE_HOME}/gcom
                  GCOM_TOKEN="''${GCOM_DEV_TOKEN}" ${deploymentTools}/scripts/gcom/gcom-dev "$@"
                '')
              }/bin/gcom-dev.sh";
  };


  flux-ignore = {
    type = "app";
    program = with packages; "${
                (writeShellScriptBin "flux-ignore.sh" ''
                  source ${packages.secrets}/grafana/deployment-tools.sh
                  ${deploymentTools}/scripts/flux/ignore.sh "$@"
                '')
              }/bin/flux-ignore.sh";
  };

  rt = {
    type = "app";
    program = with packages; "${
                (writeShellScriptBin "rt.sh" ''
                  source ${packages.secrets}/grafana/deployment-tools.sh
                  ${deploymentTools}/scripts/cortex/rt.sh "$@"
                '')
              }/bin/rt.sh";
  };

  loki = {
    type = "app";
    program = "${packages.loki.overrideAttrs(old: { doCheck = false; })}/bin/loki";
  };
  promtail = {
    type = "app";
    program = "${packages.promtail.overrideAttrs(old: { doCheck = false; })}/bin/promtail";
  };
  logcli = {
    type = "app";
    program = "${packages.logcli.overrideAttrs(old: { doCheck = false; })}/bin/logcli";
  };
  loki-canary = {
    type = "app";
    program = "${packages.loki-canary.overrideAttrs(old: { doCheck = false; })}/bin/loki-canary";
  };
}
