#!/usr/bin/env zsh
current_dir=$(cd "$(dirname "$0")" && pwd)
dot_files_dir=$(cd "$current_dir/.." && pwd)

source "$dot_files_dir/lib.sh"

mkdir -p "$HOME/.bash_aliases.d"
create_alias_link "$current_dir/maven-aliases.sh"
