#!/usr/bin/env bash

temp="$(mktemp -d)"

pushd "$temp" > /dev/null || exit 1
  curl -LO https://download.jetbrains.com/fonts/JetBrainsMono-2.225.zip
  unzip JetBrainsMono-2.225.zip "fonts/ttf/*"
  mv fonts/ttf/* ~/.local/share/fonts
popd

sudo fc-cache -f -v

rm -rf $temp
