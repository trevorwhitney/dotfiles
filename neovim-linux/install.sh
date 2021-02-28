#!/usr/bin/env bash

set -e

temp=$(mktemp -d)
pushd $temp > /dev/null || exit 1
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  ./nvim.appimage --appimage-extract
  ./squashfs-root/AppRun --version

  # Optional: exposing nvim globally
  sudo rsync -avu squashfs-root/ /squashfs-root
  sudo ln -sf /squashfs-root/AppRun /usr/bin/nvim
popd > /dev/null || exit 1

rm -rf $temp
python3 -m pip install --user --upgrade pynvim
python2 -m pip install --user --upgrade pynvim
gem install neovim
npm install -g neovim
