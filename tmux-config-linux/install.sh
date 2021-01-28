#!/usr/bin/env bash

current_dir=$(cd "$(dirname "$0")" && pwd)
dot_files_dir=$(cd "$current_dir/.." && pwd)

source "$dot_files_dir/lib.sh"

create_link "$current_dir/tmux.conf"
create_link "$current_dir/tmux.conf.local"
