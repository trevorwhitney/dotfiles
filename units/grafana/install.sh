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

cat <<ENVRC > "$HOME/workspace/grafana/.envrc"
export GOROOT="/usr/local/go@1.16"
export PATH="\$GOROOT/bin:\$PATH"
export BACKEND_ENTERPRISE_CHECKOUT_DIR=/home/twhitney/workspace/grafana/backend-enterprise
export GO111MODULES=on
export GO111MODULE=on
export GOFLAGS="-mod=vendor"
export DRONE_SERVER=https://drone.grafana.net
export DRONE_TOKEN="$(get_op_credential grafana-drone)"
export TREVORWHITNEY_TOKEN="$(get_op_credential github-token)"
export CLOUDSDK_PYTHON=python2
ENVRC
