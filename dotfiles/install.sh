#!/usr/bin/env bash

current_dir=$(cd $(dirname $0) && pwd)

# Linking files is good for configurations
# we want to track changes to
create_link() {
    if [ -h "$HOME/.$1" ] || [ -e "$HOME/.$1" ]; then
        rm -rf "$HOME/.$1";
    fi

    ln -s "$current_dir/$1" "$HOME/.$1"
}

create_link ctags
create_link dircolors
create_link gitignore_global
create_link git_template
create_link tmux.conf
create_link emacs

# Copying files is good for configurations that might
# have local overrides, since we don't want to track
# the local overrides in version control
copy_file() {
    if [ ! -e "$HOME/.$1" ]; then
        cp "$current_dir/$1" "$HOME/.$1"
    fi
}

copy_file gitconfig
