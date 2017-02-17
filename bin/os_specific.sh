#!/bin/bash

current_dir=$(cd $(dirname $0) && pwd)
source $current_dir/utilities.sh

if $darwin; then
  defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms)
  defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
  defaults write com.apple.finder AppleShowAllFiles YES
fi
