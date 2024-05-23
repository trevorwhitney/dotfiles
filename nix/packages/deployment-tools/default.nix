{ stdenv, pkgs, secrets, lib, ... }:
let
  packages = pkgs.extend secrets.overlay;
  rev = "8ccd8fd5cfeb641e8b749dbc7c017120e512f157";

  deploymentTools = builtins.fetchGit {
    inherit rev;
    name = "deployment-tools";
    url = "git+ssh://git@github.com/grafana/deployment_tools";
  };

  gcom = packages.writeShellScriptBin "gcom" ''
    source ${packages.secrets}/grafana/deployment-tools.sh
    ${deploymentTools}/scripts/gcom/gcom "$@"
  '';
  gcom-ops = packages.writeShellScriptBin "gcom-ops" ''
    source ${packages.secrets}/grafana/deployment-tools.sh
    GCOM_TOKEN="''${GCOM_OPS_TOKEN}" ${deploymentTools}/scripts/gcom/gcom-ops "$@"
  '';
  gcom-dev = packages.writeShellScriptBin "gcom-dev" ''
    source ${packages.secrets}/grafana/deployment-tools.sh
    GCOM_TOKEN="''${GCOM_DEV_TOKEN}" ${deploymentTools}/scripts/gcom/gcom-dev "$@"
  '';

  flux-ignore = packages.writeShellScriptBin "flux-ignore" ''
    source ${packages.secrets}/grafana/deployment-tools.sh
    ${deploymentTools}/scripts/flux/ignore.sh "$@"
  '';

  rt = packages.writeShellScriptBin "rt" ''
    source ${packages.secrets}/grafana/deployment-tools.sh
    ${deploymentTools}/scripts/cortex/rt.sh "$@"
  '';

  grafana-sso = packages.writeShellScriptBin "grafana-sso" ''
    source ${packages.secrets}/grafana/deployment-tools.sh
    ${deploymentTools}/scripts/sso/aws.sh
    ${deploymentTools}/scripts/sso/gcloud.sh
  '';
in
stdenv.mkDerivation {
  pname = "deployment-tools";
  version = rev;

  src = deploymentTools;

  installPhase = ''
    mkdir -p $out/bin

    install -m755 ${gcom}/bin/gcom $out/bin/gcom
    install -m755 ${gcom-dev}/bin/gcom-dev $out/bin/gcom-dev
    install -m755 ${gcom-ops}/bin/gcom-ops $out/bin/gcom-ops
    install -m755 ${flux-ignore}/bin/flux-ignore $out/bin/flux-ignore
    install -m755 ${rt}/bin/rt $out/bin/rt
    install -m755 ${grafana-sso}/bin/grafana-sso $out/bin/grafana-sso
  '';

  meta = with lib; {
    description = "Grafana deployment tools";
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
