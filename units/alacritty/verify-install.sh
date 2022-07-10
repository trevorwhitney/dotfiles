#!/usr/bin/env zsh

set -e

command -v alacritty > /dev/null
test -e "$HOME/.config/alacritty/open-in-vim.yml"

test -e /usr/local/bin/open-in-vim

test -e "$HOME/.local/share/applications/open-in-vim.desktop"
test -e "$HOME/.local/share/applications/defaults.list"
