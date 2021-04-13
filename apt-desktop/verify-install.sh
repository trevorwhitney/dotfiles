#!/usr/bin/env zsh

function verify_package() {
  package=${1}
  dpkg -s "$package" > /dev/null
}

current_dir=$(cd "$(dirname $0)" && pwd)
packages=$(cat "$current_dir/packages" | grep -v '^#')
for package in $packages; do
  if ! verify_package $package; then
    echo "Failed to find apt package $package"
    exit 1;
  fi
done