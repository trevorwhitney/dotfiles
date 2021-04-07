#!/usr/bin/env bash

temp="$(mktemp -d)"

pushd "$temp" > /dev/null || exit 1
  curl -LO https://download.jetbrains.com/fonts/JetBrainsMono-2.225.zip
  unzip -d "$HOME/.local/share/" JetBrainsMono-2.225.zip
popd

sudo fc-cache -f -v

rm -rf $temp
