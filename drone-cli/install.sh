#!/usr/bin/env zsh

if [[ $(uname) = "Darwin" ]]; then
  echo "Installing Drone CI for Mac OS"
  pushd $(mktemp -d) || exit 1
    curl -L https://github.com/drone/drone-cli/releases/latest/download/drone_darwin_amd64.tar.gz \
      | tar zx
    sudo cp drone /usr/local/bin
  popd || exit 1
else
  echo "Installing Drone CI for Linux"
  pushd $(mktemp -d) || exit 1
    curl -L https://github.com/drone/drone-cli/releases/latest/download/drone_linux_amd64.tar.gz \
      | tar zx
    sudo install -t /usr/local/bin drone
  popd || exit 1
fi
