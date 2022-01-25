#!/bin/bash

set -e

current_dir="$(cd "$(dirname "$0")" && pwd)"

function install_from_github_release() {
  process="$1"
  url="$2"
  package="$3"

  tmp=$(mktemp -d)
  version=$(jq -r ".$process" "$current_dir/versions.json")

  pushd "$tmp" > /dev/null || exit 1
    extrapolated_url=${url//%v/$version}
    extrapolated_package=${package//%v/$version}
    echo "Downloading release from $extrapolated_url/$extrapolated_package"
    curl -LkO "$extrapolated_url/$extrapolated_package"

    sudo dpkg -i "$extrapolated_package"
  popd > /dev/null || exit 1
  rm -rf "$tmp"
}

install_from_github_release process_exporter "https://github.com/ncabatoff/process-exporter/releases/download/v%v" "process-exporter_%v_linux_amd64.deb"

sudo cp "$current_dir/prometheus.yml" /etc/prometheus/prometheus.yml
