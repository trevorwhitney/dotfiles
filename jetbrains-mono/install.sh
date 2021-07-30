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
  git clone git@github.com:ryanoasis/nerd-fonts.git
  pushd nerd-fonts > /dev/null || exit 1
    ./install.sh JetBrainsMono
  popd > /dev/null || exit 1
popd > /dev/null || exit 1

rm -rf $nerdTemp

sudo fc-cache -f -v
