#!/usr/bin/env bash

current_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
packages=$(cat $current_dir/packages | grep -v '^#')

pushd "$HOME/go" > /dev/null || exit 1
for package in $packages; do
  echo "installing go package $package"
  go get $package
done
popd > /dev/null || exit 1

curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.35.2

