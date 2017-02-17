#!/bin/bash

if [ ! `which rbenv` ]; then
  git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
  git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build
fi

if [ ! `rbenv versions | grep 2.3.1` ]; then
  rbenv install 2.3.1
  pushd $HOME
    rbenv local 2.3.1
    gem install bundler neovim
  popd
fi
