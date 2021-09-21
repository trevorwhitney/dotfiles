#!/usr/bin/env zsh

set -e

test -e "$HOME/.config/alacritty/alacritty-crostini.yml"
test -e "$HOME/.oh-my-zsh/custom/crostini.zsh"
test -e "/usr/share/applications/alacritty.desktop"
test -e "$HOME/.local/share/icons/alacritty.png"
test -e "$HOME/.local/share/icons/alacritty.svg"

command -v alacritty > /dev/null
