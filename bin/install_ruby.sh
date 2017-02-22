#!/bin/bash

set -ex

if [ ! `which rbenv` ]; then
  git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
  git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build
fi

export RBENV_ROOT=$HOME/.rbenv
export PATH=$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH

if [ ! `rbenv versions | grep 2.3.1` ]; then
  rbenv install 2.3.1
  pushd $HOME
    rbenv local 2.3.1
    gem install bundler neovim
  popd
fi
