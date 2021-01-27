#!/usr/bin/env bash

function verify_package() {
  package=$(echo ${1} | rev | cut -d / -f 1 | rev)
  command -v "$package" > /dev/null
}

current_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
packages=$(cat "$current_dir/packages" | grep -v '^#')
for package in $packages; do
  if ! verify_package $package; then
    echo "Failed to find go package $package"
    exit 1;
  fi
done

golangci-lint --version > /dev/null
