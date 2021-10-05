#!/usr/bin/env zsh

command -v kubectl > /dev/null
kubectl version --client > /dev/null

test -e "$HOME/.local/bin/kns"
test -e "$HOME/.local/bin/ktx"
