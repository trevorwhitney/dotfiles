#!/usr/bin/env zsh
source "$HOME/.zshrc"

function verify_package() {
  package=$(echo ${1} | rev | cut -d / -f 1 | rev)
  command -v "$package" > /dev/null
}

current_dir=$(cd "$(dirname $0)" && pwd)

for package in $(< $current_dir/packages); do
  if ! verify_package $package; then
    echo "Failed to find go package $package"
    exit 1;
  fi
done

golangci-lint --version > /dev/null
command -v faillint > /dev/null
