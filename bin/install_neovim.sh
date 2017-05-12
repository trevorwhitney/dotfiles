#!/bin/bash

set -ex

current_dir=$(cd $(dirname $0) && pwd)
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
