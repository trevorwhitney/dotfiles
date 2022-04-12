#!/usr/bin/env zsh

set -o pipefail

current_dir=$(cd "$(dirname $0)" && pwd)

mkdir -p "$HOME/workspace/grafana"

function get_op_credential() {
  op get item $1 | jq -r '.details.sections | .[].fields | .[] | select(.n == "credential") | .v'
}

op list items 2>&1 > /dev/null                                                                                                                                                                                                                             [11:11:32]
if [[ $? -ne 0 ]]; then
  eval "$(op signin my)"
fi

ln -sf "$current_dir/shell.nix" $HOME/workspace/grafana/shell.nix"

cat <<ENVRC > "$HOME/workspace/grafana/.envrc"
use nix
export BACKEND_ENTERPRISE_CHECKOUT_DIR=/home/twhitney/workspace/grafana/backend-enterprise
export LOGS_ENTERPRISE_CHECKOUT_DIR=/home/twhitney/workspace/grafana/enterprise-logs
export GO111MODULES=on
export GO111MODULE=on
export GOFLAGS="-mod=vendor"
export DRONE_SERVER=https://drone.grafana.net
export DRONE_TOKEN="$(get_op_credential grafana-drone)"
export TREVORWHITNEY_TOKEN="$(get_op_credential github-token)"
export CLOUDSDK_PYTHON=python2
export GCOM_TOKEN="$(get_op_credential grafana-com-gcom-admin)"
export GCOM_STAGING_TOKEN="$(get_op_credential grafana-staging-gcom-admin)"
ENVRC

ln -sf "$current_dir/shell.nix" "$HOME/workspace/grafana/shell.nix"
