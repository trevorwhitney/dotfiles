#!/usr/bin/env bash

current_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
packages=$(cat $current_dir/packages | grep -v '^#')

pushd $GOPATH || exit 1
for package in $packages; do
  go get $package
done
popd || exit 1
