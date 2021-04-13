#!/usr/bin/env bash
current_dir=$(cd $(dirname $0) && pwd)

# Linking files is good for configurations
# we want to track changes to
create_link() {
    file_name="$(basename "$1" | sed "s/^\.//g")"
    if [ -h "$HOME/.$file_name" ] || [ -e "$HOME/.$file_name" ]; then
      rm -rf "$HOME/.$file_name";
    fi

    ln -s "$1" "$HOME/.$file_name"
}

# Linking files is good for configurations
# we want to track changes to. This creates a link in ~/.config/$1
create_config_link() {
    subdir_name="$1"
    mkdir -p "$HOME/.config/$subdir_name"
    file_name="$(basename "$2" | sed "s/^\.//g")"
    link="$HOME/.config/$subdir_name/$file_name"
    if [ -h "$link" ] || [ -e "$link" ]; then
      rm -rf "$link";
    fi

    ln -s "$2" "$link"
}

# Copying files is good for configurations that might
# have local overrides, since we don't want to track
# the local overrides in version control
copy_file() {
    file_name="$(basename "$1" | sed "s/^\.//g")"
    if [ ! -e "$HOME/.$file_name" ]; then
      cp "$1" "$HOME/.$file_name"
    fi
}

create_alias_link() {
    file_name="$(basename "$1" | sed "s/^\.//g")"
    if [ -h "$HOME/.bash_aliases.d/$file_name" ] || [ -e "$HOME/.bash_aliases.d/$file_name" ]; then
      rm -rf "$HOME/.bash_aliases.d/$file_name";
    fi

    ln -s "$1" "$HOME/.bash_aliases.d/$file_name"
}
