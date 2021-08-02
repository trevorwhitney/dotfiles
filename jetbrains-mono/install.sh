#!/usr/bin/env zsh

jbTemp="$(mktemp -d)"

pushd "$jbTemp" > /dev/null || exit 1
  curl -LO https://download.jetbrains.com/fonts/JetBrainsMono-2.225.zip
  unzip JetBrainsMono-2.225.zip "fonts/ttf/*"
  mkdir -p ~/.local/share/fonts
  mv fonts/ttf/* ~/.local/share/fonts
popd

rm -rf $jbTemp

nerdTemp=$(mktemp -d)
pushd $nerdTemp > /dev/null || exit 1
  curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
  unzip JetBrainsMono.zip
  mkdir -p ~/.local/share/fonts
  mv * ~/.local/share/fonts
popd > /dev/null || exit 1

rm -rf $nerdTemp

sudo fc-cache -f -v
