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

function get_op_credential() {
  op get item $1 | jq -r '.details.sections | .[].fields | .[] | select(.n == "credential") | .v'
}

function get_op_username() {
  op get item $1 | jq -r '.details.sections | .[].fields | .[] | select(.n == "username") | .v'
}


sudo mkdir -p /etc/prometheus

cat <<PROMETHEUS | sudo tee /etc/prometheus/prometheus.yml
---
global:
  scrape_interval: 60s
  evaluation_interval: 60s
  scrape_timeout: 45s

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets: ["localhost:9093"]

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "speedtest"
    scrape_interval: 5m
    static_configs:
      - targets: ["localhost:9112"]

  - job_name: node
    static_configs:
      - targets: ["localhost:9100"]

  - job_name: process_exporter
    static_configs:
      - targets: ["localhost:9256"]

remote_write:
  - url: https://prometheus-blocks-prod-us-central1.grafana.net/api/prom/push
    basic_auth:
      username: $(op_get_username grafana-cloud-cerebral-publish)
      password: $(op_get_credential grafana-cloud-cerebral-publish)
PROMETHEUS
