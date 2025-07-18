{ stdenv
, pkgs
, lib
, deploymentToolsSecretsPath
, logcli ? pkgs.logcli
, ...
}:
let
  rev = "a94461d6ba4dcf76073d3719806c962bf259662b";

  # TODO: make this configurable
  # is there any way to avoid an absolute path?
  deploymentTools = /Users/twhitney/workspace/deployment_tools;

  gcom = pkgs.writeShellScriptBin "gcom" ''
    source ${deploymentToolsSecretsPath};
    ${deploymentTools}/scripts/gcom/gcom "$@"
  '';
  gcom-ops = pkgs.writeShellScriptBin "gcom-ops" ''
    source ${deploymentToolsSecretsPath};
    GCOM_TOKEN="''${GCOM_OPS_TOKEN}" ${deploymentTools}/scripts/gcom/gcom-ops "$@"
  '';
  gcom-dev = pkgs.writeShellScriptBin "gcom-dev" ''
    source ${deploymentToolsSecretsPath};
    GCOM_TOKEN="''${GCOM_DEV_TOKEN}" ${deploymentTools}/scripts/gcom/gcom-dev "$@"
  '';

  iap-token = pkgs.writeShellScriptBin "iap-token" ''
    source ${deploymentToolsSecretsPath};
    source ${deploymentTools}/scripts/gcom/lib.sh; get_iap_token "$@"
  '';

  id-token = pkgs.writeShellScriptBin "id-token" ''
    source ${deploymentToolsSecretsPath};
    source ${deploymentTools}/scripts/gcom/lib.sh; get_id_token
  '';

  flux-ignore = pkgs.writeShellScriptBin "flux-ignore" ''
    source ${deploymentToolsSecretsPath};
    ${deploymentTools}/scripts/flux/ignore.sh "$@"
  '';

  rt = pkgs.writeShellScriptBin "rt" ''
    source ${deploymentToolsSecretsPath};
    ${deploymentTools}/scripts/cortex/rt.sh "$@"
  '';

  grafana-sso = pkgs.writeShellScriptBin "grafana-sso" ''
    source ${deploymentToolsSecretsPath};
    ${deploymentTools}/scripts/sso/aws.sh reset workloads-prod
    ${deploymentTools}/scripts/sso/gcloud.sh
  '';

  timed-access = pkgs.writeShellScriptBin "timed-access" ''
    source ${deploymentToolsSecretsPath};

    # timed access handles aws login
    ${pkgs.gnumake}/bin/make -C ${deploymentTools} timed-access-cli ra
    ${deploymentTools}/scripts/sso/gcloud.sh
  '';

  _logcli = pkgs.writeShellScriptBin "logcli" ''
        source ${deploymentToolsSecretsPath};

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
          
              ${logcli}/bin/logcli --org-id 29 "$@"
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
          
                  ${logcli}/bin/logcli --org-id 29 "$@"
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
          
              ${logcli}/bin/logcli --org-id 29 "$@"
            else
              ${logcli}/bin/logcli "$@"
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
    install -m755 ${timed-access}/bin/timed-access $out/bin/timed-access
    install -m755 ${_logcli}/bin/logcli $out/bin/logcli
    install -m755 ${iap-token}/bin/iap-token $out/bin/iap-token
    install -m755 ${id-token}/bin/id-token $out/bin/id-token
  '';

  meta = with lib; {
    description = "Grafana deployment tools";
    maintainers = with maintainers; [ trevorwhitney ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
