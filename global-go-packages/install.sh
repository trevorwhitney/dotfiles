#!/usr/bin/env zsh

current_dir=$(cd "$(dirname $0)" && pwd)

source "$HOME/.zshrc"
mkdir -p "$HOME/go"

pushd "$HOME/go" > /dev/null || exit 1
for package in $(< $current_dir/packages); do
  echo "installing go package $package"
  go get -u $package
done
popd > /dev/null || exit 1

curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.41.1


temp="$(mktemp -d)"
pushd $temp > /dev/null || exit 1
  curl -LO https://github.com/fatih/faillint/releases/download/v1.7.0/faillint_1.7.0_linux_amd64.deb
  sudo dpkg -i faillint_1.7.0_linux_amd64.deb
popd > /dev/null || exit 1

rm -rf $temp
