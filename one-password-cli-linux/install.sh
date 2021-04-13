#!/usr/bin/env bash

current_dir="$(cd $(dirname "$0") && pwd)"
version="$(cat "$current_dir/version")"

pushd $(mktemp -d) || exit 1
  curl -Lko op.zip \
    "https://cache.agilebits.com/dist/1P/op/pkg/${version}/op_linux_amd64_${version}.zip"
  unzip op.zip op -d /usr/local/bin
popd || exit 1
