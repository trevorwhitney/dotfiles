#!/usr/bin/env zsh
source "$HOME/.zshrc"

set -e
test -e "$HOME/.fzf"
command -v fzf > /dev/null
