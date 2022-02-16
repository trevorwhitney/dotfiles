#!/usr/bin/env zsh

set -e

installed=$(flatpak list --app --columns=application | tail --lines +1)
function verify_package() {
  echo ${installed} | grep ${1} > /dev/null
}

current_dir=$(cd "$(dirname $0)" && pwd)
for package in $(< $current_dir/packages); do
  if ! verify_package $package; then
    echo "Failed to find flatpak package $package"
    exit 1;
  fi
done
