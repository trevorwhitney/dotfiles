#!/bin/bash

set -e

current_dir="$(cd "$(dirname "$0")" && pwd)"
dotfiles_dir="$(cd "${current_dir}/../.." && pwd)"

source "${dotfiles_dir}/lib.sh"

artifact="$(download_from_github_release process_exporter \
  "https://github.com/ncabatoff/process-exporter/releases/download/v%v" \
  "process-exporter_%v_linux_amd64.deb" \
  "${current_dir}/versions.json")"

echo "installing ${artifact}"
sudo dpkg -i "${artifact}"
rm -rf "${artifact}"


sudo mkdir -p /etc/prometheus
sudo cp "$current_dir/prometheus.yml" /etc/prometheus/prometheus.yml
