#!/bin/bash

# Intalls powerline fonts
mkdir -p ~/tmp
pushd ~/tmp
  git clone https://github.com/powerline/fonts.git
  pushd fonts
    ./install.sh
  popd
popd
rm -rf ~/tmp/fonts
