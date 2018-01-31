#!/bin/bash

set -ex

if [ ! `which rbenv` ]; then
  git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
  git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build
fi

export RBENV_ROOT=$HOME/.rbenv
export PATH=$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH

# FIXME: Need to figure out the gcc version, and compile against gcc-5 instead of gcc-7
if [ ! -e $HOME/.rbenv/versions/2.3.1 ]; then
  rbenv install 2.3.1
  pushd $HOME
    rbenv local 2.3.1
    gem install bundler neovim
  popd
fi
