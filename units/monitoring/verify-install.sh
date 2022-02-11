#!/bin/bash

set -e

command -v process-exporter > /dev/null
test -e /etc/prometheus/prometheus.yml

