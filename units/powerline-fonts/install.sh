#!/bin/bash

mkdir -p ~/workspace
pushd ~/workspace > /dev/null || exit 1
  git clone https://github.com/powerline/fonts.git
  pushd fonts > /dev/null || exit 1
    bash install.sh
  popd > /dev/null || exit 1

  rm -rf fonts
popd > /dev/null || exit 1
