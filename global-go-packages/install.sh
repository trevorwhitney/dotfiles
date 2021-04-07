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


temp="$(mktemp -d)"
pushd $temp > /dev/null || exit 1
  curl -LO https://github.com/fatih/faillint/releases/download/v1.7.0/faillint_1.7.0_linux_amd64.deb
  sudo dpkg -i faillint_1.7.0_linux_amd64.deb
popd > /dev/null || exit 1

rm -rf $temp
