#!/usr/bin/env zsh

installed=$(snap list | tail --lines +2 | cut -d ' ' -f 1)
function verify_package() {
  echo ${installed} | grep ${1} > /dev/null
}

current_dir=$(cd "$(dirname $0)" && pwd)
for package in $(< $current_dir/packages); do
  if ! verify_package $package; then
    echo "Failed to find snap package $package"
    exit 1;
  fi
done
