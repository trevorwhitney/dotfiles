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

if $darwin; then
  [ ! `which npm` ] &&  brew install node
elif $ubuntu; then
  if [ ! `which npm` ]; then
    wget -qO- https://deb.nodesource.com/setup_9.x | sudo bash -
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
