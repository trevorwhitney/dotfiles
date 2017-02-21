#!/bin/bash

# Intalls powerline fonts
mkdir -p ~/tmp
pushd ~/tmp
  git clone https://github.com/powerline/fonts.git
  cd fonts
  ./install.sh
popd
rm -rf ~/tmp/fonts
