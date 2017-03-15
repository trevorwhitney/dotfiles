#!/bin/bash
set -ex

current_dir=$(cd $(dirname $0) && pwd)
source $current_dir/utilities.sh

if $darwin; then
  [ ! `which npm` ] &&  brew install node
elif $ubuntu; then
  if [ ! `which npm` ]; then
    wget -qO- https://deb.nodesource.com/setup_4.x | sudo bash -
    sudo apt-get install -y nodejs
  fi
else
  operating_system_unsupported
fi

[ ! `which yarn` ] && sudo npm install -g yarn
sudo yarn global add \
  purescript\
  pulp\
  bower\
  elm \
  elm-test\
  elm-oracle\
  elm-format\
  yarn\
  gulp\
  eslint\
  flow-bin\
  flow-typed\
  tern \
  --prefix /usr/local
