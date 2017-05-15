#!/bin/bash

set -ex

function find_current_dir() {
  pushd $(dirname $0) > /dev/null
    current_dir=$(pwd)
  popd > /dev/null
  echo $current_dir
}
current_dir=$(find_current_dir $@)

source $current_dir/utilities.sh

if [ ! `which nvim` ]; then
  if $darwin; then
    brew install neovim/neovim/neovim
  elif $ubuntul; then
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install neovim
  else
    operating_system_unsupported
  fi
fi
