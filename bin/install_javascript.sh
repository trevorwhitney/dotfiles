#!/bin/bash
set -ex

current_dir=$(cd $(dirname $0) && pwd)
source $current_dir/utilities.sh

if $darwin; then
  [ ! `which npm` ] &&  brew install node
elif $ubuntu; then
  if [ ! `which npm` ]; then
    wget -qO- https://deb.nodesource.com/setup_7.x | sudo bash -
    sudo apt-get install -y nodejs
  fi
else
  operating_system_unsupported
fi

# Needs to not be root on OSX, unsure about Ubuntu
[ ! `which yarn` ] && npm install -g yarn
yarn global add \
  purescript\
  pulp\
  bower\
  elm \
  elm-test\
  elm-oracle\
  elm-format\
  gulp\
  eslint\
  flow-bin\
  flow-typed\
  tern \
  --prefix /usr/local
