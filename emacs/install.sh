#!/usr/bin/env bash

current_dir=$(cd $(dirname "$0") && pwd)
dot_files_dir=$(cd "$current_dir/.." && pwd)

source "$dot_files_dir/lib.sh"

mkdir -p "$HOME/.emacs.d"
git clone --depth 1 https://github.com/emacs-evil/evil ~/.emacs.d/evil

for file in `ls $current_dir/emacs.d`; do
    file_name=$(basename "$file")
    if [ -h "$HOME/.emacs.d/$file_name" ] || [ -e "$HOME/.emacs.d/$file_name" ]; then
      rm -rf "$HOME/.emacs.d/$file_name";
    fi

    ln -s "$current_dir/emacs.d/$file" "$HOME/.emacs.d/$file_name"
done

