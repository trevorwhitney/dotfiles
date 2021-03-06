#!/usr/bin/env zsh

temp="$(mktemp -d)"

pushd "$temp" > /dev/null || exit 1
  curl -LO https://download.jetbrains.com/fonts/JetBrainsMono-2.225.zip
  unzip JetBrainsMono-2.225.zip "fonts/ttf/*"
  mkdir -p ~/.local/share/fonts
  mv fonts/ttf/* ~/.local/share/fonts
popd

sudo fc-cache -f -v

rm -rf $temp
