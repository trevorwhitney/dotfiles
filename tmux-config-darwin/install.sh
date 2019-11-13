#!/usr/bin/env bash

current_dir=$(cd "$(dirname "$0")" && pwd)
dot_files_dir=$(cd "$current_dir/.." && pwd)
tmux_dir=$(cd "$dot_files_dir/.tmux" && pwd)

source "$dot_files_dir/lib.sh"

create_link "$tmux_dir/.tmux.conf"
create_link "$current_dir/tmux.conf.local"
