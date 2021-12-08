#!/usr/bin/env zsh

current_dir=$(cd "$(dirname $0)" && pwd)

# kns and ktx from https://github.com/blendle/kns
ln -sf "$current_dir/kns" "$HOME/.local/bin/kns"
ln -sf "$current_dir/ktx" "$HOME/.local/bin/ktx"
