#!/usr/bin/env zsh

set -e

# source "$HOME/.zshrc"
command -v home-manager > /dev/null
test -e "$HOME/.config/nixpkgs"
test -e "$HOME/.config/nixpkgs/home.nix"
