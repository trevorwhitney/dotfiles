#!/usr/bin/env zsh
set -e

command -v vim > /dev/null
test -d "$HOME/.vim"
test -d "$HOME/.vim/colors"
test -d "$HOME/.vim/undodir"
test -e "$HOME/.vim/pre-bundle.config.vim"
test -e "$HOME/.vim/config.vim"
test -e "$HOME/.vim/bundles.vim"
