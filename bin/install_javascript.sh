#!/bin/bash
set -ex

current_dir=$(cd $(dirname $0) && pwd)
source $current_dir/utilities.sh

if $darwin; then
  [! `which npm` ] &&  brew install node
elif $ubuntu; then
  [! `which npm` ] &&  sudo apt-get install -y nodejs npm
else
  operating_system_unsupported
fi

npm install -g yarn
yarn global add purescript pulp bower elm elm-test elm-oracle elm-format yarn gulp eslint flow-bin flow-typed
