#!/bin/bash

function find_current_dir() {
  pushd $(dirname $0) > /dev/null
    current_dir=$(pwd)
  popd > /dev/null
  echo $current_dir
}
current_dir=$(find_current_dir $@)

source $current_dir/utilities.sh

if $darwin; then
  defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms)
  defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
  defaults write com.apple.finder AppleShowAllFiles YES
fi
