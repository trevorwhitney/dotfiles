#!/usr/bin/env zsh

current_dir=$(cd "$(dirname "$0")" && pwd)

cp -r "$current_dir/TerminalVim.app" /Applications/TerminalVim.app
