#!/usr/bin/env zsh

set -e

sourcr "$HOME/.zshrc"
test -e "$HOME/.fzf"
command -v fzf > /dev/null
