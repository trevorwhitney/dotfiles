#!/usr/bin/env zsh

current_dir=$(cd $(dirname "$0") && pwd)


create_code_link() {
    file_name="$(basename "$1" | sed "s/^\.//g")"
    code_location="$HOME/.config/Code/User/$file_name"

    if [ -h "$code_location" ] || [ -e "$code_location" ]; then
      rm -rf "$code_location";
    fi

    ln -s "$1" "$code_location"
}

create_code_link "$current_dir/keybindings.json"
create_code_link "$current_dir/settings.json"
