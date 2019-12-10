#!/usr/bin/env bash

current_dir=$(cd "$(dirname "$0")" && pwd)
dot_files_dir=$(cd "$current_dir/.." && pwd)
terminal_vim_dir=$(cd "$dot_files_dir/.tmux" && pwd)

cp -r "$terminal_vim_dir/TerminalVim.app" /Applications/TerminalVim.app
