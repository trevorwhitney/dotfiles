{ stdenv, pkgs, lib, ... }:
let
  rev = "13697fa180ff92d0482611b21d37f187e5ac413f";

  deploymentTools = builtins.fetchGit {
    inherit rev;
    name = "deployment-tools";
    url = "git+ssh://git@github.com/grafana/deployment_tools";
  };

  gcom = pkgs.writeShellScriptBin "gcom" ''
    source ${pkgs.secrets}/grafana/deployment-tools.sh
    ${deploymentTools}/scripts/gcom/gcom "$@"
  '';
  gcom-ops = pkgs.writeShellScriptBin "gcom-ops" ''
    source ${pkgs.secrets}/grafana/deployment-tools.sh
    GCOM_TOKEN="''${GCOM_OPS_TOKEN}" ${deploymentTools}/scripts/gcom/gcom-ops "$@"
  '';
  gcom-dev = pkgs.writeShellScriptBin "gcom-dev" ''
    source ${pkgs.secrets}/grafana/deployment-tools.sh
    GCOM_TOKEN="''${GCOM_DEV_TOKEN}" ${deploymentTools}/scripts/gcom/gcom-dev "$@"
  '';

  iap-token = pkgs.writeShellScriptBin "iap-token" ''
    source ${pkgs.secrets}/grafana/deployment-tools.sh
    source ${deploymentTools}/scripts/gcom/lib.sh; get_iap_token "$@"
  '';

  id-token = pkgs.writeShellScriptBin "id-token" ''
    source ${pkgs.secrets}/grafana/deployment-tools.sh
    source ${deploymentTools}/scripts/gcom/lib.sh; get_id_token
  '';

  flux-ignore = pkgs.writeShellScriptBin "flux-ignore" ''
    source ${pkgs.secrets}/grafana/deployment-tools.sh
    ${deploymentTools}/scripts/flux/ignore.sh "$@"
  '';

  rt = pkgs.writeShellScriptBin "rt" ''
    source ${pkgs.secrets}/grafana/deployment-tools.sh
    ${deploymentTools}/scripts/cortex/rt.sh "$@"
  '';

  grafana-sso = pkgs.writeShellScriptBin "grafana-sso" ''
    source ${pkgs.secrets}/grafana/deployment-tools.sh
    ${deploymentTools}/scripts/sso/aws.sh
    ${deploymentTools}/scripts/sso/gcloud.sh
    go run -C ${deploymentTools}/scripts/timed-access-cli . ra
  '';

  logcli = pkgs.writeShellScriptBin "logcli" ''
        source ${pkgs.secrets}/grafana/deployment-tools.sh

        mkdir -p ~/.config/loki
        if [[ "''${1}" == "--ops" ]]; then
          shift
          if [[ ! -e ~/.config/loki/loki-ops.env ]]; then
            cat <<EOF > ~/.config/loki/loki-ops.env
              export LOKI_PASSWORD="$(VAULT_INSTANCE=prod ${deploymentTools}/scripts/vault/vault-get -format json -field grafana-loki-read-key-ops secret/grafana-o11y/grafana-secrets | jq -r .)"
              export LOKI_USERNAME=29
              export LOKI_ADDR="https://logs-ops-002.grafana-ops.net"
EOF
          fi
          source ~/.config/loki/loki-ops.env
          
              ${pkgs.logcli}/bin/logcli --org-id 29 "$@"
            elif [[ "''${1}" == "--dev" ]]; then
              shift
              if [[ ! -e ~/.config/loki/loki-dev.env ]]; then
                cat <<EOF > ~/.config/loki/loki-dev.env
                  export LOKI_PASSWORD="$(VAULT_INSTANCE=dev ${deploymentTools}/scripts/vault/vault-get -format json -field grafana-loki-read-key secret/grafana-o11y/grafana-secrets | jq -r .)"
                  export LOKI_USERNAME=29
                  export LOKI_ADDR="https://logs-dev-005.grafana-dev.net"
EOF
              fi
              source ~/.config/loki/loki-dev.env
          
                  ${pkgs.logcli}/bin/logcli --org-id 29 "$@"
                elif [[ "''${1}" == "--dev" ]]; then
                  shift
                  if [[ ! -e ~/.config/loki/loki-dev.env ]]; then
                    cat <<EOF > ~/.config/loki/loki-dev.env
                      export LOKI_PASSWORD="$(VAULT_INSTANCE=dev ${deploymentTools}/scripts/vault/vault-get -format json -field grafana-loki-read-key secret/grafana-o11y/grafana-secrets | jq -r .)"
                      export LOKI_USERNAME=29
                      export LOKI_ADDR="https://logs-dev-005.grafana-dev.net"
EOF
                  fi
                  source ~/.config/loki/loki-dev.env
          
              ${pkgs.logcli}/bin/logcli --org-id 29 "$@"
            else
              ${pkgs.logcli}/bin/logcli "$@"
            fi

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
    install -m755 ${logcli}/bin/logcli $out/bin/logcli
    install -m755 ${iap-token}/bin/iap-token $out/bin/iap-token
    install -m755 ${id-token}/bin/id-token $out/bin/id-token
  '';

  meta = with lib; {
    description = "Grafana deployment tools";
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
