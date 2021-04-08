#!/usr/bin/env bash

command -v alacritty > /dev/null
test -e "$HOME/.config/alacritty/alacritty.yml"
test -e "$HOME/.config/alacritty/alacritty-dark.yml"
test -e "$HOME/.config/alacritty/base.yml"
test -e "$HOME/.config/alacritty/gruvbox-dark.yml"
test -e "$HOME/.config/alacritty/gruvbox.yml"
test -e "$HOME/.config/alacritty/remote-dark.yml"
test -e "$HOME/.config/alacritty/remote.yml"
