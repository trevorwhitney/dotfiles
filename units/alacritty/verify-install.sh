#!/usr/bin/env zsh

set -e

command -v alacritty > /dev/null
test -e "$HOME/.config/alacritty/alacritty-light.yml"
test -e "$HOME/.config/alacritty/alacritty-dark.yml"
test -e "$HOME/.config/alacritty/alacritty-popos.yml"
test -e "$HOME/.config/alacritty/base.yml"
test -e "$HOME/.config/alacritty/gruvbox-dark.yml"
test -e "$HOME/.config/alacritty/gruvbox.yml"
test -e "$HOME/.config/alacritty/remote-dark.yml"
test -e "$HOME/.config/alacritty/remote.yml"
test -e "$HOME/.config/alacritty/open-remote.yml"


test -e /usr/local/bin/open-file
