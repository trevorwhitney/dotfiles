#!/usr/bin/env zsh

current_dir=$(cd "$(dirname $0)" && pwd)

mkdir -p "$HOME/workspace/grafana"
ln -s "$current_dir/envrc" "$HOME/workspace/grafana/.envrc"
