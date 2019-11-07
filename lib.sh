#!/usr/bin/env bash
current_dir=$(cd $(dirname $0) && pwd)

# Linking files is good for configurations
# we want to track changes to
create_link() {
    set -x
    echo "Args: $1"
    file_name="$(basename "$1")"
    echo "File name $file_name"
    if [ -h "$HOME/.$file_name" ] || [ -e "$HOME/.$file_name" ]; then
      rm -rf "$HOME/.$file_name";
    fi

    ln -s "$1" "$HOME/.$file_name"
}

# Copying files is good for configurations that might
# have local overrides, since we don't want to track
# the local overrides in version control
copy_file() {
    echo "Args: $1"
    file_name="$(basename "$1")"
    echo "File name: $file_name"
    if [ ! -e "$HOME/.$file_name" ]; then
      cp "$1" "$HOME/.$file_name"
    fi
}