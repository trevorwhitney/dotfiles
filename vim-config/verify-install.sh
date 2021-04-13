#!/usr/bin/env zsh
set -e

command -v vim > /dev/null
test -d "$HOME/.vim"
test -e "$HOME/.vim/config.vim"
test -e "$HOME/.vim/bundles.vim"