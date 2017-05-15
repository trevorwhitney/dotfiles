#!/bin/bash

function find_current_dir() {
  pushd $(dirname $0) > /dev/null
    current_dir=$(pwd)
  popd > /dev/null
  echo $current_dir
}
current_dir=$(find_current_dir $@)

source $current_dir/utilities.sh

set -ex

if [ ! `which stack` ]; then
  curl -sSL https://get.haskellstack.org/ | sh
fi

export PATH=$HOME/.local/bin:$PATH

pushd $dotfiles_dir
  if $darwin; then
    stack setup --allow-different-user
  else
    su -c 'stack setup' -- $DOTFILES_USER
  fi

  stack install hlint stylish-haskell hindent ghc-mod hdevtools fast-tags
popd
