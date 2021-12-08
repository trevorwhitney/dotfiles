#!/usr/bin/env zsh

set -e

test -e "$HOME/.config/alacritty/alacritty-crostini.yml"
# TODO: figure out how to get this into home-manager
# test -e "$HOME/.oh-my-zsh/custom/crostini.zsh"
test -e "/usr/share/applications/alacritty.desktop"
test -e "/usr/share/applications/firefox.desktop"
test -e "$HOME/.local/share/icons/alacritty.png"
test -e "$HOME/.local/share/icons/alacritty.svg"

command -v alacritty > /dev/null
